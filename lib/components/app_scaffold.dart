import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import 'body_widget.dart';

class AppScaffold extends StatelessWidget {
  final String? appBarTitle;
  final List<Widget>? actions;
  final Widget child;
  final Color? scaffoldBackgroundColor;
  final Color? textColor;
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  AppScaffold({this.appBarTitle, required this.child, this.actions, this.scaffoldBackgroundColor, this.systemUiOverlayStyle, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        appBarTitle.validate(),
        elevation: 0.0,
        color: context.primaryColor,
        actions: actions,
        systemUiOverlayStyle: systemUiOverlayStyle,
        textColor: textColor,
      ),
      backgroundColor: scaffoldBackgroundColor,
      body: Body(child: child),
    );
  }
}
