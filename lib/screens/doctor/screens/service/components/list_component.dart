import 'package:flutter/material.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ListComponent extends StatelessWidget {
  final String name;
  final VoidCallback onRemove;

  final bool isCheck;
  ListComponent({required this.name, required this.onRemove, this.isCheck = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      width: context.width() / 2 - 24,
      decoration: boxDecorationDefault(
        border: Border.all(color: isCheck ? appSecondaryColor : borderColor),
        color: context.cardColor,
        borderRadius: radius(24),
      ),
      child: Row(
        children: [
          Text(
            name.validate(),
            style: primaryTextStyle(color: context.iconColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ).expand(),
          ic_clear.iconImage().paddingAll(4).appOnTap(() {
            onRemove.call();
          }),
        ],
      ),
    );
  }
}
