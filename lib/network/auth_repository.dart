import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/base_response.dart';
import 'package:momona_healthcare/model/clinic_list_model.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/screens/auth/screens/sign_in_screen.dart';
import 'package:momona_healthcare/store/ShopStore.dart';
import 'package:momona_healthcare/utils/cached_value.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'clinic_repository.dart';
import 'google_repository.dart';

Future<UserModel> loginAPI(Map<String, dynamic> req) async {
  UserModel value = UserModel.fromJson(await handleResponse(await buildHttpResponse(ApiEndPoints.jwtEndPoint, request: req, method: HttpMethod.POST)));
  cachedUserData = value;

  setValue(TOKEN, value.token.validate());

  appStore.setLoggedIn(true);
  if (value.clinic.validate().isNotEmpty) {
    Clinic defaultClinic = value.clinic.validate().first;
    appStore.setCurrency(defaultClinic.extra!.currencyPrefix.validate(), initialize: true);
    userStore.setClinicId(defaultClinic.id.validate(), initialize: true);
  }

  setValue(PASSWORD, req['password']);
  setValue(USER_LOGIN, value.userNiceName.validate());
  setValue(USER_DATA, jsonEncode(value));
  setValue(USER_ENCOUNTER_MODULES, jsonEncode(value.encounterModules));
  setValue(USER_PRESCRIPTION_MODULE, jsonEncode(value.prescriptionModule));
  setValue(USER_MODULE_CONFIG, jsonEncode(value.moduleConfig));

  appStore.setLoggedIn(true);
  userStore.setUserEmail(value.userEmail.validate(), initialize: true);
  userStore.setUserProfile(value.profileImage.validate(), initialize: true);
  userStore.setUserId(value.userId.validate(), initialize: true);
  userStore.setFirstName(value.firstName.validate(), initialize: true);
  userStore.setLastName(value.lastName.validate(), initialize: true);
  userStore.setRole(value.role.validate(), initialize: true);
  userStore.setUserDisplayName(value.userDisplayName.validate(), initialize: true);
  userStore.setUserMobileNumber(value.mobileNumber.validate(), initialize: true);
  userStore.setUserGender(value.gender.validate(), initialize: true);
  userStore.setUserData(value, initialize: true);

  if (isReceptionist() || isPatient()) {
    getSelectedClinicAPI(clinicId: userStore.userClinicId.validate(), isForLogin: true).then((value) {
      userStore.setUserClinic(value);
      userStore.setUserClinicImage(value.profileImage.validate(), initialize: true);
      userStore.setUserClinicName(value.name.validate(), initialize: true);
      userStore.setUserClinicStatus(value.status.validate(), initialize: true);
      String clinicAddress = '';

      if (value.city.validate().isNotEmpty) {
        clinicAddress = value.city.validate();
      }
      if (value.country.validate().isNotEmpty) {
        clinicAddress += ' ,' + value.country.validate();
      }
      userStore.setUserClinicAddress(clinicAddress, initialize: true);
    });
  }

  return value;
}

Future<BaseResponses> changePasswordAPI(Map<String, dynamic> request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('${ApiEndPoints.userEndpoint}/${EndPointKeys.changePwdEndPointKey}', request: request, method: HttpMethod.POST)));
}

Future<BaseResponses> deleteAccountPermanently() async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('${ApiEndPoints.authEndPoint}/${EndPointKeys.deleteEndPointKey}', method: HttpMethod.DELETE)));
}

Future<BaseResponses> logOutApi() async {
  Map req = {ConstantKeys.playerIdKey: appStore.playerId, ConstantKeys.loggedOutKey: 1};
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('${ApiEndPoints.authEndPoint}/${EndPointKeys.managePlayerIdEndPointKey}', request: req, method: HttpMethod.POST)));
}

Future<void> logout({bool isTokenExpired = false}) async {
  if (!isTokenExpired) {
    await logOutApi().catchError((e) {
      appStore.setLoading(false);
      throw e;
    });
  }

  await removeKey(TOKEN);
  await removeKey(SharedPreferenceKey.nonceKey);
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
  await removeKey(USER_DATA);
  await removeKey(PLAYER_ID);
  await removeKey(CartKeys.shippingAddress);
  await removeKey(CartKeys.billingAddress);

  appStore.setPlayerId('');
  OneSignal.User.pushSubscription.optOut();
  if (isDoctor()) {
    cachedDoctorAppointment = null;
    cachedDoctorAppointment = [];
    cachedDoctorPatient = [];
  }
  if (isReceptionist()) {
    cachedReceptionistAppointment = null;
    cachedDoctorList = [];
    cachedClinicPatient = [];
  }
  if (isPatient()) {
    cachedPatientAppointment = [];
    cachedPatientAppointment = null;
  }

  OneSignal.logout();
  await removeKey(SharedPreferenceKey.cachedDashboardDataKey);
  removeKey(CartKeys.cartItemCountKey);

  removePermission();

  userStore.setClinicId('');
  appStore.setLoggedIn(false);
  appStore.setLoading(false);
  paymentMethodList.clear();
  paymentMethodImages.clear();
  paymentModeList.clear();
  shopStore.setCartCount(0);

  push(SignInScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
}

void removePermission() {
  removeKey(USER_PERMISSION);
  removeKey(SharedPreferenceKey.kiviCareAppointmentAddKey);
  removeKey(SharedPreferenceKey.kiviCareAppointmentDeleteKey);
  removeKey(SharedPreferenceKey.kiviCareAppointmentEditKey);
  removeKey(SharedPreferenceKey.kiviCareAppointmentListKey);
  removeKey(SharedPreferenceKey.kiviCareAppointmentViewKey);
  removeKey(SharedPreferenceKey.kiviCarePatientAppointmentStatusChangeKey);
  removeKey(SharedPreferenceKey.kiviCareAppointmentExportKey);
  removeKey(SharedPreferenceKey.kiviCarePatientBillAddKey);
  removeKey(SharedPreferenceKey.kiviCarePatientBillDeleteKey);
  removeKey(SharedPreferenceKey.kiviCarePatientBillEditKey);
  removeKey(SharedPreferenceKey.kiviCarePatientBillListKey);
  removeKey(SharedPreferenceKey.kiviCarePatientBillExportKey);
  removeKey(SharedPreferenceKey.kiviCarePatientBillViewKey);
  removeKey(SharedPreferenceKey.kiviCareClinicAddKey);
  removeKey(SharedPreferenceKey.kiviCareClinicDeleteKey);
  removeKey(SharedPreferenceKey.kiviCareClinicEditKey);
  removeKey(SharedPreferenceKey.kiviCareClinicListKey);
  removeKey(SharedPreferenceKey.kiviCareClinicProfileKey);
  removeKey(SharedPreferenceKey.kiviCareClinicViewKey);
  removeKey(SharedPreferenceKey.kiviCareMedicalRecordsAddKey);
  removeKey(SharedPreferenceKey.kiviCareMedicalRecordsDeleteKey);
  removeKey(SharedPreferenceKey.kiviCareMedicalRecordsEditKey);
  removeKey(SharedPreferenceKey.kiviCareMedicalRecordsListKey);
  removeKey(SharedPreferenceKey.kiviCareMedicalRecordsViewKey);
  removeKey(SharedPreferenceKey.kiviCareDashboardTotalAppointmentKey);
  removeKey(SharedPreferenceKey.kiviCareDashboardTotalDoctorKey);
  removeKey(SharedPreferenceKey.kiviCareDashboardTotalPatientKey);
  removeKey(SharedPreferenceKey.kiviCareDashboardTotalRevenueKey);
  removeKey(SharedPreferenceKey.kiviCareDashboardTotalTodayAppointmentKey);
  removeKey(SharedPreferenceKey.kiviCareDashboardTotalServiceKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorAddKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorDeleteKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorEditKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorDashboardKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorListKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorViewKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorExportKey);
  removeKey(SharedPreferenceKey.kiviCarePatientEncounterAddKey);
  removeKey(SharedPreferenceKey.kiviCarePatientEncounterDeleteKey);
  removeKey(SharedPreferenceKey.kiviCarePatientEncounterEditKey);
  removeKey(SharedPreferenceKey.kiviCarePatientEncounterExportKey);
  removeKey(SharedPreferenceKey.kiviCarePatientEncounterListKey);
  removeKey(SharedPreferenceKey.kiviCarePatientEncountersKey);
  removeKey(SharedPreferenceKey.kiviCarePatientEncounterViewKey);
  removeKey(SharedPreferenceKey.kiviCareEncountersTemplateAddKey);
  removeKey(SharedPreferenceKey.kiviCareEncountersTemplateDeleteKey);
  removeKey(SharedPreferenceKey.kiviCareEncountersTemplateEditKey);
  removeKey(SharedPreferenceKey.kiviCareEncountersTemplateListKey);
  removeKey(SharedPreferenceKey.kiviCareEncountersTemplateViewKey);
  removeKey(SharedPreferenceKey.kiviCareClinicScheduleKey);
  removeKey(SharedPreferenceKey.kiviCareClinicScheduleAddKey);
  removeKey(SharedPreferenceKey.kiviCareClinicScheduleDeleteKey);
  removeKey(SharedPreferenceKey.kiviCareClinicScheduleEditKey);
  removeKey(SharedPreferenceKey.kiviCareClinicScheduleExportKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorSessionAddKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorSessionEditKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorSessionListKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorSessionDeleteKey);
  removeKey(SharedPreferenceKey.kiviCareDoctorSessionExportKey);
  removeKey(SharedPreferenceKey.kiviCareChangePasswordKey);
  removeKey(SharedPreferenceKey.kiviCarePatientReviewAddKey);
  removeKey(SharedPreferenceKey.kiviCarePatientReviewDeleteKey);
  removeKey(SharedPreferenceKey.kiviCarePatientReviewEditKey);
  removeKey(SharedPreferenceKey.kiviCarePatientReviewGetKey);
  removeKey(SharedPreferenceKey.kiviCareDashboardKey);
  removeKey(SharedPreferenceKey.kiviCarePatientAddKey);
  removeKey(SharedPreferenceKey.kiviCarePatientDeleteKey);
  removeKey(SharedPreferenceKey.kiviCarePatientClinicKey);
  removeKey(SharedPreferenceKey.kiviCarePatientProfileKey);
  removeKey(SharedPreferenceKey.kiviCarePatientEditKey);
  removeKey(SharedPreferenceKey.kiviCarePatientListKey);
  removeKey(SharedPreferenceKey.kiviCarePatientExportKey);
  removeKey(SharedPreferenceKey.kiviCarePatientViewKey);
  removeKey(SharedPreferenceKey.kiviCareReceptionistProfileKey);
  removeKey(SharedPreferenceKey.kiviCarePatientReportKey);
  removeKey(SharedPreferenceKey.kiviCarePatientReportAddKey);
  removeKey(SharedPreferenceKey.kiviCarePatientReportEditKey);
  removeKey(SharedPreferenceKey.kiviCarePatientReportViewKey);
  removeKey(SharedPreferenceKey.kiviCarePatientReportDeleteKey);
  removeKey(SharedPreferenceKey.kiviCarePrescriptionAddKey);
  removeKey(SharedPreferenceKey.kiviCarePrescriptionDeleteKey);
  removeKey(SharedPreferenceKey.kiviCarePrescriptionEditKey);
  removeKey(SharedPreferenceKey.kiviCarePrescriptionViewKey);
  removeKey(SharedPreferenceKey.kiviCarePrescriptionListKey);
  removeKey(SharedPreferenceKey.kiviCarePrescriptionExportKey);
  removeKey(SharedPreferenceKey.kiviCareServiceAddKey);
  removeKey(SharedPreferenceKey.kiviCareServiceDeleteKey);
  removeKey(SharedPreferenceKey.kiviCareServiceEditKey);
  removeKey(SharedPreferenceKey.kiviCareServiceExportKey);
  removeKey(SharedPreferenceKey.kiviCareServiceListKey);
  removeKey(SharedPreferenceKey.kiviCareServiceViewKey);
  removeKey(SharedPreferenceKey.kiviCareStaticDataAddKey);
  removeKey(SharedPreferenceKey.kiviCareStaticDataDeleteKey);
  removeKey(SharedPreferenceKey.kiviCareStaticDataEditKey);
  removeKey(SharedPreferenceKey.kiviCareStaticDataExportKey);
  removeKey(SharedPreferenceKey.kiviCareStaticDataListKey);
  removeKey(SharedPreferenceKey.kiviCareStaticDataViewKey);
}

Future<UserModel> getSingleUserDetailAPI(int? id) async {
  return UserModel.fromJson(await (handleResponse(await buildHttpResponse('${ApiEndPoints.userEndpoint}/${EndPointKeys.getDetailEndPointKey}?${ConstantKeys.capitalIDKey}=$id'))));
}

//Post API Change

Future<BaseResponses> forgotPasswordAPI(Map<String, dynamic> request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('${ApiEndPoints.userEndpoint}/${EndPointKeys.forgetPwdEndPointKey}', request: request, method: HttpMethod.POST)));
}

Future<void> updateProfileAPI({required Map<String, dynamic> data, File? profileImage, File? doctorSignature}) async {
  var multiPartRequest = await getMultiPartRequest('${ApiEndPoints.userEndpoint}/${EndPointKeys.updateProfileEndPointKey}');

  multiPartRequest.fields.addAll(await getMultipartFields(val: data));

  multiPartRequest.headers.addAll(buildHeaderTokens());

  if (profileImage != null) {
    multiPartRequest.files.add(await MultipartFile.fromPath('profile_image', profileImage.path));
  }

  if (doctorSignature != null) {
    String convertedImage = await convertImageToBase64(doctorSignature);
    multiPartRequest.files.add(MultipartFile.fromString('signature_img', convertedImage));
  }
  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    UserModel data = UserModel.fromJson(temp['data']);
    cachedUserData = data;

    userStore.setFirstName(data.firstName.validate(), initialize: true);
    userStore.setLastName(data.lastName.validate(), initialize: true);
    userStore.setUserMobileNumber(data.mobileNumber.validate(), initialize: true);
    if (data.profileImage != null) {
      userStore.setUserProfile(data.profileImage.validate(), initialize: true);
    }
    toast(temp['message'], print: true);
    finish(getContext, true);
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  });
}

//region CommonFunctions
Future<Map<String, String>> getMultipartFields({required Map<String, dynamic> val}) async {
  Map<String, String> data = {};

  val.forEach((key, value) {
    data[key] = '$value';
  });

  return data;
}

Future<List<MultipartFile>> getMultipartImages({required List<File> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<File>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('${'$name' + i.toString()}', element.path));
  });

  return multiPartRequest;
}

//endregion
