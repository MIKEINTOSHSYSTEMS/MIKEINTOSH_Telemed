import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientListModel {
  List<PatientData>? patientData;
  int? total;

  PatientListModel({this.patientData, this.total});

  factory PatientListModel.fromJson(Map<String, dynamic> json) {
    return PatientListModel(
      patientData: json['data'] != null ? (json['data'] as List).map((i) => PatientData.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.patientData != null) {
      data['data'] = this.patientData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PatientData {
  String? blood_group;
  String? display_name;
  int? iD;
  String? mobile_number;
  String? patient_added_by;
  String? total_encounter;
  String? user_email;
  String? user_registered;
  String? profile_image;
  String? gender;
  String? user_status;

  String get profileImage => profile_image != null
      ? profile_image.validate()
      : gender.validate().toLowerCase() == "male"
          ? ic_patient3
          : ic_patient6;

  PatientData({
    this.blood_group,
    this.display_name,
    this.iD,
    this.mobile_number,
    this.patient_added_by,
    this.total_encounter,
    this.user_email,
    this.user_registered,
    this.user_status,
    this.profile_image,
    this.gender,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      blood_group: json['blood_group'],
      display_name: json['display_name'],
      iD: json['ID'],
      mobile_number: json['mobile_number'],
      patient_added_by: json['patient_added_by'],
      total_encounter: json['total_encounter'],
      user_email: json['user_email'],
      user_registered: json['user_registered'],
      user_status: json['user_status'],
      profile_image: json['profile_image'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blood_group'] = this.blood_group;
    data['display_name'] = this.display_name;
    data['ID'] = this.iD;
    data['mobile_number'] = this.mobile_number;
    data['patient_added_by'] = this.patient_added_by;
    data['total_encounter'] = this.total_encounter;
    data['user_email'] = this.user_email;
    data['user_registered'] = this.user_registered;
    data['user_status'] = this.user_status;
    data['profile_image'] = this.profile_image;
    data['gender'] = this.gender;
    return data;
  }
}
