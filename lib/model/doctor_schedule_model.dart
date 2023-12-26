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
  String? clinic_id;
  List<String>? days;
  String? doctor_id;
  String? doctors;
  String? id;
  String? specialties;
  String? clinic_name;
  SOneEndTime? s_one_end_time;
  SOneEndTime? s_one_start_time;
  SOneEndTime? s_two_end_time;
  SOneEndTime? s_two_start_time;
  String? time_slot;

  //Local
  String get morningStart => '${s_one_start_time!.hH.validate(value: '00')}:${s_one_start_time!.mm.validate(value: '00')}';
  String get morningEnd => '${s_one_end_time!.hH.validate(value: '00')}:${s_one_end_time!.mm.validate(value: '00')}';
  String get eveningStart => '${s_two_start_time!.hH.validate(value: '00')}:${s_two_start_time!.mm.validate(value: '00')}';
  String get eveningEnd => '${s_two_end_time!.hH.validate(value: '00')}:${s_two_end_time!.mm.validate(value: '00')}';

  SessionData({
    this.clinic_id,
    this.days,
    this.doctor_id,
    this.doctors,
    this.id,
    this.clinic_name,
    this.s_one_end_time,
    this.s_one_start_time,
    this.s_two_end_time,
    this.s_two_start_time,
    this.time_slot,
    this.specialties,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      clinic_id: json['clinic_id'],
      days: json['days'] != null ? new List<String>.from(json['days']) : null,
      doctor_id: json['doctor_id'],
      doctors: json['doctors'],
      id: json['id'],
      s_one_end_time: json['s_one_end_time'] != null ? SOneEndTime.fromJson(json['s_one_end_time']) : null,
      s_one_start_time: json['s_one_start_time'] != null ? SOneEndTime.fromJson(json['s_one_start_time']) : null,
      s_two_end_time: json['s_two_end_time'] != null ? SOneEndTime.fromJson(json['s_two_end_time']) : null,
      s_two_start_time: json['s_two_start_time'] != null ? SOneEndTime.fromJson(json['s_two_start_time']) : null,
      time_slot: json['time_slot'],
      specialties: json['specialties'],
      clinic_name: json['clinic_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinic_id'] = this.clinic_id;
    data['doctor_id'] = this.doctor_id;
    data['doctors'] = this.doctors;
    data['id'] = this.id;
    data['time_slot'] = this.time_slot;
    data['specialties'] = this.specialties;
    data['clinic_name'] = this.clinic_name;
    if (this.days != null) {
      data['days'] = this.days;
    }
    if (this.s_one_end_time != null) {
      data['s_one_end_time'] = this.s_one_end_time!.toJson();
    }
    if (this.s_one_start_time != null) {
      data['s_one_start_time'] = this.s_one_start_time!.toJson();
    }
    if (this.s_two_end_time != null) {
      data['s_two_end_time'] = this.s_two_end_time!.toJson();
    }
    if (this.s_two_start_time != null) {
      data['s_two_start_time'] = this.s_two_start_time!.toJson();
    }
    return data;
  }
}

class SOneEndTime {
  String? hH;
  String? mm;

  SOneEndTime({this.hH, this.mm});

  factory SOneEndTime.fromJson(Map<String, dynamic> json) {
    return SOneEndTime(
      hH: json['HH'],
      mm: json['mm'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hH'] = this.hH;
    data['mm'] = this.mm;
    return data;
  }
}
