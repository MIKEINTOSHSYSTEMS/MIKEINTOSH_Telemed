import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/clinic_list_model.dart';
import 'package:kivicare_flutter/model/login_response_model.dart';
import 'package:kivicare_flutter/network/network_utils.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';

Future<List<Clinic>> getClinic() async {
  return getClinicList(page: null).then((value) {
    log("================ Loaded Clinic Data  ${value.total}================ ");
    listAppStore.addClinic(value.clinicData.validate(), isClear: true);
    return value.clinicData.validate();
  }).catchError((e) {
    toast(e.toString());
  });
}

Future<ClinicListModel> getClinicList({int? page}) async {
  return ClinicListModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/clinic/get-list?page=${page != null ? page : ''}'))));
}

Future<List<Clinic>> getClinicListNew({required int page, required List<Clinic> appointmentList, Function(bool)? lastPageCallback, Function(int)? getTotalPatient}) async {
  ClinicListModel res = ClinicListModel.fromJson(await (handleResponse(await buildHttpResponse(getEndPoint(endPoint: 'kivicare/api/v1/clinic/get-list', page: page)))));
  appStore.setLoading(true);

  getTotalPatient?.call(res.total.validate().toInt());

  if (page == 1) appointmentList.clear();

  lastPageCallback?.call(res.clinicData.validate().length != PER_PAGE);

  appointmentList.addAll(res.clinicData.validate());

  appStore.setLoading(false);

  return appointmentList;
}
