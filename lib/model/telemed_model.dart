class TelemedModel {
  TelemedData? telemedData;
  String? message;

  TelemedModel({this.telemedData, this.message});

  factory TelemedModel.fromJson(Map<String, dynamic> json) {
    return TelemedModel(
      telemedData: json['data'] != null ? TelemedData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.telemedData != null) {
      data['data'] = this.telemedData!.toJson();
    }
    return data;
  }
}

class TelemedData {
  String? api_key;
  String? api_secret;
  bool? enableTeleMed;
  String? zoom_id;

  TelemedData({this.api_key, this.api_secret, this.enableTeleMed, this.zoom_id});

  factory TelemedData.fromJson(Map<String, dynamic> json) {
    return TelemedData(
      api_key: json['api_key'],
      api_secret: json['api_secret'],
      enableTeleMed: json['enableTeleMed'],
      zoom_id: json['zoom_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_key'] = this.api_key;
    data['api_secret'] = this.api_secret;
    data['enableTeleMed'] = this.enableTeleMed;
    data['zoom_id'] = this.zoom_id;
    return data;
  }
}
