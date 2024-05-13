import 'package:flutter/material.dart';
import 'package:kivicare_flutter/utils/extensions/double_extension.dart';
import 'package:kivicare_flutter/utils/extensions/int_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class DisabledRatingBarWidget extends StatelessWidget {
  final num rating;
  final int? itemCount;
  final double? size;
  final bool showRatingText;

  final bool? allowHalfRating;

  DisabledRatingBarWidget({required this.rating, this.itemCount, this.size, this.showRatingText = false, this.allowHalfRating = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBarWidget(
          onRatingChanged: null,
          itemCount: itemCount ?? 5,
          size: size ?? 18,
          disable: true,
          allowHalfRating: true,
          rating: rating.validate().toDouble(),
          // activeColor: ratingBarColor,
          activeColor: rating.getRatingBarColor(),
        ),
        4.width,
        if (showRatingText)
          Text(
            rating.validate().toStringAsFixed(1).toString(),
            style: secondaryTextStyle(size: 14, color: rating.toInt().getRatingBarColor()),
          ),
      ],
    );
  }
}
