import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/common/encounter_list_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/encounter_dashboard_model.dart';
import 'package:kivicare_flutter/network/dashboard_repository.dart';
import 'package:kivicare_flutter/screens/doctor/components/add_prescription_screen.dart';
import 'package:kivicare_flutter/screens/doctor/fragments/prescription_fragment.dart';
import 'package:kivicare_flutter/screens/doctor/fragments/profile_detail_fragment.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class EncounterDashboardScreen extends StatefulWidget {
  final String? id;
  final String? name;

  EncounterDashboardScreen({this.id, this.name});

  @override
  _EncounterDashboardScreenState createState() => _EncounterDashboardScreenState();
}

class _EncounterDashboardScreenState extends State<EncounterDashboardScreen> with SingleTickerProviderStateMixin {
  TabController? tabController;

  EncounterDashboardModel? encounterDashboardModel;

  List<Tab> tabData = [];
  List<Widget> tabWidgets = [];

  String? paymentStatus;

  int tabBarLength = 0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    appStore.setLoading(true);
    getEncounterDetailsDashBoard(widget.id.toInt()).then((value) async {
      if (isProEnabled()) {
        tabData.clear();
        tabWidgets.clear();
        encounterDashboardModel = value;
        paymentStatus = value.payment_status;
        setState(() {});

        tabBarLength = 1;

        tabData.add(Tab(icon: Text(locale.lblEncounterDetails.toUpperCase(), textAlign: TextAlign.center)));
        tabWidgets.add(ProfileDetailFragment(encounterId: value.id.toInt(), patientEncounterDetailData: value, isStatusBack: true));

        if (value.enocunter_modules.validate().isNotEmpty) {
          value.enocunter_modules!.forEach((element) {
            if (element.status.toInt() == 1) {
              tabBarLength = tabBarLength + 1;
              setState(() {});
            }

            if (element.status.toInt() == 1) {
              tabData.add(Tab(icon: Text("${element.label.validate()}".toUpperCase(), textAlign: TextAlign.center)));
              tabWidgets.add(EncounterListWidget(id: value.id.toInt(), encounterType: element.name.validate(), paymentStatus: value.payment_status));
            }
          });
        }

        if (value.prescription_module.validate().isNotEmpty) {
          value.prescription_module!.forEach((element) {
            if (element.status.toInt() == 1) {
              tabBarLength = tabBarLength + 1;
            }
            if (element.status.toInt() == 1) {
              tabData.add(Tab(icon: Text("${element.label}".toUpperCase(), textAlign: TextAlign.center)));
              tabWidgets.add(PrescriptionFragment(id: value.id.toInt()));
            }
          });
        }
      } else {
        tabBarLength = 5;
        setState(() {});

        tabData.add(Tab(icon: Text(locale.lblEncounterDetails.toUpperCase(), textAlign: TextAlign.center)));
        tabData.add(Tab(icon: Text(locale.lblProblems.toUpperCase(), textAlign: TextAlign.center)));
        tabData.add(Tab(icon: Text(locale.lblObservation.toUpperCase(), textAlign: TextAlign.center)));
        tabData.add(Tab(icon: Text(locale.lblNotes.toUpperCase(), textAlign: TextAlign.center)));
        tabData.add(Tab(icon: Text(locale.lblPrescription.toUpperCase(), textAlign: TextAlign.center)));

        tabWidgets.add(ProfileDetailFragment(encounterId: value.id.toInt(), patientEncounterDetailData: value, isStatusBack: true));
        tabWidgets.add(EncounterListWidget(id: value.id.toInt(), encounterType: PROBLEM, paymentStatus: value.payment_status));
        tabWidgets.add(EncounterListWidget(id: value.id.toInt(), encounterType: OBSERVATION, paymentStatus: value.payment_status));
        tabWidgets.add(EncounterListWidget(id: value.id.toInt(), encounterType: NOTE, paymentStatus: value.payment_status));
        tabWidgets.add(PrescriptionFragment(id: value.id.toInt()));
      }

      tabController = TabController(length: tabBarLength, vsync: this);
      tabController?.addListener(() {
        currentIndex = tabController!.index.validate();
        setState(() {});
      });

      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarLength,
      child: Scaffold(
        appBar: appBarWidget(
          locale.lblEncounterDashboard,
          titleTextStyle: boldTextStyle(color: textPrimaryDarkColor, size: 18),
          color: appPrimaryColor,
          elevation: 0,
          systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
          textColor: Colors.white,
        ),
        body: Column(
          children: [
            16.height,
            if (tabData.isNotEmpty)
              TabBar(
                controller: tabController,
                tabs: tabData,
                physics: BouncingScrollPhysics(),
                labelColor: appStore.isDarkModeOn ? Colors.white : primaryColor,
                overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                isScrollable: true,
                labelStyle: boldTextStyle(),
                unselectedLabelStyle: primaryTextStyle(),
                unselectedLabelColor: appStore.isDarkModeOn ? gray : textSecondaryColorGlobal,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: radius()), color: context.cardColor),
                onTap: (i) {
                  currentIndex = i;
                  setState(() {});
                },
              ).paddingAll(16),
            if (tabWidgets.isNotEmpty)
              TabBarView(
                controller: tabController,
                children: tabWidgets,
              ).expand()
            else
              LoaderWidget(),
          ],
        ),
        floatingActionButton: !isPatient() && paymentStatus.validate() != 'paid'
            ? FloatingActionButton(
                child: Icon(Icons.add, color: Colors.white),
                onPressed: () async {
                  bool? res = await AddPrescriptionScreen(id: widget.id.toInt().validate()).launch(context);
                  if (res ?? false) {
                    setState(() {});
                  }
                },
              ).visible(currentIndex == 4)
            : 0.height,
      ),
    );
  }
}
