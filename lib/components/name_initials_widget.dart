import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class NameInitialsWidget extends StatelessWidget {
  final String firstName;
  final String? lastName;
  final int? fontSize;
  final Color? color;

  NameInitialsWidget({required this.firstName, this.lastName, this.fontSize, this.color})
      : assert(firstName.isNotEmpty, 'First name cannot be empty'),
        assert(lastName != null || lastName.validate().isEmpty, 'Last name cannot be empty or null');

  @override
  Widget build(BuildContext context) {
    if (lastName != null) {
      return Text('${firstName[0]}${lastName.validate()[0]}', style: boldTextStyle(color: color ?? textPrimaryColorGlobal, size: fontSize ?? textBoldSizeGlobal.toInt()));
    }
    return Text(firstName[0], style: boldTextStyle(color: color ?? textPrimaryColorGlobal, size: fontSize ?? textBoldSizeGlobal.toInt()));
  }
}
