import 'extra_model.dart';

class ClinicListModel {
  List<Clinic>? clinicData;
  int? total;

  ClinicListModel({this.clinicData, this.total});

  factory ClinicListModel.fromJson(Map<String, dynamic> json) {
    return ClinicListModel(
      clinicData: json['data'] != null ? (json['data'] as List).map((i) => Clinic.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.clinicData != null) {
      data['data'] = this.clinicData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clinic {
  String? id;
  String? name;
  String? email;
  String? telephoneNo;
  List<Specialties>? specialties;
  String? address;
  String? city;
  String? country;
  String? postalCode;
  String? status;
  String? clinicAdminId;
  String? clinicLogo;
  String? profileImage;
  Extra? extra;
  String? countryCode;
  String? createdAt;
  String? countryCallingCode;
  bool? isCheck;

  Clinic({
    this.id,
    this.isCheck = false,
    this.name,
    this.email,
    this.telephoneNo,
    this.specialties,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.status,
    this.clinicAdminId,
    this.clinicLogo,
    this.profileImage,
    this.extra,
    this.countryCode,
    this.createdAt,
    this.countryCallingCode,
  });

  Clinic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    telephoneNo = json['telephone_no'];
    if (json['specialties'] != null) {
      specialties = <Specialties>[];
      json['specialties'].forEach((v) {
        specialties!.add(new Specialties.fromJson(v));
      });
    }
    address = json['address'];
    city = json['city'];
    country = json['country'];
    postalCode = json['postal_code'];
    status = json['status'];
    clinicAdminId = json['clinic_admin_id'];
    clinicLogo = json['clinic_logo'];
    profileImage = json['profile_image'];
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
    countryCode = json['country_code'];
    createdAt = json['created_at'];
    countryCallingCode = json['country_calling_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['telephone_no'] = this.telephoneNo;
    if (this.specialties != null) {
      data['specialties'] = this.specialties!.map((v) => v.toJson()).toList();
    }
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['postal_code'] = this.postalCode;
    data['status'] = this.status;
    data['clinic_admin_id'] = this.clinicAdminId;
    data['clinic_logo'] = this.clinicLogo;
    data['profile_image'] = this.profileImage;
    // if (this.extra != null) {
    //   data['extra'] = this.extra!.toJson();
    // }
    data['country_code'] = this.countryCode;
    data['created_at'] = this.createdAt;
    data['country_calling_code'] = this.countryCallingCode;
    return data;
  }
}

class Specialties {
  String? id;
  String? label;

  Specialties({this.id, this.label});

  Specialties.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    return data;
  }
}
