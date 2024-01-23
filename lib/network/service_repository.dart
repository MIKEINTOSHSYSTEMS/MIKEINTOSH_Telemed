//Start Service API
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/model/base_response.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';

Future<ServiceListModel> getServiceResponse({int? id, int? page}) async {
  return ServiceListModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/service/get-list?page=$page&limit=$PER_PAGE&doctor_id=${id != null ? id : ''}'))));
}

Future<BaseResponses> addServiceData(Map request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/service/add-service', request: request, method: HttpMethod.POST)));
}

Future<BaseResponses> deleteServiceData(Map request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/service/delete-service', request: request, method: HttpMethod.POST)));
}
//End Service API
