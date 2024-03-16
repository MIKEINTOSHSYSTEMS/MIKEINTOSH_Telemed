//Start Service API
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/base_response.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/network/auth_repository.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

Future<List<ServiceData>> getServiceListAPI({String? searchString, required int? id, required int page, int? perPages, Function(bool)? lastPageCallback}) async {
  if (!appStore.isConnectedToInternet) return [];

  List<String> param = [];
  List<ServiceData> serviceList = [];

  if (isReceptionist()) {
    param.add('clinic_id=$id');
  } else if (isDoctor()) {
    param.add('doctor_id=$id');
  }
  if (searchString.validate().isNotEmpty) param.add('s=$searchString');

  ServiceListModel res = ServiceListModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(
    endPoint: 'kivicare/api/v1/service/get-list',
    page: page,
    params: param,
    perPages: perPages,
  ))));

  if (page == 1) serviceList.clear();

  lastPageCallback?.call(res.serviceData.validate().length != (perPages ?? PER_PAGE));

  serviceList.addAll(res.serviceData.validate());

  appStore.setLoading(false);
  return serviceList;
}

Future<ServiceListModel> getServiceResponseAPI({int? doctorId, String? searchString, String? clinicId}) async {
  List<String> params = [];

  if (doctorId != null) {
    params.add('?doctor_id=${doctorId.validate()}');
  }
  if (clinicId != null) params.add('clinic_id=$clinicId');
  if (searchString.validate().isNotEmpty) params.add('s=$searchString');

  return ServiceListModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/service/get-list${params.validate().join('&')}'))));
}

Future<BaseResponses> deleteServiceDataAPI(Map request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/service/delete-service', request: request, method: HttpMethod.POST)));
}

Future<BaseResponses> saveServiceAPI({required Map<String, dynamic> data, File? serviceImage, List<UserModel>? tempList, List<int>? mappingTableIdsList}) async {
  var multiPartRequest = await getMultiPartRequest('kivicare/api/v1/service/add-service');
  multiPartRequest.fields.addAll(await getMultipartFields(val: data));

  if (isReceptionist()) {
    if (tempList != null && tempList.validate().isNotEmpty) {
      tempList.forEach((element) async {
        int index = tempList.indexOf(element);
        multiPartRequest.fields['doctors[$index][doctor_id]'] = element.doctorId.toString();
        multiPartRequest.fields['doctors[$index][status]'] = element.status.validate();
        multiPartRequest.fields['doctors[$index][is_multiple_selection]'] = element.multiple.getIntBool().toString();
        multiPartRequest.fields['doctors[$index][is_telemed]'] = element.isTelemed.getIntBool().toString();
        multiPartRequest.fields['doctors[$index][duration]'] = element.duration.toString();
        multiPartRequest.fields['doctors[$index][charges]'] = element.charges.toString();
        if (element.mappingTableId != null && element.mappingTableId!.isNotEmpty) {
          multiPartRequest.fields['doctors[$index][mapping_table_id]'] = element.mappingTableId.toString();
        }
        if (element.imageFile != null) {
          multiPartRequest.files.add(await MultipartFile.fromPath('doctors[$index][image]', element.imageFile!.path));
          log('doctors[$index][image]: ${element.imageFile!.path}');
        }
      });
    }
  } else {
    if (serviceImage != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath('doctors[0][image]', serviceImage.path));
    }
  }

  log("Multi Part Request : ${jsonEncode(multiPartRequest.fields)}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  return await sendMultiPartRequestNew(multiPartRequest).then((value) {
    appStore.setLoading(false);

    return BaseResponses.fromJson(value);
  });
}

Future<List<ServiceData>> getServiceListWithPaginationAPI({String? searchString, int? clinicId, required List<ServiceData> serviceList, required int page, Function(bool)? lastPageCallback}) async {
  if (!appStore.isConnectedToInternet) return [];
  List<String> param = [];

  if (isReceptionist()) {
    param.add('?clinic_id=${userStore.userClinicId}');
  }
  param.add('?limit=$PER_PAGE');
  param.add('page=$page');

  if (searchString.validate().isNotEmpty) param.add('s=$searchString');

  ServiceListModel res = ServiceListModel.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/service/get-list${param.validate().join('&')}')));

  if (page == 1) serviceList.clear();

  lastPageCallback?.call(res.serviceData.validate().length != PER_PAGE);

  serviceList.addAll(res.serviceData.validate());

  appStore.setLoading(false);
  return serviceList;
}

Future<List<ServiceData>> getClinicWiseDoctorsServiceData(
    {String? serviceId, required String serviceName, String? doctorId, required List<ServiceData> serviceList, required int page, Function(bool)? lastPageCallback}) async {
  if (!appStore.isConnectedToInternet) return [];
  List<String> param = [];
  param.add('?limit=$PER_PAGE');
  param.add('page=$page');
  param.add('doctor_id=$doctorId');
  param.add('s=$serviceName');

  ServiceListModel res = ServiceListModel.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/service/get-list${param.validate().join('&')}')));

  if (page == 1) serviceList.clear();

  lastPageCallback?.call(res.serviceData.validate().length != PER_PAGE);

  serviceList.addAll(res.serviceData.validate());

  appStore.setLoading(false);
  return serviceList;
}

//End Service API
