import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/time_greeting_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:momona_healthcare/utils/common.dart';

class AppBarTitleWidget extends StatelessWidget {
  const AppBarTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(ic_hi, width: 22, height: 22, fit: BoxFit.cover),
            8.width,
            TimeGreetingWidget(userName: isDoctor() ? userStore.firstName.validate().prefixText(value: 'Dr. ') : userStore.firstName.validate(), separator: ',').expand(),
          ],
        ),
      ],
    );
  }
}
