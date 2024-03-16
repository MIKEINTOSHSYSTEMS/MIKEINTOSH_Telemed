import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/service_duration_model.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/network/service_repository.dart';
import 'package:momona_healthcare/screens/shimmer/screen/service_data_shimmer.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AvailableClinicListComponent extends StatefulWidget {
  final UserModel doctorData;
  final String serviceName;

  AvailableClinicListComponent({required this.doctorData, required this.serviceName});

  @override
  State<AvailableClinicListComponent> createState() => _AvailableClinicListComponentState();
}

class _AvailableClinicListComponentState extends State<AvailableClinicListComponent> {
  List<DurationModel> durationList = getServiceDuration();

  List<ServiceData> serviceList = [];
  List<ServiceData> dataList = [];

  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    appStore.setLoading(true);
    getClinicWiseDoctorsServiceData(serviceList: serviceList, page: page, serviceName: widget.serviceName, doctorId: widget.doctorData.doctorId).then((value) {
      if (page == 1) {
        dataList.clear();
      }
      dataList.addAll(value);
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      throw e;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Stack(
        children: [
          if (serviceList.isNotEmpty)
            AnimatedScrollView(
              crossAxisAlignment: CrossAxisAlignment.center,
              listAnimationType: ListAnimationType.None,
              padding: EdgeInsets.only(bottom: 70, left: 16, right: 16),
              children: [
                Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: List.generate(
                    serviceList.length,
                    (index) {
                      ServiceData serviceData = serviceList[index];
                      return Container(
                        width: context.width() / 2 - 24,
                        decoration: boxDecorationDefault(color: context.cardColor),
                        child: Column(
                          children: [
                            if (serviceData.image.validate().isNotEmpty)
                              Container(
                                height: 100,
                                width: context.width() / 2 - 24,
                                decoration: boxDecorationDefault(
                                  borderRadius: BorderRadius.only(topRight: radiusCircular(), topLeft: radiusCircular()),
                                  image: DecorationImage(image: NetworkImage(serviceData.image.validate()), fit: BoxFit.cover),
                                ),
                              )
                            else
                              PlaceHolderWidget(
                                child: Text(
                                  widget.serviceName.validate(),
                                  style: boldTextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                color: appStore.isDarkModeOn ? context.cardColor : null,
                                height: 100,
                                width: context.width() / 2 - 24,
                                alignment: Alignment.center,
                              ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
                            Divider(color: viewLineColor, height: 2).visible(appStore.isDarkModeOn && serviceData.image.validate().isEmpty),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Marquee(
                                  child: Text(
                                    serviceData.clinicName.validate(),
                                    style: primaryTextStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                  backDuration: Duration(milliseconds: 400),
                                  pauseDuration: pageAnimationDuration,
                                ),
                                8.height,
                                FittedBox(
                                  child: Row(
                                    children: [
                                      RichTextWidget(
                                        list: [
                                          TextSpan(text: '${appStore.currencyPrefix.validate()} ', style: primaryTextStyle(size: 14)),
                                          TextSpan(
                                            text: '${serviceData.charges}${appStore.currencyPostfix}',
                                            style: primaryTextStyle(size: 14),
                                          ),
                                        ],
                                      ),
                                      16.width,
                                      if (serviceData.duration.validate().isNotEmpty)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ic_timer.iconImage(color: appSecondaryColor, size: 16),
                                            2.width,
                                            FittedBox(
                                              child: Text(
                                                durationList.where((element) => element.value == serviceData.duration.toInt()).first.label.validate(),
                                                style: primaryTextStyle(size: 14),
                                              ),
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                                8.height,
                                if (serviceData.isTelemed.validate()) 4.height,
                                if (serviceData.isTelemed.validate())
                                  FittedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ic_telemed.iconImage(color: appSecondaryColor, size: 18),
                                        4.width,
                                        Text(
                                          locale.lblTelemedServiceAvailable,
                                          style: primaryTextStyle(size: 14),
                                        ).expand(),
                                      ],
                                    ),
                                  )
                              ],
                            ).paddingSymmetric(horizontal: 10, vertical: 10),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            )
          else
            NoDataWidget(title: ''),
          Observer(
            builder: (context) {
              return ServiceDataShimmer().visible(appStore.isLoading && dataList.isEmpty && page == 1);
            },
          ),
          Observer(
            builder: (context) {
              return LoaderWidget().visible(appStore.isLoading && dataList.isEmpty && page > 1);
            },
          )
        ],
      ),
    );
  }
}
