import 'package:momona_healthcare/model/encounter_dashboard_model.dart';
import 'package:momona_healthcare/model/login_response_model.dart';
import 'package:momona_healthcare/model/medical_history_model.dart';
import 'package:momona_healthcare/model/prescription_model.dart';

class PatientEncounterDashboardModel {
  String? added_by;
  String? appointment_id;
  String? bill_id;
  String? clinic_id;
  String? clinic_name;
  String? created_at;
  List<CustomField>? custom_fields;
  List<EncounterType>? problem;
  List<EncounterType>? observation;
  List<EncounterType>? note;
  List<ModuleConfig>? module_config;
  List<PrescriptionModule>? prescription_module;
  List<EnocunterModule>? enocunter_modules;

  String? description;
  String? doctor_id;
  String? doctor_name;
  String? encounter_date;
  String? id;
  bool? is_billing;
  String? patient_email;
  String? patient_id;
  String? patient_name;
  String? payment_status;
  Prescription? prescription;
  String? status;

  PatientEncounterDashboardModel({
    this.added_by,
    this.appointment_id,
    this.bill_id,
    this.clinic_id,
    this.clinic_name,
    this.created_at,
    this.custom_fields,
    this.description,
    this.doctor_id,
    this.doctor_name,
    this.encounter_date,
    this.id,
    this.is_billing,
    this.note,
    this.observation,
    this.patient_email,
    this.patient_id,
    this.patient_name,
    this.payment_status,
    this.prescription,
    this.problem,
    this.status,
    this.module_config,
    this.prescription_module,
    this.enocunter_modules,
  });

  factory PatientEncounterDashboardModel.fromJson(Map<String, dynamic> json) {
    return PatientEncounterDashboardModel(
      added_by: json['added_by'],
      appointment_id: json['appointment_id'],
      bill_id: json['bill_id'],
      clinic_id: json['clinic_id'],
      clinic_name: json['clinic_name'],
      created_at: json['created_at'],
      custom_fields: json['custom_fields'] != null ? (json['custom_fields'] as List).map((i) => CustomField.fromJson(i)).toList() : null,
      description: json['description'],
      doctor_id: json['doctor_id'],
      enocunter_modules: json['enocunter_modules'] != null ? (json['enocunter_modules'] as List).map((i) => EnocunterModule.fromJson(i)).toList() : null,
      doctor_name: json['doctor_name'],
      module_config: json['module_config'] != null ? (json['module_config'] as List).map((i) => ModuleConfig.fromJson(i)).toList() : null,
      prescription_module: json['prescription_module'] != null ? (json['prescription_module'] as List).map((i) => PrescriptionModule.fromJson(i)).toList() : null,
      encounter_date: json['encounter_date'],
      id: json['id'],
      is_billing: json['is_billing'],
      note: json['note'] != null ? (json['note'] as List).map((i) => EncounterType.fromJson(i)).toList() : null,
      observation: json['observation'] != null ? (json['observation'] as List).map((i) => EncounterType.fromJson(i)).toList() : null,
      patient_email: json['patient_email'],
      patient_id: json['patient_id'],
      patient_name: json['patient_name'],
      payment_status: json['payment_status'],
      prescription: json['prescription'] != null ? Prescription.fromJson(json['prescription']) : null,
      problem: json['problem'] != null ? (json['problem'] as List).map((i) => EncounterType.fromJson(i)).toList() : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.added_by;
    data['appointment_id'] = this.appointment_id;
    data['bill_id'] = this.bill_id;
    data['clinic_id'] = this.clinic_id;
    data['clinic_name'] = this.clinic_name;
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['doctor_id'] = this.doctor_id;
    data['doctor_name'] = this.doctor_name;
    data['encounter_date'] = this.encounter_date;
    data['id'] = this.id;
    data['is_billing'] = this.is_billing;
    data['patient_email'] = this.patient_email;
    data['patient_id'] = this.patient_id;
    data['patient_name'] = this.patient_name;
    data['status'] = this.status;
    data['payment_status'] = this.payment_status;
    if (this.custom_fields != null) {
      data['custom_fields'] = this.custom_fields!.map((v) => v.toJson()).toList();
    }
    if (this.note != null) {
      data['note'] = this.note!.map((v) => v.toJson()).toList();
    }
    if (this.observation != null) {
      data['observation'] = this.observation!.map((v) => v.toJson()).toList();
    }
    if (this.problem != null) {
      data['problem'] = this.problem!.map((v) => v.toJson()).toList();
    }
    if (this.enocunter_modules != null) {
      data['enocunter_modules'] = this.enocunter_modules!.map((v) => v.toJson()).toList();
    }
    if (this.module_config != null) {
      data['module_config'] = this.module_config!.map((v) => v.toJson()).toList();
    }
    if (this.prescription_module != null) {
      data['prescription_module'] = this.prescription_module!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Prescription {
  List<PrescriptionData>? prescriptionData;
  int? total;

  Prescription({this.prescriptionData, this.total});

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
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
