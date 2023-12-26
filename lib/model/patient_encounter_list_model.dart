class PatientEncounterListModel {
  List<PatientEncounterData>? patientEncounterData;
  String? total;

  PatientEncounterListModel({this.patientEncounterData, this.total});

  factory PatientEncounterListModel.fromJson(Map<String, dynamic> json) {
    return PatientEncounterListModel(
      patientEncounterData: json['data'] != null ? (json['data'] as List).map((i) => PatientEncounterData.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.patientEncounterData != null) {
      data['data'] = this.patientEncounterData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PatientEncounterData {
  String? added_by;
  String? appointment_id;
  String? clinic_id;
  String? clinic_name;
  String? created_at;
  String? description;
  String? doctor_id;
  String? doctor_name;
  String? encounter_date;
  String? id;
  String? patient_id;
  String? patient_name;
  String? status;

  PatientEncounterData({this.added_by, this.appointment_id, this.clinic_id, this.clinic_name, this.created_at, this.description, this.doctor_id, this.doctor_name, this.encounter_date, this.id, this.patient_id, this.patient_name, this.status});

  factory PatientEncounterData.fromJson(Map<String, dynamic> json) {
    return PatientEncounterData(
      added_by: json['added_by'],
      appointment_id: json['appointment_id'],
      clinic_id: json['clinic_id'],
      clinic_name: json['clinic_name'],
      created_at: json['created_at'],
      description: json['description'],
      doctor_id: json['doctor_id'],
      doctor_name: json['doctor_name'],
      encounter_date: json['encounter_date'],
      id: json['id'],
      patient_id: json['patient_id'],
      patient_name: json['patient_name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.added_by;
    data['appointment_id'] = this.appointment_id;
    data['clinic_id'] = this.clinic_id;
    data['clinic_name'] = this.clinic_name;
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['doctor_id'] = this.doctor_id;
    data['doctor_name'] = this.doctor_name;
    data['encounter_date'] = this.encounter_date;
    data['id'] = this.id;
    data['patient_id'] = this.patient_id;
    data['patient_name'] = this.patient_name;
    data['status'] = this.status;
    return data;
  }
}
