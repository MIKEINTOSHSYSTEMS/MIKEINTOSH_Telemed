import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/model/upcoming_appointment_model.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/screens/patient/models/news_model.dart';

class PatientDashboardModel {
  List<UserModel>? doctor;
  List<NewsData>? news;
  List<ServiceData>? serviceList;
  int? totalAppointment;
  List<UpcomingAppointmentModel>? upcomingAppointment;
  int? upcomingAppointmentTotal;

  PatientDashboardModel({
    this.doctor,
    this.news,
    this.serviceList,
    this.totalAppointment,
    this.upcomingAppointment,
    this.upcomingAppointmentTotal,
  });

  factory PatientDashboardModel.fromJson(Map<String, dynamic> json) {
    return PatientDashboardModel(
      doctor: json['doctor'] != null ? (json['doctor'] as List).map((i) => UserModel.fromJson(i)).toList() : null,
      news: json['news'] != null ? (json['news'] as List).map((i) => NewsData.fromJson(i)).toList() : null,
      serviceList: json['service'] != null ? (json['service'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
      totalAppointment: json['total_appointment'],
      upcomingAppointment: json['upcoming_appointment'] != null ? (json['upcoming_appointment'] as List).map((i) => UpcomingAppointmentModel.fromJson(i)).toList() : null,
      upcomingAppointmentTotal: json['upcoming_appointment_total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_appointment'] = this.totalAppointment;
    data['upcoming_appointment_total'] = this.upcomingAppointmentTotal;
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.map((v) => v.toJson()).toList();
    }
    if (this.news != null) {
      data['news'] = this.news!.map((v) => v.toJson()).toList();
    }
    if (this.serviceList != null) {
      data['service'] = this.serviceList!.map((v) => v.toJson()).toList();
    }
    if (this.upcomingAppointment != null) {
      data['upcoming_appointment'] = this.upcomingAppointment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
