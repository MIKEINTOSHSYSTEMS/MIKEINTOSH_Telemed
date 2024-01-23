import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

AppBar appAppBar(BuildContext context, {String? name, String? names, SystemUiOverlayStyle? systemOverlayStyle, Widget? leading, List<Widget>? actions, double? elevation}) {
  return AppBar(
    actions: actions,
    leading: leading ??
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            finish(context);
          },
        ),
    systemOverlayStyle: systemOverlayStyle,
    elevation: elevation.validate(value: 4.0),
    shadowColor: shadowColorGlobal,
    backgroundColor: appPrimaryColor,
    title: Text(names ?? name.validate(value: locale.lblNameIsMissing)),
    titleSpacing: 0,
  );
}
