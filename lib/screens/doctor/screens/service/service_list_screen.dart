import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/components/internet_connectivity_widget.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/service_duration_model.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/network/service_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/service/components/service_widget.dart';
import 'package:momona_healthcare/screens/shimmer/components/services_shimmer_component.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import 'add_service_screen.dart';

class ServiceListScreen extends StatefulWidget {
  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  Future<List<ServiceData>>? future;

  TextEditingController searchCont = TextEditingController();

  List<ServiceData> serviceList = [];
  int total = 0;
  int page = 1;

  bool isLastPage = false;
  bool showClear = false;
  List<DurationModel> durationList = getServiceDuration();

  @override
  void initState() {
    super.initState();
    init(showLoader: false);
  }

  Future<void> init({bool showLoader = true}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }

    future = getServiceListAPI(
      searchString: searchCont.text,
      id: isReceptionist() ? userStore.userClinicId.validate().toInt() : userStore.userId.validate(),
      perPages: 50,
      page: page,
      lastPageCallback: (b) => isLastPage = b,
    ).then((value) {
      appStore.setLoading(false);
      if (searchCont.text.isNotEmpty) {
        showClear = true;
      } else {
        showClear = false;
      }
      setState(() {});
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
      throw e;
    });
  }

  Future<void> _onClearSearch() async {
    hideKeyboard(context);

    searchCont.clear();
    init(showLoader: true);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ServiceListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: appBarWidget(
          locale.lblServices,
          textColor: Colors.white,
          systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
          actions: [],
        ),
        body: InternetConnectivityWidget(
          retryCallback: () async {
            init();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: searchCont,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(
                      context: context,
                      hintText: locale.lblSearchServices,
                      prefixIcon: ic_search.iconImage().paddingAll(16),
                      suffixIcon: !showClear
                          ? Offstage()
                          : ic_clear.iconImage().paddingAll(16).appOnTap(
                              () async {
                                _onClearSearch();
                              },
                              borderRadius: radius(),
                            ),
                    ),
                    onChanged: (newValue) {
                      if (newValue.isEmpty) {
                        showClear = false;
                        _onClearSearch();
                      } else {
                        Timer(pageAnimationDuration, () {
                          init(showLoader: true);
                        });
                        showClear = true;
                      }
                      setState(() {});
                    },
                    onFieldSubmitted: (searchString) async {
                      hideKeyboard(context);
                      init(showLoader: true);
                    },
                  ),
                  16.height,
                  Text('${locale.lblNote} : ${locale.lblTapMsg}', style: secondaryTextStyle(size: 10, color: appSecondaryColor)),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 16),
              SnapHelperWidget<List<ServiceData>>(
                future: future,
                errorBuilder: (p0) {
                  return ErrorStateWidget(
                    error: p0.toString(),
                  );
                },
                loadingWidget: AnimatedWrap(
                  runSpacing: 16,
                  spacing: 16,
                  listAnimationType: listAnimationType,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: List.generate(
                    4,
                    (index) => ServicesShimmerComponent(isForDoctorServicesList: isDoctor()),
                  ),
                ).paddingSymmetric(horizontal: 16, vertical: 16),
                onSuccess: (snap) {
                  if (snap.isEmpty && !appStore.isLoading) {
                    return SingleChildScrollView(
                      child: NoDataFoundWidget(
                        iconSize: searchCont.text.isNotEmpty && appStore.isLoading ? 60 : 160,
                        text: searchCont.text.isNotEmpty ? locale.lblCantFindServiceYouSearchedFor : locale.lblNoServicesFound,
                      ),
                    ).center();
                  }

                  return AnimatedScrollView(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 120),
                      disposeScrollController: true,
                      listAnimationType: ListAnimationType.None,
                      physics: AlwaysScrollableScrollPhysics(),
                      slideConfiguration: SlideConfiguration(verticalOffset: 400),
                      onSwipeRefresh: () async {
                        setState(() {
                          page = 1;
                        });
                        init(showLoader: false);
                        return await 1.seconds.delay;
                      },
                      onNextPage: () async {
                        if (!isLastPage) {
                          setState(() {
                            page++;
                          });
                          init(showLoader: true);
                          await 1.seconds.delay;
                        }
                      },
                      children: isDoctor()
                          ? List.generate(groupServicesByClinicId(serviceList: snap).keys.length, (index) {
                              String title = groupServicesByClinicId(serviceList: snap).keys.toList()[index].toString();
                              return SettingSection(
                                headingDecoration: BoxDecoration(),
                                headerPadding: EdgeInsets.zero,
                                divider: Divider(
                                  height: 28,
                                  color: appStore.isDarkModeOn ? Colors.white24 : context.dividerColor,
                                ),
                                title: Marquee(
                                  child: RichTextWidget(list: [TextSpan(text: locale.lblClinic + ' - ', style: primaryTextStyle()), TextSpan(text: title, style: primaryTextStyle())]),
                                ),
                                items: [
                                  AnimatedWrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    direction: Axis.horizontal,
                                    listAnimationType: listAnimationType,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    itemCount: groupServicesByClinicId(serviceList: snap).values.toList()[index].length,
                                    itemBuilder: (p0, i) {
                                      ServiceData data = groupServicesByClinicId(serviceList: snap).values.toList()[index][i];
                                      return GestureDetector(
                                        onTap: () async {
                                          if (isVisible(SharedPreferenceKey.kiviCareServiceEditKey))
                                            await AddServiceScreen(
                                                serviceData: data,
                                                serviceList: snap,
                                                callForRefresh: () {
                                                  init();
                                                }).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                                              if (value ?? false) {
                                                init();
                                              }
                                            });
                                        },
                                        child: ServiceWidget(data: data),
                                      );
                                    },
                                  )
                                ],
                              ).paddingSymmetric(vertical: 12);
                            })
                          : [
                              AnimatedWrap(
                                spacing: 16,
                                runSpacing: 16,
                                direction: Axis.horizontal,
                                listAnimationType: listAnimationType,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                itemCount: snap.length,
                                itemBuilder: (p0, index) {
                                  ServiceData data = snap[index];

                                  return GestureDetector(
                                    onTap: () async {
                                      if (isVisible(SharedPreferenceKey.kiviCareServiceEditKey))
                                        await AddServiceScreen(
                                            serviceData: data,
                                            callForRefresh: () {
                                              init();
                                            }).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                                          if (value ?? false) {
                                            init();
                                          }
                                        });
                                    },
                                    child: ServiceWidget(data: data),
                                  );
                                },
                              ),
                            ]);
                },
              ).paddingTop(isDoctor() ? 102 : 100),
              LoaderWidget().visible(appStore.isLoading).center()
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            if (appStore.isConnectedToInternet) {
              await AddServiceScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                if (value ?? false) {
                  init();
                  setState(() {});
                }
              });
            } else {
              toast(locale.lblNoInternetMsg);
            }
          },
        ).visible(isVisible(SharedPreferenceKey.kiviCareServiceAddKey)),
      );
    });
  }
}

Map<String, List<ServiceData>> groupServicesByClinicId({required List<ServiceData> serviceList}) {
  return groupBy(serviceList, (ServiceData service) => service.clinicName.validate());
}
