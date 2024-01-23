import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/body_widget.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/patient_list_model.dart';
import 'package:momona_healthcare/network/patient_list_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/add_patient_screen.dart';
import 'package:momona_healthcare/screens/receptionist/components/r_patient_list_slidable_component.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientFragment extends StatefulWidget {
  @override
  _PatientFragmentState createState() => _PatientFragmentState();
}

class _PatientFragmentState extends State<PatientFragment> {
  Future<List<PatientData>>? future;

  List<PatientData> patientList = [];

  int total = 0;
  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    future = getPatientListNew(page: page, patientList: patientList, getTotalPatient: (b) => total = b, lastPageCallback: (b) => isLastPage = b);
  }

  @override
  void didUpdateWidget(covariant PatientFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBodyWidget() {
    return SnapHelperWidget<List<PatientData>>(
      future: future,
      loadingWidget: LoaderWidget(),
      onSuccess: (snap) {
        if (snap.isEmpty) {
          return NoDataFoundWidget(text: locale.lblNoDataFound);
        }

        return AnimatedScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
          disposeScrollController: true,
          listAnimationType: ListAnimationType.FadeIn,
          physics: AlwaysScrollableScrollPhysics(),
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
            }
          },
          children: [
            Text(locale.lblPatients + ' ($total)', style: boldTextStyle(size: 18)),
            4.height,
            Text(locale.lblSwipeMassage, style: secondaryTextStyle(size: 10, color: appSecondaryColor)),
            10.height,
            AnimatedListView(
              physics: NeverScrollableScrollPhysics(),
              itemCount: snap.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                PatientData data = patientList[index];
                return RPatientListSlidableComponent(patientData: data).paddingSymmetric(vertical: 8);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Body(child: buildBodyWidget()),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            await AddPatientScreen().launch(context).then((value) {
              if (value ?? false) {
                setState(() {});
                init();
              }
            });
          },
        ),
      ),
    );
  }
}
