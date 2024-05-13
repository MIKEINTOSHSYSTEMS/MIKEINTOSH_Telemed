import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/empty_error_state_component.dart';
import 'package:kivicare_flutter/components/internet_connectivity_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/network/dashboard_repository.dart';
import 'package:kivicare_flutter/screens/patient/components/dashboard_fragment_news_component.dart';
import 'package:kivicare_flutter/screens/patient/screens/dashboard_fragment_doctor_service_component.dart';
import 'package:kivicare_flutter/screens/patient/components/dashboard_fragment_top_doctor_component.dart';
import 'package:kivicare_flutter/screens/patient/components/dashboard_fragment_upcoming_appointment_component.dart';
import 'package:kivicare_flutter/screens/patient/screens/patient_service_list_screen.dart';
import 'package:kivicare_flutter/screens/shimmer/screen/patient_dashboard_shimmer_screen.dart';
import 'package:kivicare_flutter/utils/cached_value.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:kivicare_flutter/model/dashboard_model.dart';

class PatientDashBoardFragment extends StatefulWidget {
  @override
  _PatientDashBoardFragmentState createState() => _PatientDashBoardFragmentState();
}

class _PatientDashBoardFragmentState extends State<PatientDashBoardFragment> {
  Future<DashboardModel>? future;

  @override
  void initState() {
    super.initState();
    if (getStringAsync(SharedPreferenceKey.cachedDashboardDataKey).validate().isNotEmpty) {
      setState(() {
        cachedPatientDashboardModel = DashboardModel.fromJson(jsonDecode(getStringAsync(SharedPreferenceKey.cachedDashboardDataKey)));
      });
    }
    init();
  }

  void init() async {
    appStore.setLoading(true);
    getUserDashBoardAPI().then((value) {
      setState(() {});
      appStore.setLoading(false);
      return value;
    });
    future = getUserDashBoardAPI().then((value) {
      setState(() {});
      appStore.setLoading(false);
      return value;
    }) /*.catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    })*/
        ;
  }

  bool get showAppointment {
    return isVisible(SharedPreferenceKey.kiviCareAppointmentListKey);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InternetConnectivityWidget(
      retryCallback: () async {
        init();
        await 1.seconds.delay;
      },
      child: SnapHelperWidget<DashboardModel>(
        future: future,
        initialData: cachedPatientDashboardModel,
        errorBuilder: (error) {
          return NoDataWidget(
            imageWidget: Image.asset(ic_somethingWentWrong, height: 180, width: 180),
            title: error.toString(),
          );
        },
        errorWidget: ErrorStateWidget(),
        loadingWidget: PatientDashboardShimmerScreen(),
        onSuccess: (snap) {
          return AnimatedScrollView(
            listAnimationType: listAnimationType,
            onSwipeRefresh: () async {
              init();
            },
            padding: EdgeInsets.only(bottom: 80),
            children: [
              DashboardFragmentDoctorServiceComponent(service: getRemovedDuplicateServiceList(snap.serviceList.validate())),
              if (snap.upcomingAppointment.validate().isNotEmpty && showAppointment) DashBoardFragmentUpcomingAppointmentComponent(upcomingAppointment: snap.upcomingAppointment.validate()),
              16.height,
              DashBoardFragmentTopDoctorComponent(doctorList: snap.doctor.validate()),
              24.height,
              DashBoardFragmentNewsComponent(newsList: snap.news.validate()),
            ],
          ).visible(!appStore.isLoading, defaultWidget: PatientDashboardShimmerScreen().visible(appStore.isLoading));
        },
      ),
    );
  }
}
