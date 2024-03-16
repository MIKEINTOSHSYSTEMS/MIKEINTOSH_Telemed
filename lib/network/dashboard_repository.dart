import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/dashboard_model.dart';
import 'package:momona_healthcare/model/encounter_model.dart';
import 'package:momona_healthcare/model/static_data_model.dart';
import 'package:momona_healthcare/model/upcoming_appointment_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/utils/cached_value.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

Future<DashboardModel> getUserDashBoardAPI() async {
  if (!appStore.isConnectedToInternet) {
    return DashboardModel();
  }
  appStore.setLoading(true);

  DashboardModel res =
      DashboardModel.fromJson(await (handleResponse(await buildHttpResponse('${ApiEndPoints.userEndpoint}/${EndPointKeys.getDashboardKey}?${ConstantKeys.pageKey}=1&${ConstantKeys.limitKey}=5'))));
  appStore.setLoading(false);
  setValue(SharedPreferenceKey.cachedDashboardDataKey, res.toJson());

  appStore.setCurrencyPostfix(res.currencyPostfix.validate());
  appStore.setCurrencyPrefix(res.currencyPrefix.validate());

  appStore.setLoading(false);
  return res;
}

Future<EncounterModel> getEncounterDetailsDashBoardAPI({required int encounterId}) async {
  if (!appStore.isConnectedToInternet) {
    return EncounterModel();
  }
  return EncounterModel.fromJson(await (handleResponse(
    await buildHttpResponse('${ApiEndPoints.encounterEndPoint}/${EndPointKeys.getEncounterDetailEndPointKey}?${ConstantKeys.lowerIdKey}=$encounterId'),
  )));
}

Future<StaticDataModel> getStaticDataResponseAPI(String req, {String? searchString}) async {
  List<String> param = [];
  if (searchString.validate().isNotEmpty) param.add('s=$searchString');
  StaticDataModel data = StaticDataModel.fromJson(
      await (handleResponse(await buildHttpResponse('${ApiEndPoints.staticDataEndPoint}/${EndPointKeys.getListEndPointKey}?${ConstantKeys.typeKey}=$req&${param.validate().join('&')}'))));
  if (data.staticData != null) cachedStaticData = data.staticData;
  return data;
}
// get appointment count

Future<List<WeeklyAppointment>> getAppointmentCountAPI({required Map request}) async {
  Iterable it = Iterable.empty();

  it = await handleResponse(await buildHttpResponse('${ApiEndPoints.doctorEndPoint}/${EndPointKeys.getAppointmentCountEndPointKey}', request: request, method: HttpMethod.POST));

  return it.map((e) => WeeklyAppointment.fromJson(e)).toList();
}
