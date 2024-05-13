import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/base_response.dart';
import 'package:kivicare_flutter/model/holiday_model.dart';
import 'package:kivicare_flutter/network/network_utils.dart';

//Start Holidays API

Future<HolidayModel> getHolidayResponseAPI() async {
  if (!appStore.isConnectedToInternet) {
    return HolidayModel();
  }

  return HolidayModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/setting/clinic-schedule-list'))));
}

Future<BaseResponses> addHolidayDataAPI(Map request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/setting/save-clinic-schedule', request: request, method: HttpMethod.POST)));
}

Future<BaseResponses> deleteHolidayDataAPI(Map request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/setting/delete-clinic-schedule', request: request, method: HttpMethod.POST)));
}

//End Holidays API
