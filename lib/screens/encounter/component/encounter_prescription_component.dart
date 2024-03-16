import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/prescription_model.dart';

class EncounterPrescriptionComponent extends StatelessWidget {
  final PrescriptionData prescriptionData;
  final Function? onTap;
  final bool isDeleteOn;

  EncounterPrescriptionComponent({required this.prescriptionData, this.onTap, this.isDeleteOn = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(prescriptionData.name.validate(value: locale.lblNoTitle).capitalizeFirstLetter(), style: boldTextStyle()),
              4.height,
              Text(locale.lblDays.capitalizeFirstLetter() + " : " + prescriptionData.duration.validate(), style: primaryTextStyle()),
              2.height,
              Text("${locale.lblTime.capitalizeFirstLetter()} : ${prescriptionData.frequency.validate(value: locale.lblNoTitle)}", style: primaryTextStyle()),
              if (prescriptionData.instruction.validate().isNotEmpty) 2.height,
              if (prescriptionData.instruction.validate().isNotEmpty) Text(prescriptionData.instruction.validate(), style: secondaryTextStyle())
            ],
          ).expand(),
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
