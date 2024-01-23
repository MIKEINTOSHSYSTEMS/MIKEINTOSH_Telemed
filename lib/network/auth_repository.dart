import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/base_response.dart';
import 'package:momona_healthcare/model/get_doctor_detail_model.dart';
import 'package:momona_healthcare/model/get_user_detail_model.dart';
import 'package:momona_healthcare/model/login_response_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/screens/auth/sign_in_screen.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

Future<LoginResponseModel> login(Map req) async {
  LoginResponseModel value = LoginResponseModel.fromJson(await (handleResponse(await buildHttpResponse('jwt-auth/v1/token', request: req, method: HttpMethod.POST))));

  setValue(TOKEN, value.token!);
  if (value.clinic.validate().isNotEmpty) {
    appStore.setCurrency(value.clinic!.first.extra!.currency_prefix.validate(), initiliaze: true);
    setValue(USER_CLINIC, value.clinic!.first.clinic_id.toInt());
  }
  setValue(PASSWORD, req['password']);
  setValue(USER_LOGIN, value.user_nicename.validate());
  setValue(USER_DATA, jsonEncode(value));
  setValue(USER_ENCOUNTER_MODULES, jsonEncode(value.enocunter_modules));
  setValue(USER_PRESCRIPTION_MODULE, jsonEncode(value.prescription_module));
  setValue(USER_MODULE_CONFIG, jsonEncode(value.module_config));

  appStore.setLoggedIn(true);
  appStore.setUserEmail(value.user_email.validate(), initiliaze: true);
  appStore.setUserProfile(value.profile_image.validate(), initiliaze: true);
  appStore.setUserId(value.user_id.validate(), initiliaze: true);
  appStore.setFirstName(value.first_name.validate(), initiliaze: true);
  appStore.setLastName(value.last_name.validate(), initiliaze: true);
  appStore.setRole(value.role.validate(), initiliaze: true);
  appStore.setUserDisplayName(value.user_display_name.validate(), initiliaze: true);
  appStore.setUserMobileNumber(value.mobile_number.validate(), initiliaze: true);
  appStore.setUserGender(value.gender.validate(), initiliaze: true);
  appStore.setUserProEnabled(value.isKiviCareProOnName.validate(), initiliaze: true);
  appStore.setUserTelemedOn(value.isTeleMedActive.validate(), initiliaze: true);
  appStore.setUserEnableGoogleCal(value.is_enable_google_cal.validate(), initiliaze: true);
  appStore.setUserDoctorGoogleCal(value.is_enable_doctor_gcal.validate(), initiliaze: true);

  return value;
}

Future<BaseResponses> changePassword(Map request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/user/change-password', request: request, method: HttpMethod.POST)));
}

Future<void> logout(BuildContext context) async {
  await removeKey(TOKEN);
  await removeKey(USER_ID);
  await removeKey(FIRST_NAME);
  await removeKey(LAST_NAME);
  await removeKey(USER_EMAIL);
  await removeKey(USER_DISPLAY_NAME);
  await removeKey(PROFILE_IMAGE);
  await removeKey(USER_MOBILE);
  await removeKey(USER_GENDER);
  await removeKey(USER_ROLE);
  await removeKey(PASSWORD);

  appStore.setLoggedIn(false);
  appStore.setLoading(false);
  push(SignInScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
}

Future<GetDoctorDetailModel> getUserProfile(int? id) async {
  return GetDoctorDetailModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/user/get-detail?ID=$id'))));
}

Future<GetUserDetailModel> getUserDetails(int? id) async {
  return GetUserDetailModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/user/get-detail?ID=$id'))));
}

//view Profile
Future<LoginResponseModel> viewUserProfile(int id) async {
  return LoginResponseModel.fromJson(await (handleResponse(await buildHttpResponse('/kivicare/api/v1/user/get-detail?id=$id'))));
}

Future validateToken() async {
  return await handleResponse(await buildHttpResponse('jwt-auth/v1/token/validate', request: {}, method: HttpMethod.POST));
}

//Post API Change

Future<BaseResponses> forgotPassword(Map<String, dynamic> request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/user/forgot-password', request: request, method: HttpMethod.POST)));
}

Future<bool> updateProfile(BuildContext context, Map data, {File? file, String? toastMessage}) async {
  var multiPartRequest = await getMultiPartRequest('kivicare/api/v1/user/profile-update');

  multiPartRequest.fields['ID'] = data['ID'];
  multiPartRequest.fields['user_email'] = data['user_email'];
  multiPartRequest.fields['user_login'] = data['user_login'];
  multiPartRequest.fields['first_name'] = data['first_name'];
  multiPartRequest.fields['last_name'] = data['last_name'];
  multiPartRequest.fields['gender'] = data['gender'];
  multiPartRequest.fields['dob'] = data['dob'];
  multiPartRequest.fields['address'] = data['address'];
  multiPartRequest.fields['city'] = data['city'];
  multiPartRequest.fields['state'] = data['state'];
  multiPartRequest.fields['country'] = data['country'];
  multiPartRequest.fields['postal_code'] = data['postal_code'];
  multiPartRequest.fields['mobile_number'] = data['mobile_number'];
  multiPartRequest.fields['qualifications'] = data['qualifications'];
  multiPartRequest.fields['specialties'] = data['specialties'];
  multiPartRequest.fields['price_type'] = data['price_type'];
  if (data['price_type'] == 'range') {
    multiPartRequest.fields['minPrice'] = data['minPrice'];
    multiPartRequest.fields['maxPrice'] = data['maxPrice'];
  } else {
    multiPartRequest.fields['price'] = data['price'];
  }
  multiPartRequest.fields['no_of_experience'] = data['no_of_experience'];

  if (file != null) multiPartRequest.files.add(await MultipartFile.fromPath('profile_image', file.path));

  multiPartRequest.headers.addAll(buildHeaderTokens());

  Response response = await Response.fromStream(await multiPartRequest.send());

  if (response.statusCode.isSuccessful()) {
    LoginResponseModel data = LoginResponseModel.fromJson(jsonDecode(response.body)['data']);
    setValue(FIRST_NAME, data.first_name.validate());
    setValue(LAST_NAME, data.last_name.validate());
    setValue(USER_DISPLAY_NAME, data.user_display_name.validate());

    appStore.setFirstName(data.first_name.validate());
    appStore.setLastName(data.last_name.validate());
    appStore.setUserDisplayName(data.user_display_name.validate());

    if (data.profile_image != null) {
      setValue(PROFILE_IMAGE, data.profile_image!);
      appStore.setUserProfile(data.profile_image.validate(), initiliaze: true);
    }
    toast(toastMessage ?? 'Profile updated successfully');
    finish(context);
    return true;
  } else {
    log("${response.statusCode} ${response.body}");
    toast(errorSomethingWentWrong);
    return false;
  }
}

Future<bool> addDoctor(Map data, {File? file, String? toastMessage}) async {
  var multiPartRequest = await getMultiPartRequest('kivicare/api/v1/doctor/add-doctor');

  multiPartRequest.fields['user_email'] = data['user_email'];
  multiPartRequest.fields['first_name'] = data['first_name'];
  multiPartRequest.fields['last_name'] = data['last_name'];
  multiPartRequest.fields['gender'] = data['gender'];
  multiPartRequest.fields['dob'] = data['dob'];
  multiPartRequest.fields['address'] = data['address'];
  multiPartRequest.fields['clinic_id'] = data['clinic_id'];
  multiPartRequest.fields['city'] = data['city'];
  multiPartRequest.fields['state'] = data['state'];
  multiPartRequest.fields['country'] = data['country'];
  multiPartRequest.fields['postal_code'] = data['postal_code'];
  multiPartRequest.fields['mobile_number'] = data['mobile_number'];
  multiPartRequest.fields['qualifications'] = data['qualifications'];
  multiPartRequest.fields['specialties'] = data['specialties'];
  multiPartRequest.fields['price_type'] = data['price_type'];
  if (data['price_type'] == 'range') {
    multiPartRequest.fields['minPrice'] = data['minPrice'];
    multiPartRequest.fields['maxPrice'] = data['maxPrice'];
  } else {
    multiPartRequest.fields['price'] = data['price'];
  }
  if (data['enableTeleMed'] == true) {
    multiPartRequest.fields['enableTeleMed'] = data['enableTeleMed'];
    multiPartRequest.fields['enableTeleMed'] = data['enableTeleMed'];
    multiPartRequest.fields['api_key'] = data['api_key'];
    multiPartRequest.fields['video_price'] = data['video_price'];
  }
  multiPartRequest.fields['no_of_experience'] = data['no_of_experience'];

  if (file != null) multiPartRequest.files.add(await MultipartFile.fromPath('profile_image', file.path));

  multiPartRequest.headers.addAll(buildHeaderTokens());

  Response response = await Response.fromStream(await multiPartRequest.send());

  if (response.statusCode.isSuccessful()) {
    toast(toastMessage ?? 'Doctor Added Successfully');

    return true;
  } else {
    toast(errorSomethingWentWrong);
    return false;
  }
}

Future<bool> updateReceptionistDoctor(Map data, {File? file, String? toastMessage}) async {
  var multiPartRequest = await getMultiPartRequest('kivicare/api/v1/doctor/add-doctor');

  multiPartRequest.fields['ID'] = data['ID'];
  multiPartRequest.fields['user_email'] = data['user_email'];
  multiPartRequest.fields['first_name'] = data['first_name'];
  multiPartRequest.fields['last_name'] = data['last_name'];
  multiPartRequest.fields['gender'] = data['gender'];
  multiPartRequest.fields['dob'] = data['dob'];
  multiPartRequest.fields['address'] = data['address'];
  multiPartRequest.fields['clinic_id'] = data['clinic_id'];
  multiPartRequest.fields['city'] = data['city'];
  multiPartRequest.fields['state'] = data['state'];
  multiPartRequest.fields['country'] = data['country'];
  multiPartRequest.fields['postal_code'] = data['postal_code'];
  multiPartRequest.fields['mobile_number'] = data['mobile_number'];
  multiPartRequest.fields['qualifications'] = data['qualifications'];
  multiPartRequest.fields['specialties'] = data['specialties'];
  multiPartRequest.fields['price_type'] = data['price_type'];
  if (data['price_type'] == 'range') {
    multiPartRequest.fields['minPrice'] = data['minPrice'];
    multiPartRequest.fields['maxPrice'] = data['maxPrice'];
  } else {
    multiPartRequest.fields['price'] = data['price'];
  }
  if (data['enableTeleMed'] == true) {
    multiPartRequest.fields['enableTeleMed'] = data['enableTeleMed'];
    multiPartRequest.fields['enableTeleMed'] = data['enableTeleMed'];
    multiPartRequest.fields['api_key'] = data['api_key'];
    multiPartRequest.fields['video_price'] = data['video_price'];
  }
  multiPartRequest.fields['no_of_experience'] = data['no_of_experience'];

  if (file != null) multiPartRequest.files.add(await MultipartFile.fromPath('profile_image', file.path));

  multiPartRequest.headers.addAll(buildHeaderTokens());

  Response response = await Response.fromStream(await multiPartRequest.send());

  if (response.statusCode.isSuccessful()) {
    toast(toastMessage ?? 'Doctor Updated Successfully');

    return true;
  } else {
    toast(errorSomethingWentWrong);
    return false;
  }
}

Future<bool> updatePatientProfile(Map data, {File? file, String? toastMessage}) async {
  var multiPartRequest = await getMultiPartRequest('kivicare/api/v1/user/profile-update');

  multiPartRequest.fields['ID'] = data['ID'];
  multiPartRequest.fields['user_email'] = data['user_email'];
  multiPartRequest.fields['user_login'] = getStringAsync(USER_LOGIN);
  multiPartRequest.fields['first_name'] = data['first_name'];
  multiPartRequest.fields['last_name'] = data['last_name'];
  multiPartRequest.fields['gender'] = data['gender'];
  multiPartRequest.fields['dob'] = data['dob'];
  multiPartRequest.fields['address'] = data['address'];
  multiPartRequest.fields['city'] = data['city'];
  multiPartRequest.fields['country'] = data['country'];
  multiPartRequest.fields['postal_code'] = data['postal_code'];
  multiPartRequest.fields['mobile_number'] = data['mobile_number'];

  if (file != null) multiPartRequest.files.add(await MultipartFile.fromPath('profile_image', file.path));

  multiPartRequest.headers.addAll(buildHeaderTokens());

  Response response = await Response.fromStream(await multiPartRequest.send());
  if (response.statusCode.isSuccessful()) {
    LoginResponseModel data = LoginResponseModel.fromJson(jsonDecode(response.body)['data']);
    appStore.setFirstName(data.first_name.validate());
    appStore.setLastName(data.last_name.validate());
    appStore.setUserMobileNumber(data.mobile_number.validate());

    if (data.profile_image != null) {
      appStore.setUserProfile(data.profile_image.validate(), initiliaze: true);
    }

    toast(toastMessage ?? 'Profile updated successfully');

    return true;
  } else {
    toast(errorSomethingWentWrong);
    return false;
  }
}
