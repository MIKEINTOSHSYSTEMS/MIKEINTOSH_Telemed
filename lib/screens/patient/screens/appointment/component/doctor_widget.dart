import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/screens/patient/screens/doctor_details_screen.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorWidget extends StatelessWidget {
  final DoctorList data;
  final bool isSelected;

  const DoctorWidget({Key? key, required this.data, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: BorderRadius.circular(defaultRadius),
        backgroundColor: isSelected ? selectedColor : context.cardColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedImageWidget(url: data.profile_image.validate(), height: 100, radius: defaultRadius, fit: BoxFit.cover),
          24.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Text("Dr. ${data.display_name.validate()}", style: boldTextStyle(size: 18)),
              6.height,
              Text(
                data.specialties.validate().isNotEmpty ? data.specialties.validate() : 'NA',
                style: secondaryTextStyle(),
              ),
              8.height,
              AppButton(
                padding: EdgeInsets.symmetric(horizontal: 42),
                text: locale.lblViewDetails,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                textStyle: primaryTextStyle(color: white),
                color: context.primaryColor,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return DoctorDetailScreen(data: data);
                    },
                  );
                },
              )
            ],
          ).expand(),
        ],
      ),
    );
  }
}
