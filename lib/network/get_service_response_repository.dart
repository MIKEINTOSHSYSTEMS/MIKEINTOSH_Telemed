import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/service_model.dart';
import 'package:kivicare_flutter/network/network_utils.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
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
