import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/clinic_list_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/cached_value.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

Future<Clinic> getSelectedClinicAPI({int? page, required String clinicId, bool isForLogin = false}) async {
  ClinicListModel res = ClinicListModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/clinic/get-list?page=${page != null ? page : ''}'))));
  if (!isForLogin) appointmentAppStore.setSelectedClinic(res.clinicData.validate().firstWhere((element) => element.id.validate() == clinicId));
  return res.clinicData.validate().firstWhere((element) => element.id.validate() == clinicId);
}

Future<List<Clinic>> getClinicListAPI({
  String? searchString,
  required int page,
  bool? isAuthRequired,
  Function(bool)? lastPageCallback,
  required List<Clinic> clinicList,
}) async {
  if (!appStore.isConnectedToInternet) {
    return [];
  }

  List<String> params = [];
  if (searchString.validate().isNotEmpty) params.add('s=$searchString');
  if (isAuthRequired != null) {
    params.add('with_auth=$isAuthRequired');
  }

  ClinicListModel res = ClinicListModel.fromJson(
    await (handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${ApiEndPoints.clinicApiEndPoint}/${EndPointKeys.getListEndPointKey}', page: page, params: params)))),
  );

  cachedClinicList = res.clinicData.validate();

  if (page == 1) clinicList.clear();

  lastPageCallback?.call(res.clinicData.validate().length != PER_PAGE);

  clinicList.addAll(res.clinicData.validate());

  return clinicList;
}

Future switchClinicApi({required Map req}) async {
  return (await handleResponse(await buildHttpResponse('${ApiEndPoints.patientEndPoint}/${EndPointKeys.switchClinicEndPointKey}', request: req, method: HttpMethod.POST)));
}
