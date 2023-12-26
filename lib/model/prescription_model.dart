class PrescriptionModel {
  List<PrescriptionData>? prescriptionData;
  int? total;

  PrescriptionModel({this.prescriptionData, this.total});

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      prescriptionData: json['data'] != null ? (json['data'] as List).map((i) => PrescriptionData.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.prescriptionData != null) {
      data['data'] = this.prescriptionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrescriptionData {
  String? added_by;
  String? created_at;
  String? duration;
  String? encounter_id;
  String? frequency;
  String? id;
  String? instruction;
  String? name;
  String? patient_id;

  PrescriptionData({this.added_by, this.created_at, this.duration, this.encounter_id, this.frequency, this.id, this.instruction, this.name, this.patient_id});

  factory PrescriptionData.fromJson(Map<String, dynamic> json) {
    return PrescriptionData(
      added_by: json['added_by'],
      created_at: json['created_at'],
      duration: json['duration'],
      encounter_id: json['encounter_id'],
      frequency: json['frequency'],
      id: json['id'],
      instruction: json['instruction'],
      name: json['name'],
      patient_id: json['patient_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.added_by;
    data['created_at'] = this.created_at;
    data['duration'] = this.duration;
    data['encounter_id'] = this.encounter_id;
    data['frequency'] = this.frequency;
    data['id'] = this.id;
    data['instruction'] = this.instruction;
    data['name'] = this.name;
    data['patient_id'] = this.patient_id;
    return data;
  }
}
