import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewAllLabel extends StatelessWidget {
  final String label;
  final String? subLabel;
  final List? list;
  final num viewAllShowLimit;
  final VoidCallback? onTap;
  final int? labelSize;
  final int? subLabelSize;

  ViewAllLabel({required this.label, this.subLabel, this.onTap, this.viewAllShowLimit = 4, this.labelSize, this.list, this.subLabelSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: boldTextStyle(size: labelSize ?? titleTextSize)),
            if (subLabel != null) 2.height,
            if (subLabel != null) Text(subLabel.validate(), style: secondaryTextStyle(size: subLabelSize ?? 12)),
          ],
        ).expand(),
        TextButton(
          onPressed: (list == null ? true : isViewAllVisible(list!))
              ? () {
                  onTap?.call();
                }
              : null,
          child: (list == null ? true : isViewAllVisible(list!)) ? Text(locale.lblViewAll, style: secondaryTextStyle(color: appSecondaryColor)) : SizedBox(),
        )
      ],
    );
  }

  bool isViewAllVisible(List list) => list.length >= viewAllShowLimit;
}
