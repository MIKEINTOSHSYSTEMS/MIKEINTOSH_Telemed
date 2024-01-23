import 'package:flutter/material.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/medical_history_model.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class EncounterItemWidget extends StatelessWidget {
  final EncounterType? data;
  final Function? onTap;
  final bool isDeleteOn;

  EncounterItemWidget({this.data, this.onTap, this.isDeleteOn = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(data!.title.validate(value: locale.lblNoTitle), style: primaryTextStyle()).expand(),
        10.width.visible(isDeleteOn),
        Icon(Icons.delete, color: primaryColor, size: 20).onTap(() => onTap?.call()).visible(isDeleteOn),
      ],
    ).paddingSymmetric(vertical: 8);
  }
}
