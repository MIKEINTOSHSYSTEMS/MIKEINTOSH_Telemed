import 'dart:io';

import 'package:kivicare_flutter/model/clinic_list_model.dart';
import 'package:kivicare_flutter/model/user_model.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceListModel {
  List<ServiceData>? serviceData;
  int? total;

  ServiceListModel({this.serviceData, this.total});

  factory ServiceListModel.fromJson(Map<String, dynamic> json) {
    return ServiceListModel(
      serviceData: json['data'] != null ? (json['data'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.serviceData != null) {
      data['data'] = this.serviceData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceData {
  String? charges;
  String? userId;
  String? doctorId;
  String? duration;
  String? id;
  String? image;
  String? mappingTableId;
  bool? multiple;
  String? name;
  String? serviceId;
  String? status;
  bool? isTelemed;
  String? displayName;
  String? profileImage;
  String? clinicName;
  String? clinicId;

  //Extra? extra;
  File? imageFile;

  List<UserModel>? doctorList;
  List<Clinic>? clinicList;

  String? type;
  String? label;
  bool isCheck;

  ServiceData({
    this.charges,
    this.doctorId,
    this.userId,
    this.doctorList,
    this.clinicName,
    this.clinicId,
    this.clinicList,
    this.isCheck = false,
    this.duration,
    this.id,
    this.image,
    this.mappingTableId,
    this.multiple,
    this.name,
    this.serviceId,
    this.status,
    this.type,
    this.label,
    this.isTelemed,
    this.displayName,
    this.profileImage,
    this.imageFile,
  });

  String get firstName => displayName.validate().split(' ').first;

  String get lastName => displayName.validate().split(' ').last;

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
        charges: json['charges'],
        doctorId: json['doctor_id'],
        userId: json['user_id'],
        duration: json['duration'],
        id: json['id'],
        profileImage: json['profile_Image'],
        image: json['image'],
        isTelemed: json['is_telemed'],
        mappingTableId: json['mapping_table_id'],
        multiple: json['is_multiple_selection'],
        name: json['name'],
        clinicName: json['clinic_name'],
        clinicId: json['clinic_id'],
        serviceId: json['service_id'],
        status: json['status'],
        type: json['type'],
        label: json['label'],
        displayName: json['display_name'],
        doctorList: json['doctors'] != null ? (json['doctors'] as List).map((doctorServiceData) => UserModel.fromJson(doctorServiceData)).toList() : null,
        clinicList: json['clinics'] != null ? (json['clinics'] as List).map((clinicData) => Clinic.fromJson(clinicData)).toList() : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['charges'] = this.charges;
    data['doctor_id'] = this.doctorId;
    data['user_id'] = this.userId;
    data['duration'] = this.duration;
    data['id'] = this.id;
    data['image'] = this.image;
    data['mapping_table_id'] = this.mappingTableId;
    data['is_multiple_selection'] = this.multiple;
    data['name'] = this.name;
    data['service_id'] = this.serviceId;
    data['status'] = this.status;
    data['is_telemed'] = this.isTelemed;
    data['profile_image'] = this.profileImage;
    data['type'] = this.type;
    data['label'] = this.label;
    data['display_name'] = this.displayName;
    data['clini_id'] = this.clinicId;
    data['clinic_name'] = this.clinicName;

    //data['extra'] = this.extra!.toJson();

    if (data['doctors'] != null) data['doctors'] = this.doctorList!.map((v) => v.toJson()).toList();
    if (data['clinics'] != null) data['clinic'] = this.clinicList!.map((v) => v.toJson()).toList();
    return data;
  }
}
