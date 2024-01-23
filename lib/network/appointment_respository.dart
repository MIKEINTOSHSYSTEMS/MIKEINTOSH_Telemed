import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:momona_healthcare/config.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/appoinment_model.dart';
import 'package:momona_healthcare/model/appointment_slot_model.dart';
import 'package:momona_healthcare/model/confirm_appointment_response_model.dart';
import 'package:momona_healthcare/model/doctor_dashboard_model.dart';
import 'package:momona_healthcare/model/static_data_model.dart';
import 'package:momona_healthcare/network/dashboard_repository.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/screens/patient/models/patient_encounter_model.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

Future<List<StaticData?>> getSpecialization() async {
  return getStaticDataResponse(SPECIALIZATION.toLowerCase()).then((value) {
    log("================ Loaded Static Data  ${value.staticData?.length}================ ");
    listAppStore.addSpecialization(value.staticData.validate());
    return value.staticData.validate();
  }).catchError((e) {
    toast(e.toString());
  });
}

Future<PatientEncounterModel> getPatientAppointmentList({String? status, int? patientId}) async {
  PatientEncounterModel value = PatientEncounterModel.fromJson(await (handleResponse(await buildHttpResponse(
    'kivicare/api/v1/appointment/get-appointment?status=$status&patient_id=$patientId&page=1&limit=10',
  ))));
  return value;
}

Future<List<UpcomingAppointment>> getPatientAppointmentListNew(int? patientId, {String? status, page, required List<UpcomingAppointment> appointmentList, Function(bool)? lastPageCallback, Function(int)? getTotalPatient}) async {
  appStore.setLoading(true);
  List<String> param = [];

  param.add(patientId != null ? '&patient_id=$patientId' : '');
  param.add('status=${appStore.mStatus}');

  PatientEncounterModel res = PatientEncounterModel.fromJson(await (handleResponse(await buildHttpResponse(
    getEndPoint(endPoint: 'kivicare/api/v1/appointment/get-appointment', page: page, params: param),
  ))));

  getTotalPatient?.call(res.total.validate().toInt());

  if (page == 1) appointmentList.clear();

  lastPageCallback?.call(res.upcomingAppointmentData.validate().length != PER_PAGE);

  appointmentList.addAll(res.upcomingAppointmentData.validate());

  appStore.setLoading(false);

  return appointmentList;
}

Future<List<UpcomingAppointment>> getReceptionistAppointmentList({
  bool isPast = false,
  String? todayDate,
  String? startDate,
  String? endDate,
  String status = "all",
  int? page,
  required List<UpcomingAppointment> appointmentList,
  Function(bool)? lastPageCallback,
  Function(int)? getTotalAppointment,
}) async {
  appStore.setLoading(true);
  List<String> param = [];

  if (todayDate == null) {
    param.add('?page=$page');
    param.add('limit=$PER_PAGE');
    param.add('start=$startDate');
    param.add('end=$endDate');
  } else {
    param.add('?status=$status');
    param.add('page=$page');
    param.add('limit=$PER_PAGE');
    if (!isPast) param.add('date=$todayDate');
  }

  AppointmentModel res = AppointmentModel.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/appointment/get-appointment${param.validate().join('&')}')));

  getTotalAppointment?.call(res.total.validate().toInt());

  if (page == 1) appointmentList.clear();

  lastPageCallback?.call(res.appointmentData.validate().length != PER_PAGE);

  appointmentList.addAll(res.appointmentData.validate());

  appStore.setLoading(false);
  return appointmentList;
}

//region Appointment

Future<AppointmentModel> getAppointmentData({bool isPast = false, String? todayDate, String? startDate, String? endDate, String status = "all", int? page}) async {
  AppointmentModel value;

  if (todayDate == null) {
    value = AppointmentModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/appointment/get-appointment?page=1&limit=10&start=$startDate&end=$endDate'))));
  } else {
    if (isPast) {
      value = AppointmentModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/appointment/get-appointment?status=$status&page=$page&limit=$PER_PAGE'))));
    } else {
      value = AppointmentModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/appointment/get-appointment?status=$status&page=$page&limit=$PER_PAGE&date=$todayDate'))));
    }
  }
  return value;
}

Future<AppointmentModel> getAppointmentInCalender({String? todayDate, int? page}) async {
  AppointmentModel value;

  value = AppointmentModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/appointment/get-appointment?&page=$page&limit=$PER_PAGE&date=$todayDate'))));
  return value;
}

Future<List<List<AppointmentSlotModel>>> getAppointmentList({String? appointmentDate, int? id, int? clinicId}) async {
  Iterable it = await (handleResponse(await buildHttpResponse('kivicare/api/v1/doctor/appointment-time-slot?clinic_id=$clinicId&date=$appointmentDate&doctor_id=${id != null ? id : ''}&appointment_id=')));

  List<List<AppointmentSlotModel>> list = [];

  it.forEach((element) {
    Iterable v = element;
    list.add(v.map((e) => AppointmentSlotModel.fromJson(e)).toList());
  });

  return list;
}

Future updateAppointmentStatus(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/appointment/update-status', request: request, method: HttpMethod.POST));
}

Future deleteAppointment(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/appointment/delete', request: request, method: HttpMethod.POST));
}

//region

class AppointmentRequest {
  Future<ConfirmAppointmentResponseModel?> addAppointment(Map<String, dynamic> data, {String? toastMessage}) async {
    var multiPartRequest = await getMultiPartRequest('kivicare/api/v2/appointment/save');

    multiPartRequest.fields['id'] = data['id'];
    multiPartRequest.fields['appointment_start_date'] = data['appointment_start_date'];
    multiPartRequest.fields['appointment_start_time'] = data['appointment_start_time'];
    multiPartRequest.fields['clinic_id'] = data['clinic_id'];
    multiPartRequest.fields['doctor_id'] = data['doctor_id'];
    multiPartRequest.fields['patient_id'] = data['patient_id'];
    multiPartRequest.fields['description'] = data['description'];
    multiPartRequest.fields['status'] = data['status'];

    if (appointmentAppStore.selectedService.isNotEmpty) {
      appointmentAppStore.selectedService.forEachIndexed((index, element) {
        multiPartRequest.fields["visit_type[$element]"] = data['visit_type[$element]'];
      });
    }

    if (appointmentAppStore.reportList.isNotEmpty) {
      multiPartRequest.fields['attachment_count'] = data['attachment_count'];

      await Future.forEach<PlatformFile>(appointmentAppStore.reportList, (element) async {
        multiPartRequest.files.add(await MultipartFile.fromPath('appointment_report_${appointmentAppStore.reportList.indexOf(element)}', File(element.path.validate()).path));
      });
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());

    return await Response.fromStream(await multiPartRequest.send()).then((value) {
      log("value ${value.body}");
      if (value.statusCode.isSuccessful()) {
        return ConfirmAppointmentResponseModel.fromJson(jsonDecode(value.body));
      } else {
        log(value.statusCode);
        toast(errorSomethingWentWrong);
      }
    });
    /* Response response = await Response.fromStream(await multiPartRequest.send());
    if (response.statusCode.isSuccessful()) {
      toast(toastMessage ?? 'Appointment Booked Successfully');

      return true;
    } else {
      log(response.statusCode);
      toast(errorSomethingWentWrong);
      return false;
    }*/
  }
}

AppointmentRequest appointmentRequest = AppointmentRequest();
