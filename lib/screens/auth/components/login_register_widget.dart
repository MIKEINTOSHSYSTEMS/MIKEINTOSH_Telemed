import 'package:flutter/material.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class LoginRegisterWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final Function()? onTap;

  LoginRegisterWidget({
    Key? key,
    this.title,
    this.subTitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title.validate(), style: secondaryTextStyle()),
        TextButton(
          onPressed: onTap,
          child: Text(subTitle.validate(), style: primaryTextStyle(color: appSecondaryColor, size: 14, decoration: TextDecoration.underline, fontStyle: FontStyle.italic)),
        )
      ],
    );
  }
}
