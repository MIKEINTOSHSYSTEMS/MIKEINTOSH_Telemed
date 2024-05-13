import 'package:kivicare_flutter/model/upcoming_appointment_model.dart';

class AppointmentModel {
  List<UpcomingAppointmentModel>? appointmentData;
  int? total;

  AppointmentModel({this.appointmentData, this.total});

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentData: json['data'] != null ? (json['data'] as List).map((i) => UpcomingAppointmentModel.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.appointmentData != null) {
      data['data'] = this.appointmentData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
