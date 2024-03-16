import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/status_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/screens/auth/screens/edit_profile_screen.dart';
import 'package:momona_healthcare/screens/dashboard/screens/common_settings_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class EditProfileComponent extends StatelessWidget {
  final VoidCallback? refreshCallback;

  EditProfileComponent({this.refreshCallback});

  bool get showClinic {
    if (isReceptionist() || isPatient())
      return isVisible(SharedPreferenceKey.kiviCarePatientClinicKey) && userStore.userClinic != null;
    else
      return false;
  }

  bool get showEdit {
    if (isPatient())
      return isVisible(SharedPreferenceKey.kiviCarePatientProfileKey);
    else
      return true;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                if (userStore.profileImage.validate().isNotEmpty)
                  GradientBorder(
                      borderRadius: 65,
                      padding: 2,
                      gradient: LinearGradient(colors: [viewLineColor, viewLineColor]),
                      child: CachedImageWidget(url: userStore.profileImage.validate(), height: 65, circle: true, fit: BoxFit.cover))
                else
                  PlaceHolderWidget(
                    shape: BoxShape.circle,
                    height: 65,
                    width: 65,
                    border: Border.all(color: context.dividerColor, width: 2),
                    alignment: Alignment.center,
                    child: Text(userStore.firstName.validate(value: '')[0].capitalizeFirstLetter(), style: boldTextStyle(color: Colors.black, size: 20)),
                  ),
                if (showEdit)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: appPrimaryColor,
                        boxShape: BoxShape.circle,
                        border: Border.all(color: white, width: 3),
                      ),
                      child: Image.asset(ic_edit, height: 16, width: 16, color: Colors.white),
                    ),
                  )
              ],
            ),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getRoleWiseName(name: "${userStore.firstName.validate()} ${userStore.lastName.validate()}"),
                  style: boldTextStyle(size: titleTextSize),
                ),
                2.height,
                Text(userStore.userEmail.validate(), style: secondaryTextStyle()),
              ],
            ).expand(),
            ic_settings.iconImageColored(color: appStore.isDarkModeOn ? Colors.white : appSecondaryColor).paddingAll(14).appOnTap(() {
              CommonSettingsScreen().launch(context, duration: Duration(milliseconds: 600), pageRouteAnimation: pageAnimation);
            })
          ],
        ).appOnTap(
          () {
            if (showEdit)
              EditProfileScreen().launch(context, duration: Duration(milliseconds: 600), pageRouteAnimation: pageAnimation).then((value) {
                refreshCallback?.call();
              });
          },
        ),
        if (showClinic)
          Divider(
            height: 30,
            color: context.dividerColor,
          ),
        if (showClinic)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ic_clinicPlaceHolder.iconImageColored(size: 26),
                      Text(userStore.userClinic!.name.validate(), style: primaryTextStyle()).expand(),
                      StatusWidget(
                        status: userStore.userClinic!.status.validate(),
                        isClinicStatus: true,
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      )
                    ],
                  ),
                  if (userStore.userClinicAddress.validate().isNotEmpty) 6.height,
                  if (userStore.userClinicAddress.validate().isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ic_location.iconImage(size: 18).paddingOnly(top: 4, bottom: 4),
                        4.width,
                        Text(userStore.userClinicAddress.validate(), style: secondaryTextStyle()),
                      ],
                    ).paddingLeft(4)
                ],
              ).expand(),
            ],
          ).paddingSymmetric(vertical: 8)
      ],
    );
  }
}
