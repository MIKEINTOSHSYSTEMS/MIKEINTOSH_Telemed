import 'package:flutter/material.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class StatusWidget extends StatelessWidget {
  final String status;
  final Color? backgroundColor;

  const StatusWidget({Key? key, required this.status, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: boxDecorationDefault(color: backgroundColor ?? appSecondaryColor, borderRadius: radiusOnly(topRight: defaultRadius)),
      child: Text(status, style: primaryTextStyle(size: 12, color: white)),
    );
  }
}
