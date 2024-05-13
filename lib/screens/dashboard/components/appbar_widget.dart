import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/app_bar_title_widget.dart';
import 'package:kivicare_flutter/components/dashboard_profile_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class AppbarWidget extends StatelessWidget {
  final VoidCallback? callback;
  AppbarWidget({this.callback});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return appBarWidget(
      '',
      titleWidget: AppBarTitleWidget(),
      showBack: false,
      color: context.scaffoldBackgroundColor,
      elevation: 0,
      systemUiOverlayStyle: defaultSystemUiOverlayStyle(
        context,
        color: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : appPrimaryColor.withOpacity(0.02),
        statusBarIconBrightness: appStore.isDarkModeOn ? Brightness.light : Brightness.dark,
      ),
      actions: [
        DashboardTopProfileWidget(
          refreshCallback: () => callback?.call(),
        ),
      ],
    );
  }
}
