import 'package:kivicare_flutter/model/doctor_dashboard_model.dart';

class AppointmentListModel {
  List<UpcomingAppointment>? upcomingAppointment;
  int? total;

  AppointmentListModel({this.upcomingAppointment, this.total});

  factory AppointmentListModel.fromJson(Map<String, dynamic> json) {
    return AppointmentListModel(
      upcomingAppointment: json['data'] != null ? (json['data'] as List).map((i) => UpcomingAppointment.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.upcomingAppointment != null) {
      data['data'] = this.upcomingAppointment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
