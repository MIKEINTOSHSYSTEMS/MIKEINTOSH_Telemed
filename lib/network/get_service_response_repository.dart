import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';

Future<List<ServiceData>> getServiceResponseNew({required int? id, required int page, required List<ServiceData> serviceList, int? perPages, Function(bool)? lastPageCallback, Function(int)? getTotalService}) async {
  appStore.setLoading(true);
  List<String> param = [];

  if (id != null) param.add('doctor_id=$id');

  ServiceListModel res = ServiceListModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: 'kivicare/api/v1/service/get-list', page: page, params: param, perPages: perPages))));

  getTotalService?.call(res.total.validate().toInt());

  if (page == 1) serviceList.clear();

  lastPageCallback?.call(res.serviceData.validate().length != (perPages ?? PER_PAGE));

  serviceList.addAll(res.serviceData.validate());

  appStore.setLoading(false);
  return serviceList;
}
