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
  String? addedBy;
  String? createdAt;
  String? duration;
  String? encounterId;
  String? frequency;
  String? id;
  String? instruction;
  String? name;
  String? patientId;

  PrescriptionData({this.addedBy, this.createdAt, this.duration, this.encounterId, this.frequency, this.id, this.instruction, this.name, this.patientId});

  factory PrescriptionData.fromJson(Map<String, dynamic> json) {
    return PrescriptionData(
      addedBy: json['added_by'],
      createdAt: json['created_at'],
      duration: json['duration'],
      encounterId: json['encounter_id'],
      frequency: json['frequency'],
      id: json['id'],
      instruction: json['instruction'],
      name: json['name'],
      patientId: json['patient_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['duration'] = this.duration;
    data['encounter_id'] = this.encounterId;
    data['frequency'] = this.frequency;
    data['id'] = this.id;
    data['instruction'] = this.instruction;
    data['name'] = this.name;
    data['patient_id'] = this.patientId;
    return data;
  }
}
