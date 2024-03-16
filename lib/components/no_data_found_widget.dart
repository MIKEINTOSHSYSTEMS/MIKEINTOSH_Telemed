import 'package:flutter/material.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String? text;
  final String? retryText;
  final double? iconSize;
  final String? image;
  final VoidCallback? onRetry;

  NoDataFoundWidget({this.text, this.image, this.iconSize, this.retryText, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return NoDataWidget(
      image: image ?? noDataFound,
      title: text ?? locale.lblNoMatch,
      retryText: retryText,
      onRetry: onRetry,
      imageSize: Size(iconSize ?? 150, iconSize ?? 150),
    );
  }
}
