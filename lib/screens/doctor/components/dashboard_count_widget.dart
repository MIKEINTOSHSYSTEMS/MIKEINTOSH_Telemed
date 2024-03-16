import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momona_healthcare/components/price_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class DashBoardCountWidget extends StatelessWidget {
  final String? title;

  final int? count;
  final Color? color1;
  final bool? isPrice;
  final double? width;

  final IconData? icon;

  DashBoardCountWidget({this.title, this.count, this.color1, this.icon, this.isPrice, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? context.width() / 3 - 20,
      height: 120,
      alignment: Alignment.center,
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              24.height,
              isPrice.validate(value: false)
                  ? PriceWidget(price: count.validate().toString(), textStyle: boldTextStyle(size: 24))
                  : Text(
                      count?.toString() ?? 1.toString(),
                      style: boldTextStyle(size: 24),
                    ).expand(),
              5.height,
              Marquee(
                child: Text(
                  title ?? locale.lblTotalPatient.toUpperCase(),
                  style: secondaryTextStyle(
                    size: 14,
                  ),
                ),
              ),
            ],
          ).paddingOnly(top: 16, left: 8, right: 8, bottom: 16),
          Positioned(
            top: -28,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: boxDecorationWithShadow(
                boxShape: BoxShape.circle,
                boxShadow: null,
                backgroundColor: color1 ?? appPrimaryColor,
              ),
              child: FaIcon(icon ?? FontAwesomeIcons.userInjured, color: Colors.white).center(),
            ),
          ),
        ],
      ),
    );
  }
}
