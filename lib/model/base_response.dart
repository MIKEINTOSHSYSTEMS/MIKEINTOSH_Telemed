import 'package:momona_healthcare/model/user_model.dart';

class BaseResponses {
  String? message;
  String? code;
  bool? status;
  UserModel? userData;

  BaseResponses({this.message, this.code, this.status, this.userData});

  factory BaseResponses.fromJson(Map<String, dynamic> json) {
    return BaseResponses(
      message: json['message'],
      code: json['code'],
      status: json['status'],
      userData: json['data'] != null ? UserModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    data['status'] = this.status;
    return data;
  }
}

class ApiResponses {
  String? message;
  String? code;
  bool? status;

  ApiResponses({
    this.message,
    this.code,
    this.status,
  });

  factory ApiResponses.fromJson(Map<String, dynamic> json) {
    return ApiResponses(
      message: json['message'],
      code: json['code'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    data['status'] = this.status;
    return data;
  }
}
