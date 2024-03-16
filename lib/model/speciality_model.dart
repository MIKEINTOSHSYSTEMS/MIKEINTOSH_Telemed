class SpecialtyModel {
  dynamic id;
  String? label;
  String? createdAt;
  String? type;
  String? value;
  String? parentId;

  SpecialtyModel({this.id, this.label, this.createdAt, this.type, this.value, this.parentId});

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id'],
      label: json['label'],
      createdAt: json['created_at'],
      type: json['type'],
      value: json['value'],
      parentId: json['parent_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['created_id'] = this.createdAt;
    data['type'] = this.type;
    data['value'] = this.value;
    data['parent_id'] = this.parentId;
    return data;
  }
}
