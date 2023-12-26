class ServiceListModel {
  List<ServiceData>? serviceData;
  int? total;

  ServiceListModel({this.serviceData, this.total});

  factory ServiceListModel.fromJson(Map<String, dynamic> json) {
    return ServiceListModel(
      serviceData: json['data'] != null ? (json['data'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.serviceData != null) {
      data['data'] = this.serviceData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceData {
  String? charges;
  String? doctor_id;
  String? id;
  String? name;
  String? service_id;
  String? status;
  String? type;
  String? mapping_table_id;
  bool isCheck;

  ServiceData({this.charges, this.doctor_id, this.id, this.name, this.service_id, this.status, this.type, this.mapping_table_id, this.isCheck = false});

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      charges: json['charges'],
      doctor_id: json['doctor_id'],
      id: json['id'],
      name: json['name'],
      service_id: json['service_id'],
      status: json['status'],
      type: json['type'],
      mapping_table_id: json['mapping_table_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['charges'] = this.charges;
    data['doctor_id'] = this.doctor_id;
    data['id'] = this.id;
    data['name'] = this.name;
    data['service_id'] = this.service_id;
    data['status'] = this.status;
    data['type'] = this.type;
    data['mapping_table_id'] = this.mapping_table_id;
    return data;
  }
}
