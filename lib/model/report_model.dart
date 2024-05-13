import 'package:intl/intl.dart';
import 'package:kivicare_flutter/utils/constants.dart';

class ReportModel {
  int? total;

  ReportResponse? reportResponse;

  List<ReportData>? reportData;

  ReportModel({this.total, this.reportData, this.reportResponse});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      total: json['total'],
      reportResponse: json['message'] != null ? ReportResponse.fromJson(json['message']) : null,
      reportData: json['data'] != null ? (json['data'] as List).map((i) => ReportData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;

    if (this.reportData != null) {
      data['data'] = this.reportData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportData {
  String? date;
  num? id;
  String? name;
  num? patientId;
  String? uploadReport;
  String? reportDate;

  DateTime get getReportDate => DateFormat(SAVE_DATE_FORMAT).parse(date!);

  ReportData({this.date, this.id, this.name, this.patientId, this.uploadReport, this.reportDate});

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      date: json['date'],
      reportDate: json['report_date'],
      id: json['id'],
      name: json['name'],
      patientId: json['patient_id'],
      uploadReport: json['upload_report'] != null
          ? json['upload_report']
          : json['upload_report_url'] != null
              ? json['upload_report_url']
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['id'] = this.id;
    data['name'] = this.name;
    data['patient_id'] = this.patientId;
    data['upload_report'] = this.uploadReport;
    data['report_date'] = this.reportDate;
    return data;
  }
}

class ReportResponse {
  String? message;
  String? code;
  bool? status;

  ReportResponse({
    this.message,
    this.code,
    this.status,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      message: json['message'],
      code: json['code'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    data['status'] = this.status;
    return data;
  }
}
