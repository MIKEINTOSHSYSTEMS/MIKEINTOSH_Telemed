import 'package:flutter/material.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/widgets/spining_lines.dart';

class LoaderWidget extends StatelessWidget {
  final double? size;

  LoaderWidget({this.size});

  @override
  Widget build(BuildContext context) {
    return SpinKitSpinningLines(color: primaryColor, size: size ?? 70);
  }
}
