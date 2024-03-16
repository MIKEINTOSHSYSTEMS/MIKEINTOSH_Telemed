import 'dart:convert';
import 'dart:io';

import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/appoinment_model.dart';
import 'package:momona_healthcare/model/appointment_slot_model.dart';
import 'package:momona_healthcare/model/confirm_appointment_response_model.dart';
import 'package:momona_healthcare/model/upcoming_appointment_model.dart';
import 'package:momona_healthcare/network/auth_repository.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/cached_value.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:momona_healthcare/model/encounter_model.dart';

Future<List<UpcomingAppointmentModel>> getPatientAppointmentList(
  int? patientId, {
  String status = 'All',
  required List<UpcomingAppointmentModel> appointmentList,
  page,
  Function(bool)? lastPageCallback,
}) async {
  if (!appStore.isConnectedToInternet) {
    return [];
  }

  List<String> param = [];
  param.add(patientId != null ? '&${ConstantKeys.patientIdKey}=$patientId' : '');
  param.add('${ConstantKeys.statusKey}=$status');

  EncounterModel res = EncounterModel.fromJson(
    await handleResponse(await buildHttpResponse(getEndPoint(endPoint: ApiEndPoints.getAppointmentEndPoint, page: page, params: param))),
  );

  if (page == 1) appointmentList.clear();

  lastPageCallback?.call(res.upcomingAppointmentData.validate().length != PER_PAGE);

  appointmentList.addAll(res.upcomingAppointmentData.validate());
  cachedPatientAppointment = res.upcomingAppointmentData.validate();
  appStore.setLoading(false);

  return appointmentList;
}

Future<List<UpcomingAppointmentModel>> getAppointment({
  int pages = 1,
  int perPage = PER_PAGE,
  String? todayDate,
  String? startDate,
  String? endDate,
  required List<UpcomingAppointmentModel> appointmentList,
  Function(bool)? lastPageCallback,
}) async {
  if (!appStore.isConnectedToInternet) {
    return [];
  }

  AppointmentModel value;

  List<String> params = [];
  params.add('${ConstantKeys.pageKey}=$pages');
  params.add('${ConstantKeys.limitKey}=$perPage');
  if (todayDate != null) params.add('${ConstantKeys.dateKey}=$todayDate');
  if (startDate != null) params.add('${ConstantKeys.startKey}=$startDate');
  if (endDate != null) params.add('${ConstantKeys.endKey}=$endDate');

  value = AppointmentModel.fromJson(await (handleResponse(await buildHttpResponse(getEndPoint(endPoint: ApiEndPoints.getAppointmentEndPoint, params: params)))));
  if (pages == 1) appointmentList.clear();

  appointmentList.addAll(value.appointmentData.validate());
  lastPageCallback?.call(value.appointmentData.validate().length != perPage);
  cachedDoctorAppointment = appointmentList;

  return appointmentList;
}

Future<List<UpcomingAppointmentModel>> getReceptionistAppointmentList({
  bool isPast = false,
  required List<UpcomingAppointmentModel> appointmentList,
  String status = 'All',
  int? page,
  Function(bool)? lastPageCallback,
}) async {
  if (!appStore.isConnectedToInternet) {
    return [];
  }

  List<String> param = [];

  param.add('${ConstantKeys.pageKey}=$page');
  param.add('${ConstantKeys.limitKey}=$PER_PAGE');
  param.add('${ConstantKeys.statusKey}=$status');

  AppointmentModel res = AppointmentModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: ApiEndPoints.getAppointmentEndPoint, params: param))));

  if (page == 1) appointmentList.clear();

  lastPageCallback?.call(res.appointmentData.validate().length != PER_PAGE);

  appointmentList.addAll(res.appointmentData.validate());

  appStore.setLoading(false);
  cachedReceptionistAppointment = appointmentList;
  return appointmentList;
}

//region Appointment

Future<List<List<AppointmentSlotModel>>> getAppointmentTimeSlotList({
  String? appointmentDate,
  String? doctorId,
  String? clinicId,
}) async {
  if (!appStore.isConnectedToInternet) {
    return [];
  }

  List<String> params = [];
  params.add('${ConstantKeys.clinicIdKey}=$clinicId');
  params.add('${ConstantKeys.dateKey}=$appointmentDate');
  params.add('${ConstantKeys.doctorIdKey}=$doctorId');

  Iterable it = await (handleResponse(await buildHttpResponse(getEndPoint(endPoint: ApiEndPoints.getAppointmentTimeSlotsEndpoint, params: params))));

  List<List<AppointmentSlotModel>> list = [];

  it.forEach((element) {
    Iterable v = element;
    list.add(v.map((e) => AppointmentSlotModel.fromJson(e)).toList());
  });

  return list;
}

Future updateAppointmentStatus(Map request) async {
  return await handleResponse(await buildHttpResponse(ApiEndPoints.updateAppointmentStatusEndPoint, request: request, method: HttpMethod.POST));
}

Future deleteAppointment(Map request) async {
  return await handleResponse(await buildHttpResponse(ApiEndPoints.deleteAppointmentEndPoint, request: request, method: HttpMethod.POST));
}

//region
Future<ConfirmAppointmentResponseModel> saveAppointmentApi({required Map<String, dynamic> data, List<File>? files}) async {
  var multiPartRequest = await getMultiPartRequest(ApiEndPoints.saveAppointmentEndPoint);

  multiPartRequest.fields.addAll(await getMultipartFields(val: data));

  if (files.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: files!, name: ConstantKeys.appointmentReportKey));
    multiPartRequest.fields[ConstantKeys.attachmentCountsKey] = files.validate().length.toString();
  }

  multiPartRequest.headers.addAll(buildHeaderTokens());

  appStore.setLoading(true);

  return await sendMultiPartRequestNew(multiPartRequest).then((value) {
    multiSelectStore.clearList();
    return ConfirmAppointmentResponseModel.fromJson(value);
  }).catchError((e) async {
    appStore.setLoading(false);
    toast(e.toString());
    throw e.toString();
  });
}
