class AppointmentSlotModel {
  String? time;
  bool? available;
  bool isSelected = false;

  AppointmentSlotModel({this.time, this.available});

  AppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['available'] = this.available;
    return data;
  }
}
