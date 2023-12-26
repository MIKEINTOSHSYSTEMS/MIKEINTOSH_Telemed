class UserConfiguration {
  String? google_client_id;
  bool? isKiviCareGooglemeetActive;
  bool? isKiviCareProOnName;
  bool? isTeleMedActive;
  String? is_enable_doctor_gcal;
  String? is_enable_google_cal;
  String? is_patient_enable;
  String? telemed_type;
  String? is_uploadfile_appointment;
  String? message;
  RestrictAppointment? restrict_appointment;
  String? role;
  bool? status;
  int? user_id;

  UserConfiguration(
      {this.google_client_id,
      this.isKiviCareGooglemeetActive,
      this.isKiviCareProOnName,
      this.isTeleMedActive,
      this.is_enable_doctor_gcal,
      this.telemed_type,
      this.is_enable_google_cal,
      this.is_patient_enable,
      this.is_uploadfile_appointment,
      this.message,
      this.restrict_appointment,
      this.role,
      this.status,
      this.user_id});

  factory UserConfiguration.fromJson(Map<String, dynamic> json) {
    return UserConfiguration(
      google_client_id: json['google_client_id'],
      isKiviCareGooglemeetActive: json['isKiviCareGooglemeetActive'],
      isKiviCareProOnName: json['isKiviCareProOnName'],
      isTeleMedActive: json['isTeleMedActive'],
      is_enable_doctor_gcal: json['is_enable_doctor_gcal'],
      is_enable_google_cal: json['is_enable_google_cal'],
      is_patient_enable: json['is_patient_enable'],
      telemed_type: json['telemed_type'],
      is_uploadfile_appointment: json['is_uploadfile_appointment'],
      message: json['message'],
      restrict_appointment: json['restrict_appointment'] != null ? RestrictAppointment.fromJson(json['restrict_appointment']) : null,
      role: json['role'],
      status: json['status'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['google_client_id'] = this.google_client_id;
    data['isKiviCareGooglemeetActive'] = this.isKiviCareGooglemeetActive;
    data['isKiviCareProOnName'] = this.isKiviCareProOnName;
    data['isTeleMedActive'] = this.isTeleMedActive;
    data['is_enable_doctor_gcal'] = this.is_enable_doctor_gcal;
    data['is_enable_google_cal'] = this.is_enable_google_cal;
    data['is_patient_enable'] = this.is_patient_enable;
    data['is_uploadfile_appointment'] = this.is_uploadfile_appointment;
    data['message'] = this.message;
    data['telemed_type'] = this.telemed_type;
    data['role'] = this.role;
    data['status'] = this.status;
    data['user_id'] = this.user_id;
    if (this.restrict_appointment != null) {
      data['restrict_appointment'] = this.restrict_appointment!.toJson();
    }
    return data;
  }
}

class RestrictAppointment {
  String? post;
  String? pre;

  RestrictAppointment({this.post, this.pre});

  factory RestrictAppointment.fromJson(Map<String, dynamic> json) {
    return RestrictAppointment(
      post: json['post'],
      pre: json['pre'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post'] = this.post;
    data['pre'] = this.pre;
    return data;
  }
}
