import 'package:file_picker/file_picker.dart';
import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/model/user_model.dart';
import 'package:mobx/mobx.dart';

import '../model/clinic_list_model.dart';
import '../model/upcoming_appointment_model.dart';

part 'AppointmentAppStore.g.dart';

class AppointmentAppStore = AppointmentAppStoreBase with _$AppointmentAppStore;

abstract class AppointmentAppStoreBase with Store {
  @observable
  DateTime selectedAppointmentDate = DateTime.now();

  @observable
  UserModel? mDoctorSelected;

  @observable
  Clinic? mClinicSelected;

  @observable
  bool? mIsUpdate;

  @observable
  String? mSelectedPaymentMethod;

  @observable
  String? mPatientSelected;

  @observable
  int? mPatientId;

  @observable
  int? mStatusSelected;

  @observable
  String? mSelectedTime = "";

  @observable
  String? mDescription = "";

  @observable
  ObservableList<int> selectedService = ObservableList<int>();

  @observable
  ObservableList<int?> selectedDoctor = ObservableList<int?>();

  @observable
  ObservableList<PlatformFile> reportList = ObservableList<PlatformFile>();
  ObservableList<AppointmentReport> reportListString = ObservableList<AppointmentReport>();

  void addReportData({required List<PlatformFile> data, bool isClear = true}) {
    if (isClear) reportList.clear();
    reportList.addAll(data);
  }

  void addReportListString({required List<AppointmentReport> data, bool isClear = true}) {
    if (isClear) reportListString.clear();
    reportListString.addAll(data);
  }

  void removeReportData({required int index}) {
    reportList.removeAt(index);
  }

  void clearAll() {
    reportList.clear();
    reportListString.clear();
  }

  void addSelectedService(List<int> data, {bool isClear = true}) {
    if (isClear) selectedService.clear();
    selectedService.addAll(data);
  }

  void addSelectedDoctor(List<int?> data, {bool isClear = true}) {
    if (isClear) selectedDoctor.clear();
    selectedDoctor.addAll(data);
  }

  @action
  void removeDoctor(DoctorListModel data) {
    selectedDoctor.clear();
  }

  @action
  void clearServices() {
    selectedService.clear();
  }

  @action
  void setSelectedDoctor(UserModel? aSelected) => mDoctorSelected = aSelected;

  @action
  void setSelectedClinic(Clinic? aSelected) => mClinicSelected = aSelected;

  @action
  void setSelectedPatient(String? aName) => mPatientSelected = aName;

  @action
  void setSelectedPatientId(int? aStatus) => mPatientId = aStatus;

  @action
  void setUpdateValue(bool? aIsUpdate) => mIsUpdate = aIsUpdate;

  @action
  void setStatusSelected(int? aStatus) => mStatusSelected = aStatus;

  @action
  void setSelectedAppointmentDate(DateTime aSelected) => selectedAppointmentDate = aSelected;

  @action
  void setSelectedTime(String? aSelected) => mSelectedTime = aSelected;

  @action
  void setDescription(String? aSelected) => mDescription = aSelected;

  @action
  void setPaymentMethod(String? paymentMethod) => mSelectedPaymentMethod = paymentMethod;
}
