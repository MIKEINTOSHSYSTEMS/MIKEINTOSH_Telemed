import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/model/get_doctor_detail_model.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/r_profile_basic_information.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/r_profile_basic_setting.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/r_profile_qualification.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class RAddNewDoctor extends StatefulWidget {
  DoctorList? doctorList;
  bool isUpdate;

  RAddNewDoctor({this.doctorList, this.isUpdate = false});

  @override
  _RAddNewDoctorState createState() => _RAddNewDoctorState();
}

class _RAddNewDoctorState extends State<RAddNewDoctor> with SingleTickerProviderStateMixin {
  AsyncMemoizer<GetDoctorDetailModel> _memorizer = AsyncMemoizer();

  int currentIndex = 0;
  TabController? tabController;
  GetDoctorDetailModel? getDoctorDetail;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    multiSelectStore.clearStaticList();

    editProfileAppStore.removeData();
    tabController = TabController(length: 3, vsync: this);
    tabController!.addListener(() {
      setState(() {
        currentIndex = tabController!.index;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget body() {
    return Body(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          RProfileBasicInformation(
            isNewDoctor: true,
            onSave: (bool? s) {
              if (s ?? false) {
                tabController!.animateTo(currentIndex + 1);
              }
            },
          ),
          RProfileBasicSettings(
            onSave: (bool? s) {
              if (s ?? false) {
                tabController!.animateTo(currentIndex + 1);
              }
            },
          ),
          RProfileQualification(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: appBarWidget(
          locale.lblAddDoctorProfile,
          color: appPrimaryColor,
          elevation: 0,
          systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
          textColor: Colors.white,
        ),
        body: widget.isUpdate
            ? FutureBuilder<GetDoctorDetailModel>(
                future: _memorizer.runOnce(() => getUserProfile(widget.doctorList!.iD)),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return Column(
                      children: [
                        16.height,
                        TabBar(
                          physics: NeverScrollableScrollPhysics(),
                          controller: tabController,
                          padding: EdgeInsets.only(left: 6, bottom: 16),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: appStore.isDarkModeOn ? Colors.white : primaryColor,
                          isScrollable: true,
                          labelStyle: boldTextStyle(),
                          unselectedLabelStyle: primaryTextStyle(),
                          unselectedLabelColor: appStore.isDarkModeOn ? gray : textSecondaryColorGlobal,
                          indicator: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: radius()), color: context.cardColor),
                          onTap: (i) {
                            tabController!.index = tabController!.previousIndex;
                          },
                          tabs: [
                            Tab(icon: Text(locale.lblBasicInfo, textAlign: TextAlign.center)),
                            Tab(icon: Text(locale.lblBasicSettings, textAlign: TextAlign.center)),
                            Tab(icon: Text(locale.lblQualification, textAlign: TextAlign.center)),
                          ],
                        ),
                        TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: tabController,
                          children: [
                            RProfileBasicInformation(
                              getDoctorDetail: snap.data,
                              doctorId: widget.doctorList!.iD,
                              onSave: (bool? s) {
                                if (s ?? false) {
                                  tabController!.animateTo(currentIndex + 1);
                                }
                              },
                            ),
                            RProfileBasicSettings(
                              getDoctorDetail: snap.data,
                              onSave: (bool? s) {
                                if (s ?? false) {
                                  tabController!.animateTo(currentIndex + 1);
                                }
                              },
                            ),
                            RProfileQualification(getDoctorDetail: snap.data),
                          ],
                        ).expand(),
                      ],
                    );
                  }
                  return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget());
                },
              )
            : body(),
      ),
    );
  }
}
