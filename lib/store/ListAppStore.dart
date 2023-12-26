import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/model/login_response_model.dart';
import 'package:kivicare_flutter/model/patient_bill_model.dart';
import 'package:kivicare_flutter/model/patient_list_model.dart';
import 'package:kivicare_flutter/model/static_data_model.dart';
import 'package:mobx/mobx.dart';

part 'ListAppStore.g.dart';

class ListAppStore = ListAppStoreBase with _$ListAppStore;

abstract class ListAppStoreBase with Store {
  var doctorList = ObservableList<DoctorList?>();
  var patientList = ObservableList<PatientData>();
  var specializationList = ObservableList<StaticData?>();
  var serviceList = ObservableList<StaticData?>();
  var billItemList = ObservableList<BillItem>();
  var clinicItemList = ObservableList<Clinic?>();

  @action
  void addBillItem(List<BillItem> data, {bool isClear = true}) {
    if (isClear) {
      billItemList.clear();
    }
    billItemList.addAll(data);
  }

  @action
  void removeBillItem(BillItem data, {bool isClear = true}) {
    billItemList.remove(data);
  }

  @action
  void clearBillItems({bool isClear = true}) {
    billItemList.clear();
  }

  @action
  void addDoctor(List<DoctorList> data, {bool isClear = true}) {
    if (isClear) {
      doctorList.clear();
    }
    doctorList.addAll(data);
  }

  @action
  void addClinic(List<Clinic> data, {bool isClear = true}) {
    if (isClear) {
      clinicItemList.clear();
    }
    clinicItemList.addAll(data);
  }

  @action
  void addPatient(List<PatientData> data, {bool isClear = true}) {
    if (isClear) {
      patientList.clear();
    }
    patientList.addAll(data);
  }

  @action
  void addSpecialization(List<StaticData?> data, {bool isClear = true}) {
    if (isClear) {
      specializationList.clear();
    }
    specializationList.addAll(data);
  }

  @action
  void addServices(List<StaticData?> data, {bool isClear = true}) {
    if (isClear) {
      serviceList.clear();
    }
    serviceList.addAll(data);
  }

  @action
  void removeDoctor(DoctorListModel data) {
    patientList.clear();
  }

  @action
  void removePatient(PatientListModel data) {
    patientList.clear();
  }

  @action
  void removeSpecialization(StaticData data) {
    specializationList.clear();
  }

  @action
  void removeServices(StaticData data) {
    serviceList.clear();
  }
}
