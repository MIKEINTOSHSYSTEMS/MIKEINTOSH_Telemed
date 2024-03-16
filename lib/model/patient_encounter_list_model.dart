import 'package:momona_healthcare/model/encounter_model.dart';

class PatientEncounterListModel {
  List<EncounterModel>? patientEncounterData;
  String? total;

  PatientEncounterListModel({this.patientEncounterData, this.total});

  factory PatientEncounterListModel.fromJson(Map<String, dynamic> json) {
    return PatientEncounterListModel(
      patientEncounterData: json['data'] != null ? (json['data'] as List).map((i) => EncounterModel.fromJson(i)).toList() : null,
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
