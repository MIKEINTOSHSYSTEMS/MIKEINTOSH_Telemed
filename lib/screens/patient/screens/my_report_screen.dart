import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/components/internet_connectivity_widget.dart';

// ignore: unused_import
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/report_model.dart';
import 'package:momona_healthcare/network/report_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/add_report_screen.dart';
import 'package:momona_healthcare/screens/encounter/component/report_component.dart';
import 'package:momona_healthcare/screens/shimmer/screen/report_shimmer_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class MyReportsScreen extends StatefulWidget {
  @override
  _MyReportsScreenState createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  Future<List<ReportData>>? future;

  List<ReportData> reportList = [];

  int total = 0;
  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init({showLoader = false}) async {
    if (showLoader) appStore.setLoading(true);
    future = getPatientReportListApi(
      patientId: userStore.userId,
      page: page,
      getTotalReport: (b) => total = b,
      lastPageCallback: (b) => isLastPage = b,
      reportList: reportList,
    ).then((value) {
      appStore.setLoading(false);
      setState(() {});
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      throw e;
    });
  }

  void deleteReportData(String? id) {
    appStore.setLoading(true);

    Map<String, dynamic> res = {"id": "$id"};
    deleteReportAPI(res).then((value) {
      toast(value.reportResponse?.message.validate());
      init(showLoader: true);
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
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
    return Scaffold(
      appBar: appBarWidget(locale.lblMyReports, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context), elevation: 0, color: appPrimaryColor),
      body: InternetConnectivityWidget(
        child: Stack(
          children: [
            SnapHelperWidget<List<ReportData>>(
              future: future,
              loadingWidget: ReportShimmerScreen(),
              errorWidget: ErrorStateWidget().center(),
              onSuccess: (snap) {
                return AnimatedScrollView(
                  listAnimationType: listAnimationType,
                  padding: EdgeInsets.only(bottom: 60, top: 16, left: 16, right: 16),
                  children: snap
                      .map(
                        (reportData) => ReportComponent(
                          reportData: reportData,
                          isForMyReportScreen: true,
                          showDelete: true,
                          refreshReportData: () {
                            init();
                          },
                          deleteReportData: () {
                            showConfirmDialogCustom(
                              context,
                              onAccept: (p0) {
                                deleteReportData(reportData.id.validate().toString());
                              },
                              dialogType: DialogType.DELETE,
                              title: locale.lblDoYouWantToDeleteReport,
                            );
                          },
                        ),
                      )
                      .toList(),
                ).visible(
                  snap.isNotEmpty,
                  defaultWidget: NoDataFoundWidget(text: locale.lblNoReportsFound).center(),
                );
              },
            ),
            Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading))
          ],
        ),
        retryCallback: () {
          setState(() {});
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddReportScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration),
        child: Icon(Icons.add),
      ).visible(!isPatient() && isVisible(SharedPreferenceKey.kiviCarePatientReportAddKey)),
    );
  }
}
