import 'package:kivicare_flutter/model/login_response_model.dart';

class PatientResponseModel {
  String? address;
  String? city;
  List<Clinic>? clinic;
  String? country;
  String? dob;
  String? first_name;
  String? gender;
  String? isTeleMedActive;
  String? last_name;
  String? mobile_number;
  List<ModuleConfig>? module_config;
  String? postal_code;
  String? price;
  String? price_type;
  String? profile_image;
  List<Qualification>? qualifications;
  String? role;
  List<Specialty>? specialties;
  String? state;
  String? token;
  String? user_display_name;
  String? user_email;
  int? user_id;
  String? user_nicename;

  PatientResponseModel(
      {this.address,
      this.city,
      this.clinic,
      this.country,
      this.dob,
      this.first_name,
      this.gender,
      this.isTeleMedActive,
      this.last_name,
      this.mobile_number,
      this.module_config,
      this.postal_code,
      this.price,
      this.price_type,
      this.profile_image,
      this.qualifications,
      this.role,
      this.specialties,
      this.state,
      this.token,
      this.user_display_name,
      this.user_email,
      this.user_id,
      this.user_nicename});

  factory PatientResponseModel.fromJson(Map<String, dynamic> json) {
    return PatientResponseModel(
      address: json['address'],
      city: json['city'],
      clinic: json['clinic'] != null ? (json['clinic'] as List).map((i) => Clinic.fromJson(i)).toList() : null,
      country: json['country'],
      dob: json['dob'],
      first_name: json['first_name'],
      gender: json['gender'],
      isTeleMedActive: json['isTeleMedActive'],
      last_name: json['last_name'],
      mobile_number: json['mobile_number'],
      module_config: json['module_config'] != null ? (json['module_config'] as List).map((i) => ModuleConfig.fromJson(i)).toList() : null,
      postal_code: json['postal_code'],
      price: json['price'],
      price_type: json['price_type'],
      profile_image: json['profile_image'],
      qualifications: json['qualifications'] != null ? (json['qualifications'] as List).map((i) => Qualification.fromJson(i)).toList() : null,
      role: json['role'],
      specialties: json['specialties'] != null ? (json['specialties'] as List).map((i) => Specialty.fromJson(i)).toList() : null,
      state: json['state'],
      token: json['token'],
      user_display_name: json['user_display_name'],
      user_email: json['user_email'],
      user_id: json['user_id'],
      user_nicename: json['user_nicename'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['dob'] = this.dob;
    data['first_name'] = this.first_name;
    data['gender'] = this.gender;
    data['isTeleMedActive'] = this.isTeleMedActive;
    data['last_name'] = this.last_name;
    data['mobile_number'] = this.mobile_number;
    data['postal_code'] = this.postal_code;
    data['price'] = this.price;
    data['price_type'] = this.price_type;
    data['profile_image'] = this.profile_image;
    data['role'] = this.role;
    data['state'] = this.state;
    data['token'] = this.token;
    data['user_display_name'] = this.user_display_name;
    data['user_email'] = this.user_email;
    data['user_id'] = this.user_id;
    data['user_nicename'] = this.user_nicename;
    if (this.clinic != null) {
      data['clinic'] = this.clinic!.map((v) => v.toJson()).toList();
    }
    if (this.module_config != null) {
      data['module_config'] = this.module_config!.map((v) => v.toJson()).toList();
    }
    if (this.qualifications != null) {
      data['qualifications'] = this.qualifications!.map((v) => v.toJson()).toList();
    }
    if (this.specialties != null) {
      data['specialties'] = this.specialties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Qualification {
  String? file;
  String? degree;
  String? university;
  String? year;

  Qualification({this.file, this.degree, this.university, this.year});

  factory Qualification.fromJson(Map<String, dynamic> json) {
    return Qualification(
      file: json['file'],
      degree: json['degree'],
      university: json['university'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file'] = this.file;
    data['degree'] = this.degree;
    data['university'] = this.university;
    data['year'] = this.year;
    return data;
  }
}

class Specialty {
  String? id;
  String? label;

  Specialty({this.id, this.label});

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      id: json['id'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    return data;
  }
}

class ModuleConfig {
  String? label;
  String? name;
  String? status;

  ModuleConfig({this.label, this.name, this.status});

  factory ModuleConfig.fromJson(Map<String, dynamic> json) {
    return ModuleConfig(
      label: json['label'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
