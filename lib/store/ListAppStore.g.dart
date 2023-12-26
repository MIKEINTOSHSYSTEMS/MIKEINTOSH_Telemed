// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListAppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ListAppStore on ListAppStoreBase, Store {
  late final _$ListAppStoreBaseActionController = ActionController(name: 'ListAppStoreBase', context: context);

  @override
  void addBillItem(List<BillItem> data, {bool isClear = true}) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.addBillItem');
    try {
      return super.addBillItem(data, isClear: isClear);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeBillItem(BillItem data, {bool isClear = true}) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.removeBillItem');
    try {
      return super.removeBillItem(data, isClear: isClear);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearBillItems({bool isClear = true}) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.clearBillItems');
    try {
      return super.clearBillItems(isClear: isClear);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addDoctor(List<DoctorList> data, {bool isClear = true}) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.addDoctor');
    try {
      return super.addDoctor(data, isClear: isClear);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addClinic(List<Clinic> data, {bool isClear = true}) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.addClinic');
    try {
      return super.addClinic(data, isClear: isClear);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPatient(List<PatientData> data, {bool isClear = true}) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.addPatient');
    try {
      return super.addPatient(data, isClear: isClear);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSpecialization(List<StaticData?> data, {bool isClear = true}) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.addSpecialization');
    try {
      return super.addSpecialization(data, isClear: isClear);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addServices(List<StaticData?> data, {bool isClear = true}) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.addServices');
    try {
      return super.addServices(data, isClear: isClear);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeDoctor(DoctorListModel data) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.removeDoctor');
    try {
      return super.removeDoctor(data);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePatient(PatientListModel data) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.removePatient');
    try {
      return super.removePatient(data);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeSpecialization(StaticData data) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.removeSpecialization');
    try {
      return super.removeSpecialization(data);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeServices(StaticData data) {
    final _$actionInfo = _$ListAppStoreBaseActionController.startAction(name: 'ListAppStoreBase.removeServices');
    try {
      return super.removeServices(data);
    } finally {
      _$ListAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
