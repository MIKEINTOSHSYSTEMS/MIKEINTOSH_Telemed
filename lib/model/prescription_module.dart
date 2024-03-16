class PrescriptionModule {
  String? label;
  String? name;
  String? status;

  PrescriptionModule({this.label, this.name, this.status});

  factory PrescriptionModule.fromJson(Map<String, dynamic> json) {
    return PrescriptionModule(
      label: json['label'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
