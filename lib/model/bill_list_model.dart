import 'package:nb_utils/nb_utils.dart';

class BillListModel {
  List<BillListData>? billListData;

  BillListModel({this.billListData});

  factory BillListModel.fromJson(Map<String, dynamic> json) {
    return BillListModel(
      billListData: json['data'] != null ? (json['data'] as List).map((i) => BillListData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.billListData != null) {
      data['data'] = this.billListData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BillListData {
  num? actualAmount;
  String? clinicName;
  String? createdAt;
  num? discount;

  String? doctorName;
  int? id;
  String? patientName;
  String? paymentStatus;
  num? totalAmount;
  num? encounterId;

  num? totalTax;
  //Extra? extra;

  BillListData({
    this.actualAmount,
    this.clinicName,
    this.createdAt,
    this.discount,
    this.doctorName,
    this.id,
    //this.extra,
    this.totalTax,
    this.patientName,
    this.paymentStatus,
    this.totalAmount,
    this.encounterId,
  });

  factory BillListData.fromJson(Map<String, dynamic> json) {
    return BillListData(
      id: json['id'],
      actualAmount: json['actual_amount'],
      clinicName: json['clinic_name'],
      createdAt: json['created_at'],
      discount: json['discount'],
      doctorName: json['doctor_name'],
      patientName: json['patient_name'],
      paymentStatus: json['payment_status'].runtimeType == bool ? (json['payment_status'] as bool).getIntBool().toString() : json['payment_status'],
      totalAmount: json['total_amount'],
      encounterId: json['encounter_id'],
      totalTax: json['tax_total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['actual_amount'] = this.actualAmount;
    data['clinic_name'] = this.clinicName;
    data['created_at'] = this.createdAt;
    data['discount'] = this.discount;
    data['doctor_name'] = this.doctorName;
    data['id'] = this.id;
    data['patient_name'] = this.patientName;
    data['payment_status'] = this.paymentStatus;
    data['total_amount'] = this.totalAmount;
    data['encounter_id'] = this.encounterId;
    data['tax_total'] = this.totalTax;

    //if (data["extra"] != null) data['extra'] = this.extra!.toJson();
    return data;
  }
}
