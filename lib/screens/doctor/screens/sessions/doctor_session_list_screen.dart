import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/components/internet_connectivity_widget.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_session_model.dart';
import 'package:momona_healthcare/network/doctor_sessions_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/sessions/add_session_screen.dart';
import 'package:momona_healthcare/screens/doctor/screens/sessions/components/session_widget.dart';
import 'package:momona_healthcare/screens/shimmer/screen/session_shimmer_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorSessionListScreen extends StatefulWidget {
  @override
  _DoctorSessionListScreenState createState() => _DoctorSessionListScreenState();
}

class _DoctorSessionListScreenState extends State<DoctorSessionListScreen> {
  Future<DoctorSessionModel>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init({bool showLoader = false}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }

    future = getDoctorSessionDataAPI(clinicId: isReceptionist() ? userStore.userClinicId : null).whenComplete(() {
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
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
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: appBarWidget(isReceptionist() ? locale.lblDoctorSessions : locale.lblSessions, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
        body: InternetConnectivityWidget(
          retryCallback: () {
            setState(() {});
          },
          child: Stack(
            children: [
              SnapHelperWidget<DoctorSessionModel>(
                future: future,
                loadingWidget: SessionShimmerScreen(),
                errorWidget: ErrorStateWidget(),
                onSuccess: (data) {
                  if (data.sessionData.validate().isEmpty) return NoDataFoundWidget(text: locale.lblNoSessionAvailable).center();
                  return AnimatedScrollView(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
                    disposeScrollController: true,
                    listAnimationType: listAnimationType,
                    physics: AlwaysScrollableScrollPhysics(),
                    slideConfiguration: SlideConfiguration(verticalOffset: 400),
                    onSwipeRefresh: () async {
                      init();
                      return await 2.seconds.delay;
                    },
                    children: [
                      if (isVisible(SharedPreferenceKey.kiviCareDoctorSessionEditKey) || isVisible(SharedPreferenceKey.kiviCareDoctorSessionDeleteKey))
                        Text('${locale.lblNote} : ${locale.lblSwipeLeftToEdit}', style: secondaryTextStyle(size: 10, color: appSecondaryColor)),
                      8.height,
                      ...data.sessionData
                          .validate()
                          .map<Widget>(
                            (sessionData) => SessionWidget(
                              data: sessionData,
                              callForRefresh: () {
                                init(showLoader: true);
                              },
                            ).paddingSymmetric(vertical: 8),
                          )
                          .toList()
                    ],
                  );
                },
              ),
              LoaderWidget().center().visible(appStore.isLoading)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            if (appStore.isConnectedToInternet) {
              await AddSessionsScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                if (value != null) {
                  if (value ?? false) {
                    init(showLoader: true);
                  }
                }
              });
            } else {
              toast(locale.lblNoInternetMsg);
            }
          },
        ).visible(isVisible(SharedPreferenceKey.kiviCareDoctorSessionAddKey)),
      );
    });
  }
}
