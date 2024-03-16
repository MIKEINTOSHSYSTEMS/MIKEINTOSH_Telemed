import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/upcoming_appointment_model.dart';
import 'package:momona_healthcare/network/appointment_repository.dart';
import 'package:momona_healthcare/screens/appointment/appointment_functions.dart';
import 'package:momona_healthcare/screens/appointment/components/appointment_widget.dart';
import 'package:momona_healthcare/screens/doctor/fragments/appointment_fragment.dart';
import 'package:momona_healthcare/components/appointment_fragment_status_compoent.dart';
import 'package:momona_healthcare/screens/shimmer/screen/appointment_fragment_shimmer.dart';
import 'package:momona_healthcare/utils/cached_value.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class RAppointmentFragment extends StatefulWidget {
  @override
  State<RAppointmentFragment> createState() => _RAppointmentFragmentState();
}

class _RAppointmentFragmentState extends State<RAppointmentFragment> {
  Future<List<UpcomingAppointmentModel>>? future;

  StreamSubscription? updateAppointmentApi;

  List<UpcomingAppointmentModel> appointmentList = [];

  DateTime current = DateTime.now();

  int selectIndex = 0;
  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    appStore.setStatus('All');
    if (appStore.isLoading) {
      appStore.setLoading(false);
    }
    updateAppointmentApi = appointmentStreamController.stream.listen((streamData) {
      page = 1;
      init();
      setState(() {});
    });

    init();
  }

  void init({bool showLoader = false}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }
    future = getReceptionistAppointmentList(
      status: appStore.mStatus,
      page: page,
      appointmentList: appointmentList,
      lastPageCallback: (p0) => isLastPage,
    ).then((value) {
      appStore.setLoading(false);
      setState(() {});
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
      throw e;
    });
  }

  Future<void> changeStatus(int index) async {
    if (index == 0) {
      appStore.setStatus('All');
    } else if (index == 1) {
      appStore.setStatus('1');
    } else if (index == 2) {
      appStore.setStatus('2');
    } else if (index == 3) {
      appStore.setStatus('3');
    } else if (index == 4) {
      appStore.setStatus('0');
    } else if (index == 5) {
      appStore.setStatus('Past');
    }
    page = 1;
    init();
  }

  Future<void> _onSwipeRefresh() async {
    {
      setState(() {
        page = 1;
      });
      init();

      return await 1.seconds.delay;
    }
  }

  void _onNextPage() {
    if (!isLastPage) {
      setState(() {
        page++;
      });
      init();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String getEmptyText() {
    if (selectIndex == 0) {
      return locale.lblNoAppointmentsFound;
    } else if (selectIndex == 1) {
      return locale.lblNoLatestAppointmentFound;
    } else if (selectIndex == 2) {
      return locale.lblNoPendingAppointmentFound;
    } else if (selectIndex == 3) {
      return locale.lblNoCompletedAppointmentFound;
    } else if (selectIndex == 4) {
      return locale.lblNoCancelledAppointmentFound;
    } else if (selectIndex == 5) {
      return locale.lblNoAppointmentsFound;
    } else {
      return locale.lblNoAppointmentsFound;
    }
  }

  @override
  void dispose() {
    if (updateAppointmentApi != null) {
      updateAppointmentApi!.cancel().then((value) {
        log("============== Stream Cancelled ==============");
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        body: Stack(
          children: [
            AppointmentFragmentStatusComponent(
              selectedIndex: selectIndex,
              callForStatusChange: (index) {
                appStore.setLoading(true);
                selectIndex = index;
                changeStatus(index);
                setState(() {});
              },
            ),
            SnapHelperWidget<List<UpcomingAppointmentModel>>(
              future: future,
              initialData: cachedReceptionistAppointment,
              loadingWidget: AppointmentFragmentShimmer(),
              errorBuilder: (error) {
                return NoDataWidget(
                  imageWidget: Image.asset(
                    ic_somethingWentWrong,
                    height: 180,
                    width: 180,
                  ),
                  title: error.toString(),
                );
              },
              errorWidget: ErrorStateWidget(),
              onSuccess: (snap) {
                return AnimatedScrollView(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 80),
                  disposeScrollController: true,
                  onSwipeRefresh: () => _onSwipeRefresh(),
                  onNextPage: () => _onNextPage(),
                  listAnimationType: listAnimationType,
                  slideConfiguration: SlideConfiguration(verticalOffset: 400),
                  children: snap.map((upcomingData) {
                    return AppointmentWidget(
                      upcomingData: upcomingData,
                      refreshCall: () {
                        appointmentStreamController.add(true);
                        init(showLoader: true);
                      },
                    ).paddingSymmetric(vertical: 8);
                  }).toList(),
                ).visible(snap.isNotEmpty, defaultWidget: NoDataFoundWidget(text: getEmptyText()).center().visible(snap.isEmpty && !appStore.isLoading));
              },
            ).paddingTop(100),
            LoaderWidget().visible(appStore.isLoading).center()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await appointmentWidgetNavigation(context).whenComplete(() {
              init(showLoader: true);
            });
          },
        ).visible(isVisible(SharedPreferenceKey.kiviCareAppointmentAddKey)),
      );
    });
  }
}
