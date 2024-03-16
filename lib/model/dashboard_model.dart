import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/model/upcoming_appointment_model.dart';
import 'package:momona_healthcare/model/user_model.dart';

import '../screens/patient/models/news_model.dart';

class DashboardModel {
  int? totalAppointment;
  int? totalPatient;
  int? totalService;

  int? totalDoctor;
  int? upcomingAppointmentTotal;
  List<UpcomingAppointmentModel>? upcomingAppointment;
  List<UserModel>? doctor;
  List<WeeklyAppointment>? weeklyAppointment;
  String? currencyPrefix;
  String? currencyPostfix;

  //Patient Dashboard Model

  List<NewsData>? news;
  List<ServiceData>? serviceList;

  DashboardModel(
      {this.totalAppointment,
      this.totalService,
      this.totalDoctor,
      this.totalPatient,
      this.upcomingAppointment,
      this.upcomingAppointmentTotal,
      this.weeklyAppointment,
      this.doctor,
      this.news,
      this.serviceList,
      this.currencyPostfix,
      this.currencyPrefix});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      doctor: json['doctor'] != null ? (json['doctor'] as List).map((i) => UserModel.fromJson(i)).toList() : null,
      news: json['news'] != null ? (json['news'] as List).map((i) => NewsData.fromJson(i)).toList() : null,
      serviceList: json['service'] != null ? (json['service'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
      totalAppointment: json['total_appointment'],
      upcomingAppointment: json['upcoming_appointment'] != null ? (json['upcoming_appointment'] as List).map((i) => UpcomingAppointmentModel.fromJson(i)).toList() : null,
      upcomingAppointmentTotal: json['upcoming_appointment_total'],
      totalPatient: json['total_patient'],
      totalDoctor: json['total_doctor'],
      totalService: json['total_service'],
      currencyPrefix: json['currency_prefix'],
      currencyPostfix: json['currency_postfix'],
      weeklyAppointment: json['weekly_appointment'] != null ? (json['weekly_appointment'] as List).map((i) => WeeklyAppointment.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['total_appointment'] = this.totalAppointment;
    data['total_patient'] = this.totalPatient;
    data['total_doctor'] = this.totalDoctor;
    data['total_service'] = this.totalService;
    data['upcoming_appointment_total'] = this.upcomingAppointmentTotal;
    data['currency_prefix'] = this.currencyPrefix;
    data['currency_postfix'] = this.currencyPostfix;
    if (this.upcomingAppointment != null) {
      data['upcoming_appointment'] = this.upcomingAppointment!.map((v) => v.toJson()).toList();
    }
    if (this.weeklyAppointment != null) {
      data['weekly_appointment'] = this.weeklyAppointment!.map((v) => v.toJson()).toList();
    }

    if (this.doctor != null) {
      data['doctor'] = this.doctor!.map((v) => v.toJson()).toList();
    }
    if (this.news != null) {
      data['news'] = this.news!.map((v) => v.toJson()).toList();
    }
    if (this.serviceList != null) {
      data['service'] = this.serviceList!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
