import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:momona_healthcare/network/doctor_sessions_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/sessions/add_session_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';

import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_session_model.dart';
import 'package:momona_healthcare/utils/images.dart';

class SessionWidget extends StatelessWidget {
  final SessionData data;
  final VoidCallback? callForRefresh;

  const SessionWidget({required this.data, this.callForRefresh});

  void deleteSession() async {
    appStore.setLoading(true);

    Map request = {"id": "${data!.id}"};
    await deleteDoctorSessionDataAPI(request).then((value) {
      appStore.setLoading(false);
      toast(locale.lblSessionDeleted);
      callForRefresh?.call();
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  bool get isEdit {
    return isVisible(SharedPreferenceKey.kiviCareDoctorSessionEditKey);
  }

  bool get isDelete {
    return isVisible(SharedPreferenceKey.kiviCareDoctorSessionDeleteKey);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Slidable(
        enabled: isEdit || isDelete,
        key: ValueKey(data.id.toInt()),
        endActionPane: ActionPane(
          extentRatio: 0.6,
          motion: ScrollMotion(),
          children: [
            if (isEdit)
              SlidableAction(
                onPressed: (BuildContext context) {
                  AddSessionsScreen(sessionData: data).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                    if (value ?? false) {
                      callForRefresh?.call();
                    }
                  });
                },
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                borderRadius: isDelete ? BorderRadius.only(topLeft: Radius.circular(defaultRadius), bottomLeft: Radius.circular(defaultRadius)) : BorderRadius.circular(defaultRadius),
                icon: Icons.edit,
                label: locale.lblEdit,
              ),
            if (isDelete)
              SlidableAction(
                borderRadius: isEdit ? BorderRadius.only(topRight: Radius.circular(defaultRadius), bottomRight: Radius.circular(defaultRadius)) : BorderRadius.circular(defaultRadius),
                onPressed: (context) {
                  showConfirmDialogCustom(
                    context,
                    title: locale.lblDoYouWantToDeleteSession,
                    dialogType: DialogType.DELETE,
                    onAccept: (p0) {
                      deleteSession();
                    },
                  );
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: locale.lblDelete,
              )
          ],
        ),
        child: Container(
          decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: isReceptionist() ? 20 : 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (isReceptionist())
                    data.doctorImage.validate().isNotEmpty
                        ? CachedImageWidget(
                            url: data.doctorImage.validate(),
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            radius: 80,
                          )
                        : GradientBorder(
                            gradient: LinearGradient(colors: [primaryColor, appSecondaryColor], tileMode: TileMode.mirror),
                            strokeWidth: 2,
                            borderRadius: 80,
                            child: PlaceHolderWidget(
                              height: 40,
                              width: 40,
                              shape: BoxShape.circle,
                              alignment: Alignment.center,
                              child: Text('${data.doctors.validate(value: 'D')[0].capitalizeFirstLetter()}', style: boldTextStyle(size: 22, color: Colors.black)),
                            ),
                          ),
                  if (isReceptionist()) 16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isReceptionist()) Text(data.doctors.validate().prefixText(value: "Dr. "), style: boldTextStyle()),
                      2.height,
                      if (!isReceptionist()) Text(data.clinicName.validate(), style: isReceptionist() ? secondaryTextStyle() : boldTextStyle()),
                      6.height,
                      Text(
                        '${data.days.validate().join(" - ")}'.toUpperCase(),
                        style: secondaryTextStyle(size: 12, color: context.primaryColor),
                      )
                    ],
                  ).expand(),
                ],
              ),
              16.height,
              Container(
                decoration: boxDecorationDefault(borderRadius: radius(), color: context.scaffoldBackgroundColor),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ic_morning.iconImage(size: 18, color: Colors.orange).paddingOnly(top: 4),
                          12.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(locale.lblMorning, style: secondaryTextStyle()),
                              4.height,
                              Text(data.morningTime, style: boldTextStyle(size: 14)),
                            ],
                          ).expand(),
                        ],
                      ),
                    ).expand(),
                    8.width,
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ic_evening.iconImage(size: 18, color: Colors.red).paddingOnly(top: 4),
                          12.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(locale.lblEvening, style: secondaryTextStyle()),
                              4.height,
                              Text(data.eveningTime, style: boldTextStyle(size: 14)),
                            ],
                          ).expand(),
                        ],
                      ),
                    ).expand()
                  ],
                ),
              ),
              if (isDoctor()) 8.height,
            ],
          ),
        ).appOnTap(
          () {
            if (isEdit) {
              AddSessionsScreen(sessionData: data).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                if (value ?? false) {
                  callForRefresh?.call();
                }
              });
            }
          },
        ),
      );
    });
  }
}
