class TelemedStatus {
  String? message;

  TelemedStatus({this.message});

  factory TelemedStatus.fromJson(Map<String, dynamic> json) {
    return TelemedStatus(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
