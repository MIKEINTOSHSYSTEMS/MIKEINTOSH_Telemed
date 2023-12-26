import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/patient_list_model.dart';
import 'package:kivicare_flutter/network/network_utils.dart';
import 'package:kivicare_flutter/screens/patient/models/news_model.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';

Future<List<PatientData>> getPatient() {
  return getPatientList().then((value) {
    log("================ Loaded Patinent Data  ${value.total}================ ");

    listAppStore.addPatient(value.patientData.validate());
    return value.patientData.validate();
  }).catchError((e) {
    toast(e.toString());
  });
}

Future<NewsModel> getNewsList() async {
  return NewsModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/news/get-news-list'))));
}

Future<PatientListModel> getPatientList({int? page}) async {
  if (page == null) {
    return PatientListModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/patient/get-list?limit=-1'))));
  } else {
    return PatientListModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/patient/get-list?limit=$PER_PAGE&page=$page'))));
  }
}

Future<List<PatientData>> getPatientListNew({required int page, required List<PatientData> patientList, Function(bool)? lastPageCallback, Function(int)? getTotalPatient}) async {
  appStore.setLoading(true);

  PatientListModel res = PatientListModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: 'kivicare/api/v1/patient/get-list', page: page))));

  getTotalPatient?.call(res.total.validate().toInt());

  if (page == 1) patientList.clear();

  lastPageCallback?.call(res.patientData.validate().length != PER_PAGE);

  patientList.addAll(res.patientData.validate());

  appStore.setLoading(false);
  return patientList;
}

//Add patient

Future addNewPatientData(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/auth/registration', request: request, method: HttpMethod.POST));
}

Future updatePatientData(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/user/profile-update', request: request, method: HttpMethod.POST));
}

// End Patient
