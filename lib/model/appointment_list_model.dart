import 'package:momona_healthcare/model/upcoming_appointment_model.dart';

class AppointmentListModel {
  List<UpcomingAppointmentModel>? upcomingAppointment;
  int? total;

  AppointmentListModel({this.upcomingAppointment, this.total});

  factory AppointmentListModel.fromJson(Map<String, dynamic> json) {
    return AppointmentListModel(
      upcomingAppointment: json['data'] != null ? (json['data'] as List).map((i) => UpcomingAppointmentModel.fromJson(i)).toList() : null,
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
