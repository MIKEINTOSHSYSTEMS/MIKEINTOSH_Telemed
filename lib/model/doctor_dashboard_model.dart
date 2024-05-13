import 'package:kivicare_flutter/model/upcoming_appointment_model.dart';

class DoctorDashboardModel {
  int? totalAppointment;
  int? totalPatient;
  int? totalService;
  List<UpcomingAppointmentModel>? upcomingAppointment;
  int? upcomingAppointmentTotal;
  List<WeeklyAppointment>? weeklyAppointment;

  DoctorDashboardModel({
    this.totalAppointment,
    this.totalService,
    this.totalPatient,
    this.upcomingAppointment,
    this.upcomingAppointmentTotal,
    this.weeklyAppointment,
  });

  factory DoctorDashboardModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardModel(
      totalAppointment: json['total_appointment'],
      totalPatient: json['total_patient'],
      totalService: json['total_service'],
      upcomingAppointment: json['upcoming_appointment'] != null ? (json['upcoming_appointment'] as List).map((i) => UpcomingAppointmentModel.fromJson(i)).toList() : null,
      upcomingAppointmentTotal: json['upcoming_appointment_total'],
      weeklyAppointment: json['weekly_appointment'] != null ? (json['weekly_appointment'] as List).map((i) => WeeklyAppointment.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_appointment'] = this.totalAppointment;
    data['total_patient'] = this.totalPatient;
    data['total_service'] = this.totalService;
    data['upcoming_appointment_total'] = this.upcomingAppointmentTotal;
    if (this.upcomingAppointment != null) {
      data['upcoming_appointment'] = this.upcomingAppointment!.map((v) => v.toJson()).toList();
    }
    if (this.weeklyAppointment != null) {
      data['weekly_appointment'] = this.weeklyAppointment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
