class ConfirmAppointmentResponseModel {
  String? message;
  bool? status;
  String? woocommerce_redirect;

  ConfirmAppointmentResponseModel({this.message, this.status, this.woocommerce_redirect});

  factory ConfirmAppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    return ConfirmAppointmentResponseModel(
      message: json['message'],
      status: json['status'],
      woocommerce_redirect: json['woocommerce_redirect'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['woocommerce_redirect'] = this.woocommerce_redirect;
    return data;
  }
}
