import 'package:flutter/material.dart';
import 'package:kivicare_flutter/model/patient_dashboard_model.dart';
import 'package:kivicare_flutter/utils/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryWidget extends StatelessWidget {
  final Service data;
  final int index;
  final double? width;

  const CategoryWidget({Key? key, required this.data, required this.index, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String image = getServicesImages()[index % getServicesImages().length];

    return Container(
      width: width ?? context.width() / 4 - 18,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: context.cardColor),
            child: Image.asset(image, height: 36),
          ),
          8.height,
          Marquee(child: Text(data.name.validate(), textAlign: TextAlign.center, style: secondaryTextStyle())),
        ],
      ),
    );
  }
}
