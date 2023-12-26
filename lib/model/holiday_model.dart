class HolidayModel {
  List<HolidayData>? holidayData;
  String? total;

  HolidayModel({this.holidayData, this.total});

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      holidayData: json['data'] != null ? (json['data'] as List).map((i) => HolidayData.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.holidayData != null) {
      data['data'] = this.holidayData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HolidayData {
  String? created_at;
  String? description;
  String? end_date;
  String? id;
  String? module_id;
  String? module_type;
  String? start_date;
  String? status;

  HolidayData({this.created_at, this.description, this.end_date, this.id, this.module_id, this.module_type, this.start_date, this.status});

  factory HolidayData.fromJson(Map<String, dynamic> json) {
    return HolidayData(
      created_at: json['created_at'],
      description: json['description'],
      end_date: json['end_date'],
      id: json['id'],
      module_id: json['module_id'],
      module_type: json['module_type'],
      start_date: json['start_date'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['end_date'] = this.end_date;
    data['id'] = this.id;
    data['module_id'] = this.module_id;
    data['module_type'] = this.module_type;
    data['start_date'] = this.start_date;
    data['status'] = this.status;
    return data;
  }
}
