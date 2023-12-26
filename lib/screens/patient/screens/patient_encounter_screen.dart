import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/patient_encounter_list_model.dart';
import 'package:kivicare_flutter/network/encounter_repository.dart';
import 'package:kivicare_flutter/screens/patient/components/encounter_widget.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientEncounterScreen extends StatefulWidget {
  @override
  _PatientEncounterScreenState createState() => _PatientEncounterScreenState();
}

class _PatientEncounterScreenState extends State<PatientEncounterScreen> {
  Future<List<PatientEncounterData>>? future;

  List<PatientEncounterData> encounterList = [];

  int total = 0;
  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    future = getPatientEncounterList(appStore.userId.validate(), page: page, encounterList: encounterList, getTotalPatient: (b) => total = b, lastPageCallback: (b) => isLastPage = b);
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

  Widget buildBodyWidget() {
    return SnapHelperWidget<List<PatientEncounterData>>(
      future: future,
      loadingWidget: LoaderWidget(),
      onSuccess: (snap) {
        if (snap.isEmpty) {
          return NoDataFoundWidget(text: locale.lblNoEncounterFound);
        }

        return AnimatedListView(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: snap.length,
          disposeScrollController: true,
          padding: EdgeInsets.only(bottom: 16, top: 16, right: 16, left: 16),
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
          shrinkWrap: true,
          listAnimationType: ListAnimationType.FadeIn,
          slideConfiguration: SlideConfiguration(verticalOffset: 400),
          itemBuilder: (_, index) {
            return EncounterWidget(data: snap[index]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "${locale.lblPatientsEncounter} ${total != 0 ? "($total)" : ""}",
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Body(
        child: buildBodyWidget(),
      ),
    );
  }
}
