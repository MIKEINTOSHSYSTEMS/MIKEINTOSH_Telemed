import 'package:kivicare_flutter/model/doctor_dashboard_model.dart';

class PatientEncounterModel {
  List<UpcomingAppointment>? upcomingAppointmentData;
  int? total;

  PatientEncounterModel({this.upcomingAppointmentData, this.total});

  factory PatientEncounterModel.fromJson(Map<String, dynamic> json) {
    return PatientEncounterModel(
      upcomingAppointmentData: json['data'] != null ? (json['data'] as List).map((i) => UpcomingAppointment.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.upcomingAppointmentData != null) {
      data['data'] = this.upcomingAppointmentData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
