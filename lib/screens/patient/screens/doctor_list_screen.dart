import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/network/doctor_list_repository.dart';
import 'package:kivicare_flutter/screens/patient/components/doctor_dashboard_widget.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  Future<List<DoctorList>>? future;

  List<DoctorList> doctorList = [];

  int total = 0;
  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    future = getDoctorListNew1(page: page, doctorList: doctorList, getTotalDoctor: (b) => total = b, lastPageCallback: (b) => isLastPage = b);
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
    return Scaffold(
      appBar: appBarWidget(locale.lblClinicDoctor, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Body(
        child: SnapHelperWidget<List<DoctorList>>(
          future: future,
          loadingWidget: LoaderWidget(),
          onSuccess: (snap) {
            if (snap.isEmpty) {
              return NoDataFoundWidget(text: locale.lblNoDataFound);
            }

            return AnimatedScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              disposeScrollController: true,
              padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
              listAnimationType: ListAnimationType.FadeIn,
              slideConfiguration: SlideConfiguration(verticalOffset: 400),
              onSwipeRefresh: () async {
                page = 1;
                init();
                return await 2.seconds.delay;
              },
              onNextPage: () {
                if (!isLastPage) {
                  page++;
                  init();
                  setState(() {});
                }
              },
              children: [
                Text('$TOTAL_DOCTOR (${doctorList.length})', style: boldTextStyle(size: 16)),
                8.height,
                if (doctorList.isNotEmpty)
                  AnimatedWrap(
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      return DoctorDashboardWidget(data: snap[index]);
                    },
                  ),
              ],
            );
          },
        ),
      ),
      // ListView(
      //   padding: EdgeInsets.all(16),
      //   children: [
      //     NotificationListener(
      //       onNotification: (dynamic n) {
      //         if (!isLastPage && isReady) {
      //           if (n is ScrollEndNotification) {
      //             page++;
      //             isReady = false;
      //
      //             setState(() {});
      //           }
      //         }
      //         return !isLastPage;
      //       },
      //       child: FutureBuilder<DoctorListModel>(
      //         future: getDoctorList(page: page),
      //         builder: (_, snap) {
      //           if (snap.hasData) {
      //             if (page == 1) doctorList.clear();
      //             doctorList.addAll(snap.data!.doctorList!);
      //             isReady = true;
      //             isLastPage = snap.data!.total.validate() <= doctorList.length;
      //
      //             if (doctorList.isNotEmpty) {
      //               return Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text('$TOTAL_DOCTOR (${doctorList.length})', style: boldTextStyle(size: 16)),
      //                   8.height,
      //                   Wrap(
      //                     runSpacing: 4,
      //                     spacing: 16,
      //                     children: snap.data!.doctorList!.map((e) => DoctorDashboardWidget(data: e)).toList(),
      //                   ),
      //                 ],
      //               );
      //             } else {
      //               return NoDataFoundWidget(text: locale.lblNoDataFound, iconSize: 130).center();
      //             }
      //           }
      //           return snapWidgetHelper(snap);
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
