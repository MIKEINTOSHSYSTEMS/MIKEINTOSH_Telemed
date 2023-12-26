import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/screens/patient/screens/doctor_details_screen.dart';
import 'package:kivicare_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorDashboardWidget extends StatelessWidget {
  final DoctorList data;
  final bool isBooking;

  DoctorDashboardWidget({required this.data, this.isBooking = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          data.profile_image == null
              ? Image.asset(data.profileImage, height: 100, width: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius)
              : CachedImageWidget(height: 100, width: 100, fit: BoxFit.cover, url: data.profile_image.validate(), radius: defaultRadius),
          24.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Text("Dr. ${data.display_name.validate()}", style: boldTextStyle(size: 16)),
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
