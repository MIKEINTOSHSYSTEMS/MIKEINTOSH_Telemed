import 'package:momona_healthcare/model/login_response_model.dart';

class PatientBillModule {
  String? actual_amount;
  List<BillItem>? billItems;
  Clinic? clinic;
  String? created_at;
  String? discount;
  String? encounter_id;
  String? id;
  Patient? patient;
  PatientEncounter? patientEncounter;
  String? payment_status;
  String? status;
  String? title;
  String? total_amount;

  PatientBillModule({this.actual_amount, this.billItems, this.clinic, this.created_at, this.discount, this.encounter_id, this.id, this.patient, this.patientEncounter, this.payment_status, this.status, this.title, this.total_amount});

  factory PatientBillModule.fromJson(Map<String, dynamic> json) {
    return PatientBillModule(
      actual_amount: json['actual_amount'],
      billItems: json['billItems'] != null ? (json['billItems'] as List).map((i) => BillItem.fromJson(i)).toList() : null,
      clinic: json['clinic'] != null ? Clinic.fromJson(json['clinic']) : null,
      created_at: json['created_at'],
      discount: json['discount'],
      encounter_id: json['encounter_id'],
      id: json['id'],
      patient: json['patient'] != null ? Patient.fromJson(json['patient']) : null,
      patientEncounter: json['patientEncounter'] != null ? PatientEncounter.fromJson(json['patientEncounter']) : null,
      payment_status: json['payment_status'],
      status: json['status'],
      title: json['title'],
      total_amount: json['total_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['actual_amount'] = this.actual_amount;
    data['created_at'] = this.created_at;
    data['discount'] = this.discount;
    data['encounter_id'] = this.encounter_id;
    data['id'] = this.id;
    data['payment_status'] = this.payment_status;
    data['status'] = this.status;
    data['title'] = this.title;
    data['total_amount'] = this.total_amount;
    if (this.billItems != null) {
      data['billItems'] = this.billItems!.map((v) => v.toJson()).toList();
    }
    if (this.clinic != null) {
      data['clinic'] = this.clinic!.toJson();
    }
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    if (this.patientEncounter != null) {
      data['patientEncounter'] = this.patientEncounter!.toJson();
    }
    return data;
  }
}

class PatientEncounter {
  String? added_by;
  String? appointment_id;
  String? clinic_id;
  String? created_at;
  String? description;
  String? doctor_id;
  String? encounter_date;
  String? id;
  String? patient_id;
  String? status;

  PatientEncounter({this.added_by, this.appointment_id, this.clinic_id, this.created_at, this.description, this.doctor_id, this.encounter_date, this.id, this.patient_id, this.status});

  factory PatientEncounter.fromJson(Map<String, dynamic> json) {
    return PatientEncounter(
      added_by: json['added_by'],
      appointment_id: json['appointment_id'],
      clinic_id: json['clinic_id'],
      created_at: json['created_at'],
      description: json['description'],
      doctor_id: json['doctor_id'],
      encounter_date: json['encounter_date'],
      id: json['id'],
      patient_id: json['patient_id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.added_by;
    data['appointment_id'] = this.appointment_id;
    data['clinic_id'] = this.clinic_id;
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['doctor_id'] = this.doctor_id;
    data['encounter_date'] = this.encounter_date;
    data['id'] = this.id;
    data['patient_id'] = this.patient_id;
    data['status'] = this.status;
    return data;
  }
}

class BillItem {
  String? bill_id;
  String? id;
  String? item_id;
  String? label;
  String? price;
  String? qty;

  BillItem({this.bill_id, this.id, this.item_id, this.label, this.price, this.qty});

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      id: json['id'],
      bill_id: json['bill_id'],
      price: json['price'],
      qty: json['qty'],
      item_id: json['item_id'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bill_id'] = this.bill_id;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['item_id'] = this.item_id;
    data['label'] = this.label;
    return data;
  }
}

class Patient {
  String? display_name;
  String? dob;
  String? email;
  String? gender;
  String? id;

  Patient({this.display_name, this.dob, this.email, this.gender, this.id});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      display_name: json['display_name'],
      dob: json['dob'],
      email: json['email'],
      gender: json['gender'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.display_name;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['id'] = this.id;
    return data;
  }
}
