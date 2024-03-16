class EncounterType {
  String? addedBy;
  String? createdAt;
  String? encounterId;
  String? id;
  String? patientId;
  String? title;
  String? type;

  EncounterType({this.addedBy, this.createdAt, this.encounterId, this.id, this.patientId, this.title, this.type});

  factory EncounterType.fromJson(Map<String, dynamic> json) {
    return EncounterType(
      addedBy: json['added_by'],
      createdAt: json['created_at'],
      encounterId: json['encounter_id'],
      id: json['id'],
      patientId: json['patient_id'],
      title: json['title'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['encounter_id'] = this.encounterId;
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}
