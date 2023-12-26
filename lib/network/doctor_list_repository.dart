import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/network/network_utils.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

Future<List<DoctorList>> getDoctor({int? clinicId}) async {
  return getDoctorList(clinicId: clinicId).then((value) {
    log("================ Loaded Doctor Data  ${value.total}================ ");
    listAppStore.addDoctor(value.doctorList.validate());
    return value.doctorList.validate();
  }).catchError((e) {
    toast(e.toString());
  });
}

Future deleteDoctor(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/doctor/delete-doctor', request: request, method: HttpMethod.POST));
}

Future<List<DoctorList>> getDoctorListNew1({int? clinicId, required int page, required List<DoctorList> doctorList, Function(bool)? lastPageCallback, Function(int)? getTotalDoctor}) async {
  appStore.setLoading(true);

  List<String> param = [];

  if (isReceptionist()) {
    param.add('?clinic_id=${getIntAsync(USER_CLINIC)}');
    param.add('limit=$PER_PAGE');
  } else if (isDoctor() || isPatient()) {
    param.add('?clinic_id=${clinicId != null ? clinicId : ''}');
    param.add('limit=$PER_PAGE');
    param.add('page=$page');
  }

  DoctorListModel res = DoctorListModel.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/doctor/get-list${param.validate().join('&')}')));

  getTotalDoctor?.call(res.total.validate().toInt());

  if (page == 1) doctorList.clear();

  lastPageCallback?.call(res.doctorList.validate().length != PER_PAGE);

  doctorList.addAll(res.doctorList.validate());

  appStore.setLoading(false);
  return doctorList;
}

Future<DoctorListModel> getDoctorList({int? page, int? clinicId}) async {
  int? id;
  if (isReceptionist()) {
    id = getIntAsync(USER_CLINIC);
  } else if (isDoctor() || isPatient()) {
    id = clinicId;
  }

  if (page == null) {
    return DoctorListModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/doctor/get-list?clinic_id=${id != null ? id : ''}&limit=-1'))));
  } else {
    return DoctorListModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/doctor/get-list?clinic_id=${id != null ? id : ''}&limit=$PER_PAGE&page=$page'))));
  }
}

Future<List<DoctorList>> getDoctorListNew({required int page, required List<DoctorList> doctorList, Function(bool)? lastPageCallback, Function(int)? getTotalPatient}) async {
  DoctorListModel res = DoctorListModel.fromJson(await (handleResponse(await buildHttpResponse(getEndPoint(endPoint: 'kivicare/api/v1/doctor/get-list', page: page)))));
  appStore.setLoading(true);

  getTotalPatient?.call(res.total.validate().toInt());

  if (page == 1) doctorList.clear();

  lastPageCallback?.call(res.doctorList.validate().length != PER_PAGE);

  doctorList.addAll(res.doctorList.validate());

  appStore.setLoading(false);

  return doctorList;
}
