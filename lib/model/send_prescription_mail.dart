class SendPrescriptionMail {
  String? message;

  SendPrescriptionMail({this.message});

  factory SendPrescriptionMail.fromJson(Map<String, dynamic> json) {
    return SendPrescriptionMail(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
