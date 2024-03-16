import 'package:nb_utils/nb_utils.dart';

class HolidayModel {
  List<HolidayData>? holidayData;
  num? total;

  HolidayModel({this.holidayData, this.total});

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      holidayData: json['data'] != null ? (json['data'] as List).map((i) => HolidayData.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.holidayData != null) {
      data['data'] = this.holidayData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HolidayData {
  String? createdAt;
  String? description;
  String? endDate;
  String? id;
  String? moduleId;
  String? moduleType;
  String? clinicImage;
  String? clinicName;
  String? doctorName;
  String? doctorProfileImage;

  String? startDate;
  String? holidayEndDate;
  String? holidayStartDate;
  String? status;

  String get userName => moduleType == "doctor" ? doctorName.validate() : clinicName.validate();

  String get userProfileImage => moduleType == "doctor" ? doctorProfileImage.validate() : clinicImage.validate();

  HolidayData(
      {this.createdAt,
      this.description,
      this.endDate,
      this.id,
      this.moduleId,
      this.moduleType,
      this.startDate,
      this.status,
      this.clinicImage,
      this.clinicName,
      this.doctorName,
      this.doctorProfileImage,
      this.holidayEndDate,
      this.holidayStartDate});

  factory HolidayData.fromJson(Map<String, dynamic> json) {
    return HolidayData(
      createdAt: json['created_at'],
      description: json['description'],
      endDate: json['end_date'],
      holidayEndDate: json['holidat_end_date'],
      holidayStartDate: json['holiday_start_date'],
      id: json['ID'],
      moduleId: json['module_id'],
      moduleType: json['module_type'],
      startDate: json['start_date'],
      status: json['status'],
      clinicImage: json['clinic_image'],
      clinicName: json['clinic_name'],
      doctorName: json['doctor_name'],
      doctorProfileImage: json['doctor_profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['end_date'] = this.endDate;
    data['ID'] = this.id;
    data['module_id'] = this.moduleId;
    data['module_type'] = this.moduleType;
    data['start_date'] = this.startDate;
    data['clinic_image'] = this.clinicImage;
    data['clinic_name'] = this.clinicName;
    data['doctor_name'] = this.doctorName;
    data['doctor_profile_image'] = this.doctorProfileImage;
    data['status'] = this.status;
    data['holidat_end_date'] = holidayEndDate;
    data['holiday_start_date'] = holidayStartDate;
    return data;
  }
}
