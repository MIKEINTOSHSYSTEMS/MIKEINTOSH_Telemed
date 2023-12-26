// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MultiSelectStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MultiSelectStore on MultiSelectStoreBase, Store {
  late final _$selectedServiceAtom = Atom(name: 'MultiSelectStoreBase.selectedService', context: context);

  @override
  ObservableList<ServiceData> get selectedService {
    _$selectedServiceAtom.reportRead();
    return super.selectedService;
  }

  @override
  set selectedService(ObservableList<ServiceData> value) {
    _$selectedServiceAtom.reportWrite(value, super.selectedService, () {
      super.selectedService = value;
    });
  }

  late final _$MultiSelectStoreBaseActionController = ActionController(name: 'MultiSelectStoreBase', context: context);

  @override
  void addList(List<ServiceData> data, {bool isClear = true}) {
    final _$actionInfo = _$MultiSelectStoreBaseActionController.startAction(name: 'MultiSelectStoreBase.addList');
    try {
      return super.addList(data, isClear: isClear);
    } finally {
      _$MultiSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSingleItem(ServiceData data, {bool isClear = true}) {
    final _$actionInfo = _$MultiSelectStoreBaseActionController.startAction(name: 'MultiSelectStoreBase.addSingleItem');
    try {
      return super.addSingleItem(data, isClear: isClear);
    } finally {
      _$MultiSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem(ServiceData data) {
    final _$actionInfo = _$MultiSelectStoreBaseActionController.startAction(name: 'MultiSelectStoreBase.removeItem');
    try {
      return super.removeItem(data);
    } finally {
      _$MultiSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearList() {
    final _$actionInfo = _$MultiSelectStoreBaseActionController.startAction(name: 'MultiSelectStoreBase.clearList');
    try {
      return super.clearList();
    } finally {
      _$MultiSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addStaticData(List<StaticData> data, {bool isClear = true}) {
    final _$actionInfo = _$MultiSelectStoreBaseActionController.startAction(name: 'MultiSelectStoreBase.addStaticData');
    try {
      return super.addStaticData(data, isClear: isClear);
    } finally {
      _$MultiSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSingleStaticItem(StaticData? data, {bool isClear = true}) {
    final _$actionInfo = _$MultiSelectStoreBaseActionController.startAction(name: 'MultiSelectStoreBase.addSingleStaticItem');
    try {
      return super.addSingleStaticItem(data, isClear: isClear);
    } finally {
      _$MultiSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeStaticItem(StaticData data) {
    final _$actionInfo = _$MultiSelectStoreBaseActionController.startAction(name: 'MultiSelectStoreBase.removeStaticItem');
    try {
      return super.removeStaticItem(data);
    } finally {
      _$MultiSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearStaticList() {
    final _$actionInfo = _$MultiSelectStoreBaseActionController.startAction(name: 'MultiSelectStoreBase.clearStaticList');
    try {
      return super.clearStaticList();
    } finally {
      _$MultiSelectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedService: ${selectedService}
    ''';
  }
}
