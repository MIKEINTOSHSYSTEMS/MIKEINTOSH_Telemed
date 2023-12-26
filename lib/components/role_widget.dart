import 'package:flutter/material.dart';
import 'package:kivicare_flutter/utils/common.dart';

class RoleWidget extends StatelessWidget {
  final Widget child;
  final bool isShowPatient;
  final bool isShowDoctor;
  final bool isShowReceptionist;

  RoleWidget({required this.child, this.isShowPatient = false, this.isShowDoctor = false, this.isShowReceptionist = false});

  @override
  Widget build(BuildContext context) {
    if (isShowPatient && isPatient()) {
      return child;
    }
    if (isShowDoctor && isDoctor()) {
      return child;
    }
    if (isShowReceptionist && isReceptionist()) {
      return child;
    }

    return Offstage();
  }
}
