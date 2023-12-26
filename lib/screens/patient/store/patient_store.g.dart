// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PatientStore on PatientStoreBase, Store {
  late final _$bottomNavIndexAtom = Atom(name: 'PatientStoreBase.bottomNavIndex', context: context);

  @override
  int get bottomNavIndex {
    _$bottomNavIndexAtom.reportRead();
    return super.bottomNavIndex;
  }

  @override
  set bottomNavIndex(int value) {
    _$bottomNavIndexAtom.reportWrite(value, super.bottomNavIndex, () {
      super.bottomNavIndex = value;
    });
  }

  late final _$PatientStoreBaseActionController = ActionController(name: 'PatientStoreBase', context: context);

  @override
  void setBottomNavIndex(int index) {
    final _$actionInfo = _$PatientStoreBaseActionController.startAction(name: 'PatientStoreBase.setBottomNavIndex');
    try {
      return super.setBottomNavIndex(index);
    } finally {
      _$PatientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
bottomNavIndex: ${bottomNavIndex}
    ''';
  }
}
