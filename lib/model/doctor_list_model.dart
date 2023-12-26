import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorListModel {
  List<DoctorList>? doctorList;
  int? total;

  DoctorListModel({this.doctorList, this.total});

  factory DoctorListModel.fromJson(Map<String, dynamic> json) {
    return DoctorListModel(
      doctorList: json['data'] != null ? (json['data'] as List).map((i) => DoctorList.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.doctorList != null) {
      data['data'] = this.doctorList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoctorList {
  String? available;
  List<String>? clinic_id;
  String? clinic_name;
  String? display_name;
  String? gender;
  int? iD;
  String? mobile_number;
  var no_of_experience;
  String? profile_image;
  String? specialties;
  String? user_email;
  String? user_status;
  bool isCheck;

  DoctorList({
    this.available,
    this.clinic_id,
    this.clinic_name,
    this.display_name,
    this.gender,
    this.iD,
    this.mobile_number,
    this.no_of_experience,
    this.profile_image,
    this.specialties,
    this.user_email,
    this.user_status,
    this.isCheck = false,
  });

  String get profileImage => gender.validate().toLowerCase() == "male" ? ic_doctor2 : ic_doctor1;

  factory DoctorList.fromJson(Map<String, dynamic> json) {
    return DoctorList(
      available: json['available'],
      clinic_id: json['clinic_id'] != null ? new List<String>.from(json['clinic_id']) : null,
      clinic_name: json['clinic_name'],
      display_name: json['display_name'],
      gender: json['gender'],
      iD: json['ID'],
      mobile_number: json['mobile_number'],
      no_of_experience: json['no_of_experience'],
      profile_image: json['profile_image'],
      specialties: json['specialties'],
      user_email: json['user_email'],
      user_status: json['user_status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available'] = this.available;
    data['clinic_name'] = this.clinic_name;
    data['display_name'] = this.display_name;
    data['gender'] = this.gender;
    data['ID'] = this.iD;
    data['mobile_number'] = this.mobile_number;
    data['no_of_experience'] = this.no_of_experience;
    // data['profile_image'] = this.profile_image;
    data['specialties'] = this.specialties;
    data['user_email'] = this.user_email;
    data['user_status'] = this.user_status;
    if (this.clinic_id != null) {
      data['clinic_id'] = this.clinic_id;
    }
    return data;
  }
}
