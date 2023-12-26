class MedicalHistoryModel {
  List<EncounterType>? encounterType;
  int? total;

  MedicalHistoryModel({this.encounterType, this.total});

  factory MedicalHistoryModel.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryModel(
      encounterType: json['data'] != null ? (json['data'] as List).map((i) => EncounterType.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.encounterType != null) {
      data['data'] = this.encounterType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EncounterType {
  String? added_by;
  String? created_at;
  String? encounter_id;
  String? id;
  String? patient_id;
  String? title;
  String? type;

  EncounterType({this.added_by, this.created_at, this.encounter_id, this.id, this.patient_id, this.title, this.type});

  factory EncounterType.fromJson(Map<String, dynamic> json) {
    return EncounterType(
      added_by: json['added_by'],
      created_at: json['created_at'],
      encounter_id: json['encounter_id'],
      id: json['id'],
      patient_id: json['patient_id'],
      title: json['title'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.added_by;
    data['created_at'] = this.created_at;
    data['encounter_id'] = this.encounter_id;
    data['id'] = this.id;
    data['patient_id'] = this.patient_id;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}
