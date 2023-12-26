import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/network/doctor_list_repository.dart';
import 'package:kivicare_flutter/screens/patient/components/doctor_dashboard_widget.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/r_add_new_doctor.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class RDoctorListFragment extends StatefulWidget {
  @override
  _RDoctorListFragmentState createState() => _RDoctorListFragmentState();
}

class _RDoctorListFragmentState extends State<RDoctorListFragment> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(child: body()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await RAddNewDoctor(isUpdate: false).launch(context).then((value) {
            if (value ?? false) {
              init();
              setState(() {});
            }
          });
        },
      ),
    );
  }

  Widget body() {
    return SnapHelperWidget<List<DoctorList>>(
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
            Text('$TOTAL_DOCTOR ($total)', style: boldTextStyle(size: 18)),
            16.height,
            AnimatedListView(
              physics: NeverScrollableScrollPhysics(),
              itemCount: snap.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => DoctorDashboardWidget(data: snap[index], isBooking: false),
            ),
          ],
        );
      },
    );
  }
}
