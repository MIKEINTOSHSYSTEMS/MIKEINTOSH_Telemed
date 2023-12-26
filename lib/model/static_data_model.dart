class StaticDataModel {
  List<StaticData?>? staticData;

  StaticDataModel({this.staticData});

  factory StaticDataModel.fromJson(Map<String, dynamic> json) {
    return StaticDataModel(
      staticData: json['data'] != null ? (json['data'] as List).map((i) => StaticData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.staticData != null) {
      data['data'] = this.staticData!.map((v) => v!.toJson()).toList();
    }
    return data;
  }
}

class StaticData {
  String? created_at;
  String? id;
  String? label;
  String? parent_id;
  String? status;
  String? type;
  String? value;
  bool isSelected;

  StaticData({this.created_at, this.id, this.label, this.parent_id, this.status, this.type, this.value, this.isSelected = false});

  factory StaticData.fromJson(Map<String, dynamic> json) {
    return StaticData(
      created_at: json['created_at'],
      id: json['id'],
      label: json['label'],
      parent_id: json['parent_id'],
      status: json['status'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['label'] = this.label;
    data['status'] = this.status;
    data['type'] = this.type;
    data['value'] = this.value;
    data['parent_id'] = this.parent_id;
    return data;
  }
}
