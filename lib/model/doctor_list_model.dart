import 'package:momona_healthcare/model/rating_model.dart';
import 'package:momona_healthcare/model/user_model.dart';

class DoctorListModel {
  List<UserModel>? doctorList;
  int? total;

  DoctorListModel({this.doctorList, this.total});

  factory DoctorListModel.fromJson(Map<String, dynamic> json) {
    return DoctorListModel(
      doctorList: json['data'] != null ? (json['data'] as List).map((i) => UserModel.fromJson(i)).toList() : null,
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

class DoctorData {
  String? available;
  List<String>? clinicId;
  String? clinicName;
  String? displayName;
  String? gender;
  int? iD;
  String? mobileNumber;
  String? noOfExperience;
  String? profileImage;
  String? specialties;
  num? avgRating;
  String? userEmail;
  String? userStatus;
  bool isCheck;
  List<RatingData>? ratingList;

  DoctorData({
    this.available,
    this.clinicId,
    this.clinicName,
    this.displayName,
    this.avgRating,
    this.gender,
    this.ratingList,
    this.iD,
    this.mobileNumber,
    this.noOfExperience,
    this.profileImage,
    this.specialties,
    this.userEmail,
    this.userStatus,
    this.isCheck = false,
  });

  factory DoctorData.fromJson(Map<String, dynamic> json) {
    return DoctorData(
      available: json['available'],
      avgRating: json['avgRating'],
      clinicId: json['clinic_id'] != null ? new List<String>.from(json['clinic_id']) : null,
      clinicName: json['clinic_name'],
      displayName: json['display_name'],
      gender: json['gender'],
      iD: json['ID'],
      ratingList: json['reviews'] != null ? (json['reviews'] as List).map((i) => RatingData.fromJson(i)).toList() : null,
      mobileNumber: json['mobile_number'],
      noOfExperience: json['no_of_experience'].toString(),
      profileImage: json['profile_image'],
      specialties: json['specialties'],
      userEmail: json['user_email'],
      userStatus: json['user_status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available'] = this.available;
    data['clinic_name'] = this.clinicName;
    data['display_name'] = this.displayName;
    data['gender'] = this.gender;
    data['ID'] = this.iD;
    data['mobile_number'] = this.mobileNumber;
    data['no_of_experience'] = this.noOfExperience;
    // data['profile_image'] = this.profile_image;
    data['specialties'] = this.specialties;
    data['user_email'] = this.userEmail;
    data['avgRating'] = this.avgRating;
    data['user_status'] = this.userStatus;
    if (this.clinicId != null) {
      data['clinic_id'] = this.clinicId;
    }
    if (this.ratingList != null) {
      data['reviews'] = this.ratingList;
    }
    return data;
  }
}
