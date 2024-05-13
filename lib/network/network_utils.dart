import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/base_response.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/woo_commerce/query_string.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:crypto/crypto.dart' as crypto;

Map<String, String> buildHeaderTokens({Map? extraKeys, bool requiredNonce = false, bool requiredToken = true, bool isOAuth = false}) {
  if (extraKeys == null) {
    extraKeys = {};
    extraKeys.putIfAbsent('isStripePayment', () => false);
  }
  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
  };

  if (appStore.isLoggedIn && extraKeys.containsKey(ConstantKeys.isStripePayKey) && extraKeys[ConstantKeys.isStripePayKey]) {
    header.putIfAbsent(HttpHeaders.contentTypeHeader, () => ApiHeaders.contentTypeHeaderWWWForm);
    if (requiredToken) header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${extraKeys![ConstantKeys.stripeKeyPaymentKey]}');
  } else {
    header.putIfAbsent(HttpHeaders.contentTypeHeader, () => ApiHeaders.contentTypeHeaderApplicationJson);
    header.putIfAbsent(HttpHeaders.acceptHeader, () => ApiHeaders.acceptHeader);
    if (isOAuth) {
      header.putIfAbsent(ApiHeaders.accessControlAllowHeader, () => '*');
      header.putIfAbsent(ApiHeaders.accessControlAllowOriginHeader, () => '*');
    }
    if (appStore.isLoggedIn && requiredToken) {
      header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${getStringAsync(TOKEN)}');
    }
  }

  if (requiredNonce) header.putIfAbsent(ApiHeaders.headerNonceKey, () => appStore.nonce);

  return header;
}

Uri buildBaseUrl(String endPoint, {String requestMethod = '', bool isOAuth = false}) {
  Uri url = Uri.parse(endPoint);

  if (endPoint.startsWith('http'))
    url = Uri.parse(endPoint);
  else if (isOAuth) {
    url = Uri.parse(_getOAuthURL(requestMethod: requestMethod, endpoint: endPoint));
  } else
    url = Uri.parse('${appStore.tempBaseUrl}$endPoint');

  return url;
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethod method = HttpMethod.GET,
  Map? request,
  bool isOauth = false,
  bool headerRequired = true,
  bool requiredNonce = false,
  bool requiredToken = true,
}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens(requiredNonce: requiredNonce, requiredToken: requiredToken, isOAuth: isOauth);

    Uri url = buildBaseUrl(endPoint, requestMethod: method.toString(), isOAuth: isOauth);

    Response response;

    if (method == HttpMethod.POST) {
      response = await http.post(url, body: jsonEncode(request), headers: headerRequired ? headers : {});
    } else if (method == HttpMethod.DELETE) {
      response = await delete(url, headers: headerRequired ? headers : {});
    } else if (method == HttpMethod.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headerRequired ? headers : {});
    } else if (method == HttpMethod.PATCH) {
      response = await put(url, body: jsonEncode(request), headers: headerRequired ? headers : {});
    } else {
      response = await get(url, headers: headerRequired ? headers : {});
    }

    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == HttpMethod.POST || method == HttpMethod.PUT,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body,
      methodtype: method.name,
    );

    return response;
  } else {
    toast(locale.lblNoInternetMsg);
    throw errorInternetNotAvailable;
  }
}

Future handleResponse(Response response) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode == 403) {
    BaseResponses responses = BaseResponses.fromJson(jsonDecode(response.body));
    if (responses.code == '[jwt_auth] incorrect_password') {
      toast(locale.lblIncorrectPwd);
    } else if (responses.code == 'rest_forbidden') {
      toast(responses.message);
    } else {
      toast(responses.message);
      logout(isTokenExpired: true);
    }
  }

  if (response.statusCode == 500 || response.statusCode == 404) {
    if (appStore.isLoggedIn) {
      if (appStore.tempBaseUrl != BASE_URL) {
        appStore.setBaseUrl(BASE_URL, initialize: true);
        appStore.setDemoDoctor("", initialize: true);
        appStore.setDemoPatient("", initialize: true);
        appStore.setDemoReceptionist("", initialize: true);
        logout().catchError((e) {
          appStore.setLoading(false);

          throw e;
        });
      }
    } else {
      appStore.setBaseUrl(BASE_URL, initialize: true);
    }
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    try {
      var body = jsonDecode(response.body);

      if (body['message'].toString().validate().isNotEmpty) {
        throw parseHtmlString(body['message']);
      } else {
        throw errorSomethingWentWrong;
      }
    } on Exception {
      toast(errorSomethingWentWrong);
      throw errorSomethingWentWrong;
    }
  }
}

String _getOAuthURL({required String requestMethod, required String endpoint}) {
  var consumerKey = CONSUMER_KEY;
  var consumerSecret = CONSUMER_SECRET;

  var tokenSecret = "";
  var url = BASE_URL + endpoint;

  var containsQueryParams = url.contains("?");

  if (url.startsWith("https")) {
    return url + (containsQueryParams == true ? "&consumer_key=" + consumerKey + "&consumer_secret=" + consumerSecret : "?consumer_key=" + consumerKey + "&consumer_secret=" + consumerSecret);
  } else {
    var rand = new Random();
    var codeUnits = new List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    var nonce = new String.fromCharCodes(codeUnits);
    int timestamp = new DateTime.now().millisecondsSinceEpoch ~/ 1000;

    var method = requestMethod;
    var parameters = "oauth_consumer_key=$consumerKey" + "&oauth_nonce=$nonce" + "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=$timestamp" + "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString + Uri.encodeQueryComponent(key) + "=" + treeMap[key] + "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    var baseString = method + "&" + Uri.encodeQueryComponent(containsQueryParams == true ? url.split("?")[0] : url) + "&" + Uri.encodeQueryComponent(parameterString);

    var signingKey = consumerSecret + "&" + tokenSecret;
    var hmacSha1 = new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    var signature = hmacSha1.convert(utf8.encode(baseString));

    var finalSignature = base64Encode(signature.bytes);

    var requestUrl = "";

    if (containsQueryParams == true) {
      requestUrl = url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
    } else {
      requestUrl = url + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature);
    }

    return requestUrl;
  }
}

//region Common
enum HttpMethod { GET, POST, DELETE, PUT, PATCH }

class TokenException implements Exception {
  final String message;

  const TokenException([this.message = ""]);

  String toString() => "FormatException: $message";
}
//endregion

Future<MultipartRequest> getMultiPartRequest(String endPoint) async {
  log('Url $BASE_URL$endPoint');
  return MultipartRequest('POST', Uri.parse('$BASE_URL$endPoint'));
}

Future<dynamic> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());

  apiPrint(
    url: multiPartRequest.url.toString(),
    headers: jsonEncode(multiPartRequest.headers),
    request: jsonEncode(multiPartRequest.fields),
    hasRequest: true,
    statusCode: response.statusCode,
    responseBody: response.body,
    methodtype: "MultiPart",
  );

  if (response.statusCode.isSuccessful()) {
    if (response.body.isJson()) {
      onSuccess?.call(jsonDecode(response.body));
    } else {
      onSuccess?.call(response.body);
    }
  } else {
    onError?.call(jsonDecode(response.body)['message'].toString().isNotEmpty ? jsonDecode(response.body)['message'] : errorSomethingWentWrong);
  }
}

Future<dynamic> sendMultiPartRequestNew(MultipartRequest multiPartRequest) async {
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());

  apiPrint(
    url: multiPartRequest.url.toString(),
    headers: jsonEncode(multiPartRequest.headers),
    request: jsonEncode(multiPartRequest.fields),
    hasRequest: true,
    statusCode: response.statusCode,
    responseBody: response.body,
    methodtype: "MultiPart",
  );

  if (response.statusCode.isSuccessful()) {
    if (response.body.isJson()) {
      return jsonDecode(response.body);
    } else {
      return response.body;
    }
  } else {
    throw jsonDecode(response.body)['message'].toString().isNotEmpty ? jsonDecode(response.body)['message'] : errorSomethingWentWrong;
  }
}

Future<FirebaseRemoteConfig> setupFirebaseRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: Duration.zero, minimumFetchInterval: Duration.zero));
  await remoteConfig.fetch();
  await remoteConfig.fetchAndActivate();

  return remoteConfig;
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool hasRequest = false,
  bool fullLog = false,
}) {
  // fullLog = statusCode.isSuccessful();
  if (fullLog) {
    dev.log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    dev.log("\u001b[93m Url: \u001B[39m $url");
    dev.log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    dev.log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (hasRequest) {
      dev.log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    dev.log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    dev.log('MethodType ($methodtype) | StatusCode ($statusCode)');
    dev.log('\x1B[32m${formatJson(responseBody)}\x1B[0m', name: 'Response');
    //dev.log('Response ($methodtype) : statusCode:{$responseBody}');
    dev.log("\u001B[0m");
    dev.log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  } else {
    log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    log("\u001b[93m Url: \u001B[39m $url");
    log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    log("\u001b[93m header: \u001B[39m \u001b[96m${headers.split(',').join(',\n')}\u001B[39m");
    if (hasRequest) {
      log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    log('MethodType ($methodtype) | statusCode: ($statusCode)');
    log('Response : ');
    log('${formatJson(responseBody)}');
    log("\u001B[0m");
    log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  }
}

String formatJson(String jsonStr) {
  try {
    final dynamic parsedJson = jsonDecode(jsonStr);
    const formatter = JsonEncoder.withIndent('  ');
    return formatter.convert(parsedJson);
  } on Exception catch (e) {
    dev.log("\x1b[31m formatJson error ::-> ${e.toString()} \x1b[0m");
    return jsonStr;
  }
}

String parseStripeError(String response) {
  try {
    var body = jsonDecode(response);
    return parseHtmlString(body['error']['message']);
  } on Exception catch (e) {
    log(e);
    throw errorSomethingWentWrong;
  }
}
