import 'package:kivicare_flutter/model/user_model.dart';

class PatientListModel {
  List<UserModel>? patientData;
  int? total;

  PatientListModel({this.patientData, this.total});

  factory PatientListModel.fromJson(Map<String, dynamic> json) {
    return PatientListModel(
      patientData: json['data'] != null ? (json['data'] as List).map((i) => UserModel.fromJson(i)).toList() : null,
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
