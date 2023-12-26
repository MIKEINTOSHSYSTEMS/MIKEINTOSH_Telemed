import 'package:kivicare_flutter/model/login_response_model.dart';

class EncounterDashboardModel {
  String? added_by;
  String? appointment_id;
  String? clinic_id;
  String? clinic_name;
  String? created_at;
  List<CustomField>? custom_fields;
  String? description;
  String? doctor_id;
  String? doctor_name;
  String? encounter_date;
  String? id;
  String? patient_email;
  String? patient_id;
  String? patient_name;
  String? status;
  String? bill_id;
  bool? is_billing;
  String? payment_status;
  List<ModuleConfig>? module_config;
  List<PrescriptionModule>? prescription_module;
  List<EnocunterModule>? enocunter_modules;

  EncounterDashboardModel({
    this.added_by,
    this.appointment_id,
    this.clinic_id,
    this.clinic_name,
    this.created_at,
    this.custom_fields,
    this.description,
    this.doctor_id,
    this.doctor_name,
    this.encounter_date,
    this.id,
    this.patient_email,
    this.patient_id,
    this.patient_name,
    this.status,
    this.bill_id,
    this.is_billing,
    this.payment_status,
    this.module_config,
    this.prescription_module,
    this.enocunter_modules,
  });

  factory EncounterDashboardModel.fromJson(Map<String, dynamic> json) {
    return EncounterDashboardModel(
      added_by: json['added_by'],
      appointment_id: json['appointment_id'],
      clinic_id: json['clinic_id'],
      clinic_name: json['clinic_name'],
      created_at: json['created_at'],
      // custom_fields: json['custom_fields'] != null ? (json['custom_fields'] as List).map((i) => CustomField.fromJson(i)).toList() : null,
      description: json['description'],
      doctor_id: json['doctor_id'],
      doctor_name: json['doctor_name'],
      enocunter_modules: json['enocunter_modules'] != null ? (json['enocunter_modules'] as List).map((i) => EnocunterModule.fromJson(i)).toList() : null,
      module_config: json['module_config'] != null ? (json['module_config'] as List).map((i) => ModuleConfig.fromJson(i)).toList() : null,
      prescription_module: json['prescription_module'] != null ? (json['prescription_module'] as List).map((i) => PrescriptionModule.fromJson(i)).toList() : null,
      encounter_date: json['encounter_date'],
      id: json['id'],
      patient_email: json['patient_email'],
      patient_id: json['patient_id'],
      patient_name: json['patient_name'],
      status: json['status'],
      bill_id: json['bill_id'],
      is_billing: json['is_billing'],
      payment_status: json['payment_status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.added_by;
    data['clinic_id'] = this.clinic_id;
    data['clinic_name'] = this.clinic_name;
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['doctor_id'] = this.doctor_id;
    data['doctor_name'] = this.doctor_name;
    data['encounter_date'] = this.encounter_date;
    data['id'] = this.id;
    data['patient_email'] = this.patient_email;
    data['patient_id'] = this.patient_id;
    data['patient_name'] = this.patient_name;
    data['status'] = this.status;
    data['is_billing'] = this.is_billing;
    data['payment_status'] = this.payment_status;
    data['appointment_id'] = this.appointment_id;
    /*if (this.custom_fields != null) {
      data['custom_fields'] = this.custom_fields!.map((v) => v.toJson()).toList();
    }*/
    if (this.enocunter_modules != null) {
      data['enocunter_modules'] = this.enocunter_modules!.map((v) => v.toJson()).toList();
    }
    if (this.module_config != null) {
      data['module_config'] = this.module_config!.map((v) => v.toJson()).toList();
    }
    if (this.prescription_module != null) {
      data['prescription_module'] = this.prescription_module!.map((v) => v.toJson()).toList();
    }
    data['bill_id'] = this.bill_id;

    return data;
  }
}

class CustomField {
  String? created_at;
  Fields? fields;
  String? id;
  String? module_id;
  String? module_type;
  Object? status;

  CustomField({this.created_at, this.fields, this.id, this.module_id, this.module_type, this.status});

  factory CustomField.fromJson(Map<String, dynamic> json) {
    return CustomField(
      created_at: json['created_at'],
      fields: json['fields'] != null ? Fields.fromJson(json['fields']) : null,
      id: json['id'],
      module_id: json['module_id'],
      module_type: json['module_type'],
      // status: json['status'] != null ? Object.fromJson(json['status']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['module_id'] = this.module_id;
    data['module_type'] = this.module_type;
    if (this.fields != null) {
      data['fields'] = this.fields!.toJson();
    }
    /* if (this.status != null) {
      data['status'] = this.status.toJson();
    }*/
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
