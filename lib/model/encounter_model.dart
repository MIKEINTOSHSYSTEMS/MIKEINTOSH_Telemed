import 'package:momona_healthcare/model/prescription_model.dart';
import 'package:momona_healthcare/model/prescription_module.dart';
import 'package:momona_healthcare/model/report_model.dart';
import 'package:momona_healthcare/model/upcoming_appointment_model.dart';

import 'encounter_module.dart';
import 'encounter_type_model.dart';
import 'module_config_model.dart';

class EncounterModel {
  String? addedBy;
  String? appointmentId;
  String? clinicId;
  String? clinicName;
  String? createdAt;
  String? encounterDateGlobal;
  List<CustomField>? customFields;
  String? description;
  String? doctorId;
  String? doctorName;
  String? encounterDate;
  String? encounterId;
  String? patientEmail;
  String? patientId;
  String? patientName;
  String? status;
  String? billId;
  bool? isBilling;
  String? paymentStatus;
  String? discount;
  List<ModuleConfig>? moduleConfig;
  List<PrescriptionModule>? prescriptionModule;
  List<EncounterModule>? encounterModules;

  List<PrescriptionData>? prescription;
  List<ReportData>? reportData;

  List<EncounterType>? problem;
  List<EncounterType>? observation;
  List<EncounterType>? note;

  List<UpcomingAppointmentModel>? upcomingAppointmentData;
  int? total;

  EncounterModel(
      {this.addedBy,
      this.appointmentId,
      this.clinicId,
      this.clinicName,
      this.createdAt,
      this.customFields,
      this.description,
      this.doctorId,
      this.doctorName,
      this.encounterDate,
      this.encounterId,
      this.patientEmail,
      this.patientId,
      this.patientName,
      this.status,
      this.encounterDateGlobal,
      this.billId,
      this.isBilling,
      this.paymentStatus,
      this.moduleConfig,
      this.prescriptionModule,
      this.encounterModules,
      this.prescription,
      this.reportData,
      this.discount,

      //New
      this.problem,
      this.observation,
      this.note,
      this.upcomingAppointmentData,
      this.total});

  factory EncounterModel.fromJson(Map<String, dynamic> json) {
    return EncounterModel(
      addedBy: json['added_by'],
      appointmentId: json['appointment_id'],
      clinicId: json['clinic_id'],
      clinicName: json['clinic_name'],
      encounterDateGlobal: json['encounter_date_global'],
      createdAt: json['created_at'],
      description: json['description'],
      doctorId: json['doctor_id'],
      doctorName: json['doctor_name'],
      encounterModules: json['enocunter_modules'] != null ? (json['enocunter_modules'] as List).map((i) => EncounterModule.fromJson(i)).toList() : null,
      moduleConfig: json['module_config'] != null ? (json['module_config'] as List).map((i) => ModuleConfig.fromJson(i)).toList() : null,
      prescriptionModule: json['prescription_module'] != null ? (json['prescription_module'] as List).map((i) => PrescriptionModule.fromJson(i)).toList() : null,
      encounterDate: json['encounter_date'],
      encounterId: json['id'],
      patientEmail: json['patient_email'],
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      status: json['status'],
      billId: json['bill_id'],
      discount: json['discount'],
      isBilling: json['is_billing'],
      prescription: json['prescription'] != null ? (json['prescription'] as List).map((presriptionData) => PrescriptionData.fromJson(presriptionData)).toList() : null,
      paymentStatus: json['payment_status'],
      reportData: json['report'] != null ? (json['report'] as List).map((reportData) => ReportData.fromJson(reportData)).toList() : null,

      // New
      problem: json['problem'] != null ? (json['problem'] as List).map((i) => EncounterType.fromJson(i)).toList() : null,
      observation: json['observation'] != null ? (json['observation'] as List).map((i) => EncounterType.fromJson(i)).toList() : null,
      note: json['note'] != null ? (json['note'] as List).map((i) => EncounterType.fromJson(i)).toList() : null,

      //New
      upcomingAppointmentData: json['data'] != null ? (json['data'] as List).map((i) => UpcomingAppointmentModel.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.addedBy;
    data['clinic_id'] = this.clinicId;
    data['clinic_name'] = this.clinicName;
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['doctor_id'] = this.doctorId;
    data['doctor_name'] = this.doctorName;
    data['encounter_date_global'] = this.encounterDateGlobal;
    data['encounter_date'] = this.encounterDate;
    data['id'] = this.encounterId;
    data['patient_email'] = this.patientEmail;
    data['patient_id'] = this.patientId;
    data['patient_name'] = this.patientName;
    data['status'] = this.status;
    data['is_billing'] = this.isBilling;
    data['payment_status'] = this.paymentStatus;
    data['appointment_id'] = this.appointmentId;
    /*if (this.custom_fields != null) {
      data['custom_fields'] = this.custom_fields!.map((v) => v.toJson()).toList();
    }*/
    if (this.encounterModules != null) {
      data['enocunter_modules'] = this.encounterModules!.map((v) => v.toJson()).toList();
    }
    if (this.moduleConfig != null) {
      data['module_config'] = this.moduleConfig!.map((v) => v.toJson()).toList();
    }
    if (this.prescriptionModule != null) {
      data['prescription_module'] = this.prescriptionModule!.map((v) => v.toJson()).toList();
    }

    if (this.prescription != null) {
      data['prescription'] = this.prescription;
    }
    data['bill_id'] = this.billId;

    //New
    if (this.note != null) {
      data['note'] = this.note!.map((v) => v.toJson()).toList();
    }
    if (this.observation != null) {
      data['observation'] = this.observation!.map((v) => v.toJson()).toList();
    }
    if (this.problem != null) {
      data['problem'] = this.problem!.map((v) => v.toJson()).toList();
    }

    //New
    data['total'] = this.total;
    if (this.upcomingAppointmentData != null) {
      data['data'] = this.upcomingAppointmentData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomField {
  String? createdAt;
  Fields? fields;
  String? id;
  String? moduleId;
  String? moduleType;
  Object? status;

  CustomField({this.createdAt, this.fields, this.id, this.moduleId, this.moduleType, this.status});

  factory CustomField.fromJson(Map<String, dynamic> json) {
    return CustomField(
      createdAt: json['created_at'],
      fields: json['fields'] != null ? Fields.fromJson(json['fields']) : null,
      id: json['id'],
      moduleId: json['module_id'],
      moduleType: json['module_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['module_id'] = this.moduleId;
    data['module_type'] = this.moduleType;
    if (this.fields != null) {
      data['fields'] = this.fields!.toJson();
    }
    return data;
  }
}

class Fields {
  String? isRequired;
  String? label;
  String? name;
  List<Object>? options;
  String? placeholder;
  String? priority;
  String? status;
  String? type;
  String? value;

  Fields({this.isRequired, this.label, this.name, this.options, this.placeholder, this.priority, this.status, this.type, this.value});

  factory Fields.fromJson(Map<String, dynamic> json) {
    return Fields(
      isRequired: json['isRequired'],
      label: json['label'],
      name: json['name'],
      // options: json['options'] != null ? (json['options'] as List).map((i) => Object.fromJson(i)).toList() : null,
      placeholder: json['placeholder'],
      priority: json['priority'],
      status: json['status'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isRequired'] = this.isRequired;
    data['label'] = this.label;
    data['name'] = this.name;
    data['placeholder'] = this.placeholder;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['type'] = this.type;
    data['value'] = this.value;
    /* if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}
