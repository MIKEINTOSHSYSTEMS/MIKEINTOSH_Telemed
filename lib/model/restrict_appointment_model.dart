// ignore_for_file: unused_import

import 'package:nb_utils/nb_utils.dart';

class RestrictAppointmentModel {
  int? post;
  int? pre;

  RestrictAppointmentModel({this.post, this.pre});

  factory RestrictAppointmentModel.fromJson(Map<String, dynamic> json) {
    return RestrictAppointmentModel(
      post: json['post'].runtimeType == String ? (json['post'] as String).toInt() : json['post'],
      pre: json['pre'].runtimeType == String ? (json['pre'] as String).toInt() : json['pre'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post'] = this.post;
    data['pre'] = this.pre;
    return data;
  }
}
