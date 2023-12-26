import 'package:kivicare_flutter/model/login_response_model.dart';

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
