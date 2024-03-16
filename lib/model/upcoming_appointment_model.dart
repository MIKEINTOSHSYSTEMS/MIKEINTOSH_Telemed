import 'package:intl/intl.dart';
import 'package:momona_healthcare/model/rating_model.dart';
import 'package:momona_healthcare/model/tax_model.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/constants.dart';

class UpcomingAppointmentModel {
  String? appointmentEndDate;
  String? appointmentEndTime;
  String? appointmentStartDate;
  String? appointmentStartTime;
  String? clinicId;
  String? clinicName;
  String? createdAt;
  String? description;
  String? doctorId;
  String? doctorName;
  String? encounterId;
  num? encounterStatus;
  String? id;
  String? patientId;
  String? patientName;
  String? status;
  String? visitLabel;
  List<VisitType>? visitType;
  ZoomData? zoomData;
  num? allServiceCharges;
  List<AppointmentReport>? appointmentReport;
  String? discountCode;
  String? doctorProfileImg;
  String? patientProfileImg;
  bool? videoConsultation;
  RatingData? doctorRating;
  String? paymentMethod;
  String? appointmentGlobalStartDate;

  TaxModel? taxData;

  String? googleMeetData;

  //Extra? extra;

  // Local Variable

  String get getAppointmentDisplayDate => appointmentGlobalStartDate.validate().getFormattedDate(CONFIRM_APPOINTMENT_FORMAT);

  String get getDisplayAppointmentTime => appointmentStartTime.validate().getFormattedTime() + " - " + appointmentEndTime.validate().getFormattedTime();

  String get getAppointmentTime => DateFormat(ONLY_HOUR_MINUTE).parse(appointmentStartTime.validate()).getFormattedDate(FORMAT_12_HOUR);

  String get getAppointmentStartDate => appointmentStartDate.validate();

  String get getAppointmentSaveDate => appointmentStartDate.validate();

  String get getVisitTypesInString => visitType.validate().map((e) => e.serviceName.validate()).join(", ");

  String get getProfileImage => isPatient() ? doctorProfileImg.validate() : patientProfileImg.validate();

  String get appointmentDateFormat => "$getAppointmentStartDate   •   $getDisplayAppointmentTime";

  UpcomingAppointmentModel({
    this.appointmentEndDate,
    this.appointmentEndTime,
    this.appointmentStartDate,
    this.appointmentStartTime,
    this.doctorRating,
    this.clinicId,
    this.clinicName,
    this.createdAt,
    this.encounterStatus,
    this.description,
    this.doctorId,
    this.doctorName,
    this.encounterId,
    this.id,
    this.patientId,
    this.patientName,
    this.status,
    this.visitLabel,
    this.visitType,
    this.zoomData,
    this.allServiceCharges,
    this.doctorProfileImg,
    this.patientProfileImg,
    this.appointmentReport,
    this.discountCode,
    this.appointmentGlobalStartDate,
    this.videoConsultation,
    this.paymentMethod,
    this.googleMeetData,
    this.taxData,
  });

  factory UpcomingAppointmentModel.fromJson(Map<String, dynamic> json) {
    return UpcomingAppointmentModel(
      appointmentEndDate: json['appointment_end_date'],
      appointmentEndTime: json['appointment_end_time'],
      appointmentStartDate: json['appointment_start_date'],
      appointmentGlobalStartDate: json['start_date'],
      appointmentStartTime: json['appointment_start_time'],
      clinicId: json['clinic_id'],
      clinicName: json['clinic_name'],
      encounterStatus: json['encounter_status'],
      doctorProfileImg: json['doctor_profile_img'],
      patientProfileImg: json['patient_profile_img'],
      createdAt: json['created_at'],
      description: json['description'],
      taxData: json['tax_data'] != null ? TaxModel.fromJson(json['tax_data']) : null,
      appointmentReport: json['appointment_report'] != null ? (json['appointment_report'] as List).map((i) => AppointmentReport.fromJson(i)).toList() : [],
      visitType: json['visit_type'] != null ? (json['visit_type'] as List).map((i) => VisitType.fromJson(i)).toList() : [],
      doctorId: json['doctor_id'],
      discountCode: json['discount_code'],
      doctorName: json['doctor_name'],
      encounterId: json['encounter_id'],
      id: json['id'],
      allServiceCharges: json['all_service_charges'].runtimeType == String ? (json['all_service_charges'] as String).toDouble() : json['all_service_charges'],
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      status: json['status'],
      visitLabel: json['visit_label'],
      zoomData: json['zoom_data'] != null ? new ZoomData.fromJson(json['zoom_data']) : null,
      doctorRating: json['review'] != null ? new RatingData.fromJson(json['review']) : null,
      paymentMethod: json['payment_mode'],
      googleMeetData: json['google_meet_data'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_end_date'] = this.appointmentEndDate;
    data['appointment_end_time'] = this.appointmentEndTime;
    data['appointment_start_date'] = this.appointmentStartDate;
    data['appointment_start_time'] = this.appointmentStartTime;
    data['clinic_id'] = this.clinicId;
    data['clinic_name'] = this.clinicName;
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['doctor_id'] = this.doctorId;
    data['encounter_status'] = this.encounterStatus;
    data['doctor_name'] = this.doctorName;
    data['doctor_profile_img'] = this.doctorProfileImg;
    data['patient_profile_img'] = this.patientProfileImg;
    data['encounter_id'] = this.encounterId;
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['all_service_charges'] = this.patientId;
    data['patient_name'] = this.patientName;
    data['status'] = this.status;
    data['discount_code'] = this.discountCode;
    data['start_date'] = this.appointmentGlobalStartDate;
    data['payment_mode'] = this.paymentMethod;
    data['google_meet_data'] = this.googleMeetData;
    data['tax_data'] = this.taxData;

    if (this.appointmentReport != null) {
      data['appointment_report'] = this.appointmentReport!.map((v) => v.toJson()).toList();
    }
    data['visit_label'] = this.visitLabel;
    if (this.visitType != null) {
      data['visit_type'] = this.visitType!.map((v) => v.toJson()).toList();
    }

    if (this.zoomData != null) {
      data['zoom_data'] = this.zoomData!.toJson();
    }
    if (this.doctorRating != null) {
      data['review'] = this.doctorRating!.toJson();
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
  String? serviceId;
  String? serviceName;
  String? charges;

  VisitType({this.id, this.serviceId, this.serviceName, this.charges});

  factory VisitType.fromJson(Map<String, dynamic> json) {
    return VisitType(
      id: json['id'],
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      charges: json['charges'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
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
