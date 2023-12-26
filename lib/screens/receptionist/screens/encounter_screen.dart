import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/patient_encounter_list_model.dart';
import 'package:kivicare_flutter/model/patient_list_model.dart';
import 'package:kivicare_flutter/network/encounter_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/add_encounter_screen.dart';
import 'package:kivicare_flutter/screens/receptionist/components/patient_encounter_list_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class EncounterScreen extends StatefulWidget {
  final PatientData? patientData;
  final String? image;

  EncounterScreen({this.image, this.patientData});

  @override
  _EncounterScreenState createState() => _EncounterScreenState();
}

class _EncounterScreenState extends State<EncounterScreen> {
  Future<List<PatientEncounterData>>? future;

  List<PatientEncounterData> patientEncounterList = [];

  int total = 0;
  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    future = getPatientEncounterList(widget.patientData!.iD, page: page, encounterList: patientEncounterList, getTotalPatient: (b) => total = b, lastPageCallback: (b) => isLastPage = b);
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

  Widget body() {
    return SnapHelperWidget<List<PatientEncounterData>>(
      future: future,
      loadingWidget: LoaderWidget(),
      onSuccess: (snap) {
        int cancelled = snap.where((element) => element.status == '0').toList().length;
        List booked = snap.where((element) => element.status == '1').toList();
        List completed = snap.where((element) => element.status == '3').toList();
        if (snap.isEmpty) {
          return NoDataFoundWidget(text: locale.lblNoDataFound);
        }

        return AnimatedScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          disposeScrollController: true,
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
            Container(
              padding: EdgeInsets.all(16),
              color: appPrimaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.patientData!.profile_image == null
                          ? Image.asset(widget.image!, height: 70, width: 70)
                          : CachedImageWidget(
                              url: widget.patientData!.profile_image.validate(),
                              height: 80,
                            ),
                      Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(left: 2, right: 5),
                        child: Column(
                          children: [
                            Text(
                              total.toString(),
                              style: boldTextStyle(size: 18, letterSpacing: 1, color: textPrimaryDarkColor),
                            ).onTap(() async {}),
                            4.height,
                            Text(locale.lblVisited, style: primaryTextStyle(size: 14, color: textPrimaryDarkColor)),
                          ],
                        ),
                      ).expand(),
                      Container(height: 40, width: 1, color: textPrimaryDarkColor.withOpacity(0.2)),
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          children: [
                            Text(
                              booked.length.validate().toString(),
                              style: boldTextStyle(size: 18, letterSpacing: 1, color: textPrimaryDarkColor),
                            ).onTap(() async {}).visible(true),
                            4.height,
                            FittedBox(child: Text(locale.lblBooked, style: primaryTextStyle(size: 14, color: textPrimaryDarkColor))),
                          ],
                        ),
                      ).expand(),
                      Container(height: 40, width: 1, color: textPrimaryDarkColor.withOpacity(0.2)),
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          children: [
                            Text(
                              completed.length.validate().toString(),
                              style: boldTextStyle(size: 18, letterSpacing: 1, color: textPrimaryDarkColor),
                            ).onTap(() async {}).visible(true),
                            4.height,
                            FittedBox(child: Text(locale.lblCompleted, style: primaryTextStyle(size: 14, color: textPrimaryDarkColor))),
                          ],
                        ),
                      ).expand(),
                      Container(height: 40, width: 1, color: textPrimaryDarkColor.withOpacity(0.2)),
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(left: 5),
                        child: Column(
                          children: [
                            Text(
                              cancelled.validate().toString(),
                              style: boldTextStyle(size: 18, letterSpacing: 1, color: textPrimaryDarkColor),
                            ).onTap(() async {}).visible(true),
                            4.height,
                            FittedBox(child: Text(locale.lblCancelled, style: primaryTextStyle(size: 14, color: textPrimaryDarkColor))),
                          ],
                        ),
                      ).expand(),
                    ],
                  ),
                ],
              ),
            ),
            16.height,
            Text(locale.lblSwipeMassage, style: secondaryTextStyle(size: 10, color: appSecondaryColor)).paddingOnly(left: 16),
            AnimatedListView(
              physics: NeverScrollableScrollPhysics(),
              itemCount: snap.length,
              padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                PatientEncounterData data = snap[index];
                DateTime tempDate = DateFormat(CONVERT_DATE).parse(data.encounter_date.validate());
                return PatientEncounterListComponent(data: data, patientData: widget.patientData, tempDate: tempDate).paddingSymmetric(vertical: 8);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '${widget.patientData!.display_name.capitalizeFirstLetter()} ' + locale.lblEncounters,
        textColor: Colors.white,
        elevation: 0,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Body(child: body()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await AddEncounterScreen(patientId: widget.patientData!.iD).launch(context).then((value) {
            if (value ?? false) {
              setState(() {});
              init();
            }
          });
        },
      ),
    );
  }
}
