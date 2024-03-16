import 'package:flutter/material.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/encounter_type_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';

class EncounterTypeComponent extends StatelessWidget {
  final EncounterType data;
  final Function? onTap;
  final bool isDeleteOn;

  EncounterTypeComponent({required this.data, this.onTap, this.isDeleteOn = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(data.title.validate(value: locale.lblNoTitle), style: primaryTextStyle()).expand(),
          10.width.visible(isDeleteOn),
          Icon(Icons.delete, color: Colors.red, size: 20)
              .appOnTap(
                () => onTap?.call(),
              )
              .visible(isDeleteOn),
        ],
      ),
    );
  }
}
