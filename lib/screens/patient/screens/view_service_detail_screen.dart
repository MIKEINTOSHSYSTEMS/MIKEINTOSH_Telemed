import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/service_model.dart';
import 'package:kivicare_flutter/model/static_data_model.dart';
import 'package:kivicare_flutter/screens/patient/components/clinic_list_component.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/doctor/doctor_details_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewServiceDetailScreen extends StatefulWidget {
  final ServiceData serviceData;

  ViewServiceDetailScreen({required this.serviceData});

  @override
  State<ViewServiceDetailScreen> createState() => _ViewServiceDetailScreenState();
}

class _ViewServiceDetailScreenState extends State<ViewServiceDetailScreen> {
  Future<StaticDataModel>? future;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(appPrimaryColor);
    init();
  }

  void init() {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        widget.serviceData.name.validate(),
        textColor: Colors.white,
      ),
      body: AnimatedScrollView(
        padding: EdgeInsets.only(bottom: 60, left: 16, right: 16, top: 16),
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(text: locale.lblCategory, style: secondaryTextStyle(size: 16)),
              TextSpan(text: " : " + widget.serviceData.type.validate().replaceAll(RegExp('[^A-Za-z]'), ' ').capitalizeEachWord(), style: primaryTextStyle()),
            ]),
          ),
          16.height,
          Text(widget.serviceData.doctorList.validate().length > 1 ? locale.lblAvailableDoctors : locale.lblAvailableDoctor, style: primaryTextStyle()),
          16.height,
          AnimatedWrap(
            runSpacing: 16,
            spacing: 16,
            listAnimationType: listAnimationType,
            children: widget.serviceData.doctorList.validate().map((doctorData) {
              return Container(
                width: context.width() / 2 - 24,
                decoration: boxDecorationDefault(color: context.cardColor),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (doctorData.profileImage.validate().isNotEmpty)
                      CachedImageWidget(
                        url: doctorData.profileImage.validate(),
                        fit: BoxFit.cover,
                        width: context.width() / 2 - 24,
                        height: 100,
                      ).cornerRadiusWithClipRRectOnly(topLeft: defaultRadius.toInt(), topRight: defaultRadius.toInt()).appOnTap(() {
                        DoctorDetailScreen(doctorData: doctorData).launch(context, pageRouteAnimation: pageAnimation, duration: 800.milliseconds);
                      })
                    else
                      PlaceHolderWidget(
                        width: context.width() / 2 - 24,
                        borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
                        alignment: Alignment.center,
                        child: Text(doctorData.displayName.validate().isNotEmpty ? doctorData.displayName.validate()[0] : '',
                            style: boldTextStyle(color: appStore.isDarkModeOn ? Colors.white : Colors.black, size: titleTextSize)),
                        height: 100,
                        color: appStore.isDarkModeOn ? context.cardColor : null,
                      ).appOnTap(() {
                        DoctorDetailScreen(doctorData: doctorData).launch(context, pageRouteAnimation: pageAnimation, duration: 800.milliseconds);
                      }),
                    Divider(color: viewLineColor, height: 2).visible(appStore.isDarkModeOn && doctorData.profileImage.validate().isEmpty),
                    Column(
                      children: [
                        Text(
                          doctorData.displayName.validate().prefixText(value: 'Dr. '),
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        4.height,
                        FittedBox(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                locale.lblAvailableAtClinics,
                                style: secondaryTextStyle(
                                  decoration: TextDecoration.underline,
                                  color: appPrimaryColor,
                                  decorationColor: appPrimaryColor,
                                ),
                              ),
                              1.width,
                              Icon(Icons.visibility_outlined, color: appPrimaryColor, size: 16),
                            ],
                          ).appOnTap(() {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: context.scaffoldBackgroundColor,
                              constraints: BoxConstraints(maxWidth: context.width(), maxHeight: context.height() * 0.7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: radiusCircular(), topLeft: radiusCircular())),
                              isScrollControlled: true,
                              showDragHandle: true,
                              builder: (context) {
                                return AvailableClinicListComponent(
                                  doctorData: doctorData,
                                  serviceName: widget.serviceData.name.validate(),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
