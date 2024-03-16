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
  String? createdAt;
  String? id;
  String? label;
  String? parentId;
  String? status;
  String? type;
  String? value;
  bool isSelected;

  StaticData({
    this.createdAt,
    this.id,
    this.label,
    this.parentId,
    this.status,
    this.type,
    this.value,
    this.isSelected = false,
  });

  factory StaticData.fromJson(Map<String, dynamic> json) {
    return StaticData(
      createdAt: json['created_at'],
      id: json['id'],
      label: json['label'],
      parentId: json['parent_id'],
      status: json['status'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['label'] = this.label;
    data['status'] = this.status;
    data['type'] = this.type;
    data['value'] = this.value;
    data['parent_id'] = this.parentId;
    return data;
  }
}
