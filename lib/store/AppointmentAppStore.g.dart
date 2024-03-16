// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppointmentAppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppointmentAppStore on AppointmentAppStoreBase, Store {
  late final _$selectedAppointmentDateAtom = Atom(
      name: 'AppointmentAppStoreBase.selectedAppointmentDate',
      context: context);

  @override
  DateTime get selectedAppointmentDate {
    _$selectedAppointmentDateAtom.reportRead();
    return super.selectedAppointmentDate;
  }

  @override
  set selectedAppointmentDate(DateTime value) {
    _$selectedAppointmentDateAtom
        .reportWrite(value, super.selectedAppointmentDate, () {
      super.selectedAppointmentDate = value;
    });
  }

  late final _$mDoctorSelectedAtom =
      Atom(name: 'AppointmentAppStoreBase.mDoctorSelected', context: context);

  @override
  UserModel? get mDoctorSelected {
    _$mDoctorSelectedAtom.reportRead();
    return super.mDoctorSelected;
  }

  @override
  set mDoctorSelected(UserModel? value) {
    _$mDoctorSelectedAtom.reportWrite(value, super.mDoctorSelected, () {
      super.mDoctorSelected = value;
    });
  }

  late final _$mClinicSelectedAtom =
      Atom(name: 'AppointmentAppStoreBase.mClinicSelected', context: context);

  @override
  Clinic? get mClinicSelected {
    _$mClinicSelectedAtom.reportRead();
    return super.mClinicSelected;
  }

  @override
  set mClinicSelected(Clinic? value) {
    _$mClinicSelectedAtom.reportWrite(value, super.mClinicSelected, () {
      super.mClinicSelected = value;
    });
  }

  late final _$mIsUpdateAtom =
      Atom(name: 'AppointmentAppStoreBase.mIsUpdate', context: context);

  @override
  bool? get mIsUpdate {
    _$mIsUpdateAtom.reportRead();
    return super.mIsUpdate;
  }

  @override
  set mIsUpdate(bool? value) {
    _$mIsUpdateAtom.reportWrite(value, super.mIsUpdate, () {
      super.mIsUpdate = value;
    });
  }

  late final _$mSelectedPaymentMethodAtom = Atom(
      name: 'AppointmentAppStoreBase.mSelectedPaymentMethod', context: context);

  @override
  String? get mSelectedPaymentMethod {
    _$mSelectedPaymentMethodAtom.reportRead();
    return super.mSelectedPaymentMethod;
  }

  @override
  set mSelectedPaymentMethod(String? value) {
    _$mSelectedPaymentMethodAtom
        .reportWrite(value, super.mSelectedPaymentMethod, () {
      super.mSelectedPaymentMethod = value;
    });
  }

  late final _$mPatientSelectedAtom =
      Atom(name: 'AppointmentAppStoreBase.mPatientSelected', context: context);

  @override
  String? get mPatientSelected {
    _$mPatientSelectedAtom.reportRead();
    return super.mPatientSelected;
  }

  @override
  set mPatientSelected(String? value) {
    _$mPatientSelectedAtom.reportWrite(value, super.mPatientSelected, () {
      super.mPatientSelected = value;
    });
  }

  late final _$mPatientIdAtom =
      Atom(name: 'AppointmentAppStoreBase.mPatientId', context: context);

  @override
  int? get mPatientId {
    _$mPatientIdAtom.reportRead();
    return super.mPatientId;
  }

  @override
  set mPatientId(int? value) {
    _$mPatientIdAtom.reportWrite(value, super.mPatientId, () {
      super.mPatientId = value;
    });
  }

  late final _$mStatusSelectedAtom =
      Atom(name: 'AppointmentAppStoreBase.mStatusSelected', context: context);

  @override
  int? get mStatusSelected {
    _$mStatusSelectedAtom.reportRead();
    return super.mStatusSelected;
  }

  @override
  set mStatusSelected(int? value) {
    _$mStatusSelectedAtom.reportWrite(value, super.mStatusSelected, () {
      super.mStatusSelected = value;
    });
  }

  late final _$mSelectedTimeAtom =
      Atom(name: 'AppointmentAppStoreBase.mSelectedTime', context: context);

  @override
  String? get mSelectedTime {
    _$mSelectedTimeAtom.reportRead();
    return super.mSelectedTime;
  }

  @override
  set mSelectedTime(String? value) {
    _$mSelectedTimeAtom.reportWrite(value, super.mSelectedTime, () {
      super.mSelectedTime = value;
    });
  }

  late final _$mDescriptionAtom =
      Atom(name: 'AppointmentAppStoreBase.mDescription', context: context);

  @override
  String? get mDescription {
    _$mDescriptionAtom.reportRead();
    return super.mDescription;
  }

  @override
  set mDescription(String? value) {
    _$mDescriptionAtom.reportWrite(value, super.mDescription, () {
      super.mDescription = value;
    });
  }

  late final _$selectedServiceAtom =
      Atom(name: 'AppointmentAppStoreBase.selectedService', context: context);

  @override
  ObservableList<int> get selectedService {
    _$selectedServiceAtom.reportRead();
    return super.selectedService;
  }

  @override
  set selectedService(ObservableList<int> value) {
    _$selectedServiceAtom.reportWrite(value, super.selectedService, () {
      super.selectedService = value;
    });
  }

  late final _$selectedDoctorAtom =
      Atom(name: 'AppointmentAppStoreBase.selectedDoctor', context: context);

  @override
  ObservableList<int?> get selectedDoctor {
    _$selectedDoctorAtom.reportRead();
    return super.selectedDoctor;
  }

  @override
  set selectedDoctor(ObservableList<int?> value) {
    _$selectedDoctorAtom.reportWrite(value, super.selectedDoctor, () {
      super.selectedDoctor = value;
    });
  }

  late final _$reportListAtom =
      Atom(name: 'AppointmentAppStoreBase.reportList', context: context);

  @override
  ObservableList<PlatformFile> get reportList {
    _$reportListAtom.reportRead();
    return super.reportList;
  }

  @override
  set reportList(ObservableList<PlatformFile> value) {
    _$reportListAtom.reportWrite(value, super.reportList, () {
      super.reportList = value;
    });
  }

  late final _$AppointmentAppStoreBaseActionController =
      ActionController(name: 'AppointmentAppStoreBase', context: context);

  @override
  void removeDoctor(DoctorListModel data) {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.removeDoctor');
    try {
      return super.removeDoctor(data);
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearServices() {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.clearServices');
    try {
      return super.clearServices();
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedDoctor(UserModel? aSelected) {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.setSelectedDoctor');
    try {
      return super.setSelectedDoctor(aSelected);
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedClinic(Clinic? aSelected) {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.setSelectedClinic');
    try {
      return super.setSelectedClinic(aSelected);
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedPatient(String? aName) {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.setSelectedPatient');
    try {
      return super.setSelectedPatient(aName);
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedPatientId(int? aStatus) {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.setSelectedPatientId');
    try {
      return super.setSelectedPatientId(aStatus);
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUpdateValue(bool? aIsUpdate) {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.setUpdateValue');
    try {
      return super.setUpdateValue(aIsUpdate);
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStatusSelected(int? aStatus) {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.setStatusSelected');
    try {
      return super.setStatusSelected(aStatus);
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedAppointmentDate(DateTime aSelected) {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.setSelectedAppointmentDate');
    try {
      return super.setSelectedAppointmentDate(aSelected);
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedTime(String? aSelected) {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.setSelectedTime');
    try {
      return super.setSelectedTime(aSelected);
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String? aSelected) {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.setDescription');
    try {
      return super.setDescription(aSelected);
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPaymentMethod(String? paymentMethod) {
    final _$actionInfo = _$AppointmentAppStoreBaseActionController.startAction(
        name: 'AppointmentAppStoreBase.setPaymentMethod');
    try {
      return super.setPaymentMethod(paymentMethod);
    } finally {
      _$AppointmentAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedAppointmentDate: ${selectedAppointmentDate},
mDoctorSelected: ${mDoctorSelected},
mClinicSelected: ${mClinicSelected},
mIsUpdate: ${mIsUpdate},
mSelectedPaymentMethod: ${mSelectedPaymentMethod},
mPatientSelected: ${mPatientSelected},
mPatientId: ${mPatientId},
mStatusSelected: ${mStatusSelected},
mSelectedTime: ${mSelectedTime},
mDescription: ${mDescription},
selectedService: ${selectedService},
selectedDoctor: ${selectedDoctor},
reportList: ${reportList}
    ''';
  }
}
