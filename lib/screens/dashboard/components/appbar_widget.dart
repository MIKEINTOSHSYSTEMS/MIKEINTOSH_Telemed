import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/app_bar_title_widget.dart';
import 'package:momona_healthcare/components/dashboard_profile_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
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
