import 'package:intl/intl.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorDashboardModel {
  int? total_appointment;
  int? total_patient;
  int? total_service;
  List<UpcomingAppointment>? upcoming_appointment;
  int? upcoming_appointment_total;
  List<WeeklyAppointment>? weekly_appointment;

  DoctorDashboardModel({this.total_appointment, this.total_service, this.total_patient, this.upcoming_appointment, this.upcoming_appointment_total, this.weekly_appointment});

  factory DoctorDashboardModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardModel(
      total_appointment: json['total_appointment'],
      total_patient: json['total_patient'],
      total_service: json['total_service'],
      upcoming_appointment: json['upcoming_appointment'] != null ? (json['upcoming_appointment'] as List).map((i) => UpcomingAppointment.fromJson(i)).toList() : null,
      upcoming_appointment_total: json['upcoming_appointment_total'],
      weekly_appointment: json['weekly_appointment'] != null ? (json['weekly_appointment'] as List).map((i) => WeeklyAppointment.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_appointment'] = this.total_appointment;
    data['total_patient'] = this.total_patient;
    data['total_service'] = this.total_service;
    data['upcoming_appointment_total'] = this.upcoming_appointment_total;
    if (this.upcoming_appointment != null) {
      data['upcoming_appointment'] = this.upcoming_appointment!.map((v) => v.toJson()).toList();
    }
    if (this.weekly_appointment != null) {
      data['weekly_appointment'] = this.weekly_appointment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpcomingAppointment {
  String? appointment_end_date;
  String? appointment_end_time;
  String? appointment_start_date;
  String? appointment_start_time;
  String? clinic_id;
  String? clinic_name;
  String? created_at;
  String? description;
  String? doctor_id;
  String? doctor_name;
  String? encounter_id;
  String? id;
  String? patient_id;
  String? patient_name;
  String? status;
  String? visit_label;
  List<VisitType>? visit_type;
  ZoomData? zoomData;
  int? all_service_charges;
  List<AppointmentReport>? appointment_report;
  String? discount_code;
  bool? video_consultation;

  // Local Variable
  String get getAppointmentTime =>
      DateFormat(TIME_WITH_SECONDS).parse(appointment_start_time.validate()).getFormattedDate(FORMAT_12_HOUR) + " - " + DateFormat(TIME_WITH_SECONDS).parse(appointment_end_time.validate()).getFormattedDate(FORMAT_12_HOUR);

  String get getAppointmentStartTime => appointment_start_date.validate().getFormattedDate(APPOINTMENT_DATE_FORMAT);

  String get getVisitTypes => visit_type.validate().map((e) => e.service_name.validate()).join(", ");

  UpcomingAppointment(
      {this.appointment_end_date,
      this.appointment_end_time,
      this.appointment_start_date,
      this.appointment_start_time,
      this.clinic_id,
      this.clinic_name,
      this.created_at,
      this.description,
      this.doctor_id,
      this.doctor_name,
      this.encounter_id,
      this.id,
      this.patient_id,
      this.patient_name,
      this.status,
      this.visit_label,
      this.visit_type,
      this.zoomData,
      this.all_service_charges,
      this.appointment_report,
      this.discount_code,
      this.video_consultation});

  factory UpcomingAppointment.fromJson(Map<String, dynamic> json) {
    return UpcomingAppointment(
      appointment_end_date: json['appointment_end_date'],
      appointment_end_time: json['appointment_end_time'],
      appointment_start_date: json['appointment_start_date'],
      appointment_start_time: json['appointment_start_time'],
      clinic_id: json['clinic_id'],
      clinic_name: json['clinic_name'],
      created_at: json['created_at'],
      description: json['description'].toString().validate().isNotEmpty ? json['description'] : "NA",
      appointment_report: json['appointment_report'] != null ? (json['appointment_report'] as List).map((i) => AppointmentReport.fromJson(i)).toList() : [],
      doctor_id: json['doctor_id'],
      discount_code: json['discount_code'],
      doctor_name: json['doctor_name'],
      encounter_id: json['encounter_id'],
      id: json['id'],
      all_service_charges: json['all_service_charges'],
      patient_id: json['patient_id'],
      patient_name: json['patient_name'],
      status: json['status'],
      visit_label: json['visit_label'],
      visit_type: json['visit_type'] != null
          ? (json['visit_type'] is String)
              ? json['visit_type']
              : (json['visit_type'] as List).map((i) => VisitType.fromJson(i)).toList()
          : null,
      zoomData: json['zoom_data'] != null ? new ZoomData.fromJson(json['zoom_data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_end_date'] = this.appointment_end_date;
    data['appointment_end_time'] = this.appointment_end_time;
    data['appointment_start_date'] = this.appointment_start_date;
    data['appointment_start_time'] = this.appointment_start_time;
    data['clinic_id'] = this.clinic_id;
    data['clinic_name'] = this.clinic_name;
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['doctor_id'] = this.doctor_id;
    data['doctor_name'] = this.doctor_name;
    data['encounter_id'] = this.encounter_id;
    data['id'] = this.id;
    data['patient_id'] = this.patient_id;
    data['all_service_charges'] = this.patient_id;
    data['patient_name'] = this.patient_name;
    data['status'] = this.status;
    data['discount_code'] = this.discount_code;
    if (this.appointment_report != null) {
      data['appointment_report'] = this.appointment_report!.map((v) => v.toJson()).toList();
    }
    data['visit_label'] = this.visit_label;
    if (this.visit_type != null) {
      data['visit_type'] = this.visit_type!.map((v) => v.toJson()).toList();
    }
    if (this.zoomData != null) {
      data['zoom_data'] = this.zoomData!.toJson();
    }
    return data;
  }
}

class AppointmentReport {
  int? id;
  var url;

  AppointmentReport({this.id, this.url});

  factory AppointmentReport.fromJson(Map<String, dynamic> json) {
    return AppointmentReport(
      id: json['id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}

class WeeklyAppointment {
  String? x;
  int? y;

  WeeklyAppointment({this.x, this.y});

  factory WeeklyAppointment.fromJson(Map<String, dynamic> json) {
    return WeeklyAppointment(
      x: json['x'],
      y: json['y'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}

class VisitType {
  String? id;
  String? service_id;
  String? service_name;
  String? charges;

  VisitType({this.id, this.service_id, this.service_name, this.charges});

  factory VisitType.fromJson(Map<String, dynamic> json) {
    return VisitType(
      id: json['id'],
      service_id: json['service_id'],
      service_name: json['service_name'],
      charges: json['charges'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_id'] = this.service_id;
    data['service_name'] = this.service_name;
    data['charges'] = this.charges;
    return data;
  }
}

class ZoomData {
  String? id;
  String? appointmentId;
  String? zoomId;
  String? zoomUuid;
  String? startUrl;
  String? joinUrl;
  String? password;
  String? createdAt;

  ZoomData({this.id, this.appointmentId, this.zoomId, this.zoomUuid, this.startUrl, this.joinUrl, this.password, this.createdAt});

  ZoomData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appointmentId = json['appointment_id'];
    zoomId = json['zoom_id'];
    zoomUuid = json['zoom_uuid'];
    startUrl = json['start_url'];
    joinUrl = json['join_url'];
    password = json['password'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appointment_id'] = this.appointmentId;
    data['zoom_id'] = this.zoomId;
    data['zoom_uuid'] = this.zoomUuid;
    data['start_url'] = this.startUrl;
    data['join_url'] = this.joinUrl;
    data['password'] = this.password;
    data['created_at'] = this.createdAt;
    return data;
  }
}
