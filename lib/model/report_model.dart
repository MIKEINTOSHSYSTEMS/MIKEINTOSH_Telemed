class ReportModel {
  int? total;
  List<ReportData>? reportData;

  ReportModel({this.total, this.reportData});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      total: json['total'],
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
  String? id;
  String? name;
  String? patient_id;
  String? upload_report;
  String? upload_report_url;

  ReportData({this.date, this.id, this.name, this.patient_id, this.upload_report, this.upload_report_url});

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      date: json['date'],
      id: json['id'],
      name: json['name'],
      patient_id: json['patient_id'],
      upload_report: json['upload_report'],
      upload_report_url: json['upload_report_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['id'] = this.id;
    data['name'] = this.name;
    data['patient_id'] = this.patient_id;
    data['upload_report'] = this.upload_report;
    data['upload_report_url'] = this.upload_report_url;
    return data;
  }
}
