import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class EmptyStateWidget extends StatelessWidget {
  final double? height;
  final double? width;
  Widget? imageWidget;
  String? emptyWidgetTitle;

  EmptyStateWidget({this.height, this.width, this.imageWidget, this.emptyWidgetTitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: NoDataWidget(
        imageWidget: imageWidget ?? Image.asset(noDataFound, height: 100),
        title: emptyWidgetTitle ?? locale.lblNoDataFound,
      ),
    ).center();
  }
}

class ErrorStateWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String? error;

  const ErrorStateWidget({this.height, this.width, this.error});

  @override
  Widget build(BuildContext context) {
    if (!appStore.isConnectedToInternet)
      return Image.asset(ic_no_internet_screen, height: 180).center();
    else
      return NoDataWidget(
        title: error,
        imageWidget: Image.asset(ic_somethingWentWrong, height: 180, width: 180).center(),
      );
  }
}
