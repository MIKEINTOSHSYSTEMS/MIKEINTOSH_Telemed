class ModuleConfig {
  String? label;
  String? name;
  String? status;

  ModuleConfig({this.label, this.name, this.status});

  factory ModuleConfig.fromJson(Map<String, dynamic> json) {
    return ModuleConfig(
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
