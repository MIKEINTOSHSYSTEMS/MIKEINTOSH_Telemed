import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/base_response.dart';
import 'package:momona_healthcare/model/report_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';

//Report

Future<ReportModel> getReportDataAPI({int? patientId}) async {
  return ReportModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/patient/get-patient-report?patient_id=$patientId&page=1&limit=10'))));
}

Future<ApiResponses> addReportDataAPI(Map data, {File? file}) async {
  var multiPartRequest = await getMultiPartRequest('kivicare/api/v1/patient/upload-patient-report');

  multiPartRequest.fields['name'] = data['name'];
  if (data['id'] != null) multiPartRequest.fields['id'] = data['id'];
  multiPartRequest.fields['patient_id'] = data['patient_id'];
  multiPartRequest.fields['date'] = data['date'];

  if (file != null) multiPartRequest.files.add(await MultipartFile.fromPath('upload_report', file.path));

  multiPartRequest.headers.addAll(buildHeaderTokens());
  log("Multi Part Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");
  Response response = await Response.fromStream(await multiPartRequest.send());
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
    return ApiResponses.fromJson(await handleResponse(response));
  } else {
    return ApiResponses.fromJson(await handleResponse(response));
  }
}

Future<ReportModel> deleteReportAPI(Map request) async {
  return ReportModel.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/patient/delete-patient-report', request: request, method: HttpMethod.POST)));
}

Future<List<ReportData>> getPatientReportListApi({
  int? patientId,
  int? page,
  required List<ReportData> reportList,
  Function(bool)? lastPageCallback,
  Function(int)? getTotalReport,
}) async {
  if (!appStore.isConnectedToInternet) {
    return [];
  }

  List<String> param = [];
  param.add('patient_id=$patientId');

  ReportModel res = ReportModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: 'kivicare/api/v1/patient_report/get', page: page, params: param))));
  getTotalReport?.call(res.reportData.validate().length.toInt());

  if (page == 1) reportList.clear();

  lastPageCallback?.call(res.reportData.validate().length != PER_PAGE);

  reportList.addAll(res.reportData.validate());

  appStore.setLoading(false);
  return reportList;
}

//End Report
