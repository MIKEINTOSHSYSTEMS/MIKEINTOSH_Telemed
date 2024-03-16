import 'package:nb_utils/nb_utils.dart';

class DoctorSessionModel {
  List<SessionData>? sessionData;
  int? total;

  DoctorSessionModel({this.sessionData, this.total});

  factory DoctorSessionModel.fromJson(Map<String, dynamic> json) {
    return DoctorSessionModel(
      sessionData: json['data'] != null ? (json['data'] as List).map((i) => SessionData.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.sessionData != null) {
      data['data'] = this.sessionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SessionData {
  String? clinicId;
  List<String>? days;
  String? doctorId;
  String? doctors;
  String? id;
  String? specialties;
  String? clinicName;
  String? clinicImage;
  String? doctorImage;
  SOneEndTime? sOneEndTime;
  SOneEndTime? sOneStartTime;
  SOneEndTime? sTwoEndTime;
  SOneEndTime? sTwoStartTime;
  String? timeSlot;

  //Local
  String get morningStart => '${sOneStartTime!.hh.validate(value: '00')}:${sOneStartTime!.mm.validate(value: '00')}';

  String get morningEnd => '${sOneEndTime!.hh.validate(value: '00')}:${sOneEndTime!.mm.validate(value: '00')}';

  String get eveningStart => '${sTwoStartTime!.hh.validate(value: '00')}:${sTwoStartTime!.mm.validate(value: '00')}';

  String get eveningEnd => '${sTwoEndTime!.hh.validate(value: '00')}:${sTwoEndTime!.mm.validate(value: '00')}';

  String get morningTime => morningStart == "00:00" ? "--" : morningStart + " to " + morningEnd;

  String get eveningTime => eveningStart == "00:00" ? "--" : eveningStart + " to " + eveningEnd;

  SessionData({
    this.clinicId,
    this.days,
    this.doctorId,
    this.doctors,
    this.id,
    this.clinicImage,
    this.doctorImage,
    this.clinicName,
    this.sOneEndTime,
    this.sOneStartTime,
    this.sTwoEndTime,
    this.sTwoStartTime,
    this.timeSlot,
    this.specialties,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      clinicId: json['clinic_id'],
      days: json['days'] != null ? new List<String>.from(json['days']) : null,
      doctorId: json['doctor_id'],
      doctors: json['doctors'],
      id: json['id'],
      clinicImage: json['clinic_image'],
      doctorImage: json['doctor_image'],
      sOneEndTime: json['s_one_end_time'] != null ? SOneEndTime.fromJson(json['s_one_end_time']) : null,
      sOneStartTime: json['s_one_start_time'] != null ? SOneEndTime.fromJson(json['s_one_start_time']) : null,
      sTwoEndTime: json['s_two_end_time'] != null ? SOneEndTime.fromJson(json['s_two_end_time']) : null,
      sTwoStartTime: json['s_two_start_time'] != null ? SOneEndTime.fromJson(json['s_two_start_time']) : null,
      timeSlot: json['time_slot'],
      specialties: json['specialties'],
      clinicName: json['clinic_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinic_id'] = this.clinicId;
    data['doctor_id'] = this.doctorId;
    data['doctors'] = this.doctors;
    data['id'] = this.id;
    data['time_slot'] = this.timeSlot;
    data['specialties'] = this.specialties;
    data['clinic_image'] = this.clinicImage;
    data['doctor_image'] = this.doctorImage;
    data['clinic_name'] = this.clinicName;
    if (this.days != null) {
      data['days'] = this.days;
    }
    if (this.sOneEndTime != null) {
      data['s_one_end_time'] = this.sOneEndTime!.toJson();
    }
    if (this.sOneStartTime != null) {
      data['s_one_start_time'] = this.sOneStartTime!.toJson();
    }
    if (this.sTwoEndTime != null) {
      data['s_two_end_time'] = this.sTwoEndTime!.toJson();
    }
    if (this.sTwoStartTime != null) {
      data['s_two_start_time'] = this.sTwoStartTime!.toJson();
    }
    return data;
  }
}

class SOneEndTime {
  String? hh;
  String? mm;

  SOneEndTime({this.hh, this.mm});

  factory SOneEndTime.fromJson(Map<String, dynamic> json) {
    return SOneEndTime(
      hh: json['HH'],
      mm: json['mm'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hH'] = this.hh;
    data['mm'] = this.mm;
    return data;
  }
}
