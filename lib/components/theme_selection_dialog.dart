import 'package:flutter/material.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class ThemeSelectionDialog extends StatefulWidget {
  static String tag = '/ThemeSelectionDialog';

  @override
  ThemeSelectionDialogState createState() => ThemeSelectionDialogState();
}

class ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  List<String> themeModeList = [locale.lblLight, locale.lblDark, locale.lblSystemDefault];

  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    currentIndex = getIntAsync(THEME_MODE_INDEX);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        themeModeList.length,
        (int index) {
          return Theme(
            data: ThemeData(unselectedWidgetColor: context.primaryColor),
            child: RadioListTile(
              value: index,
              dense: true,
              fillColor: MaterialStatePropertyAll(appPrimaryColor),
              groupValue: currentIndex,
              title: Text(themeModeList[index], style: primaryTextStyle()),
              onChanged: (dynamic val) {
                setState(() {
                  currentIndex = val;

                  if (val == THEME_MODE_SYSTEM) {
                    appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
                  } else if (val == THEME_MODE_LIGHT) {
                    appStore.setDarkMode(false);
                  } else {
                    if (val == THEME_MODE_DARK) {
                      appStore.setDarkMode(true);
                    }
                  }

                  setValue(THEME_MODE_INDEX, val);
                });

                finish(context);
              },
            ),
          );
        },
      ),
    );
  }
}
