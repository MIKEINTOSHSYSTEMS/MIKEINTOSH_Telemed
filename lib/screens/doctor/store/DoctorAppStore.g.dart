// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DoctorAppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DoctorAppStore on DoctorAppStoreBase, Store {
  late final _$bottomNavIndexAtom =
      Atom(name: 'DoctorAppStoreBase.bottomNavIndex', context: context);

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

  late final _$DoctorAppStoreBaseActionController =
      ActionController(name: 'DoctorAppStoreBase', context: context);

  @override
  void setBottomNavIndex(int index) {
    final _$actionInfo = _$DoctorAppStoreBaseActionController.startAction(
        name: 'DoctorAppStoreBase.setBottomNavIndex');
    try {
      return super.setBottomNavIndex(index);
    } finally {
      _$DoctorAppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
bottomNavIndex: ${bottomNavIndex}
    ''';
  }
}
