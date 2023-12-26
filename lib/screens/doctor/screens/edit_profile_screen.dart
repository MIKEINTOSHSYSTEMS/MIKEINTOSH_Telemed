import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/get_doctor_detail_model.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/screens/doctor/fragments/profile_basic_information.dart';
import 'package:kivicare_flutter/screens/doctor/fragments/profile_qualification.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with SingleTickerProviderStateMixin {
  AsyncMemoizer<GetDoctorDetailModel> _memorizer = AsyncMemoizer();

  int currentIndex = 0;

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    tabController = TabController(length: 2, vsync: this);
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
    getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        locale.lblEditProfile,
        color: appPrimaryColor,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        textColor: Colors.white,
      ),
      body: FutureBuilder<GetDoctorDetailModel>(
        future: _memorizer.runOnce(() => getUserProfile(getIntAsync(USER_ID))),
        builder: (context, snap) {
          if (snap.hasData) {
            return Column(
              children: [
                TabBar(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: appStore.isDarkModeOn ? Colors.white : primaryColor,
                  isScrollable: true,
                  labelStyle: boldTextStyle(),
                  unselectedLabelStyle: primaryTextStyle(),
                  unselectedLabelColor: appStore.isDarkModeOn ? gray : textSecondaryColorGlobal,
                  indicator: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: radius()), color: context.cardColor),
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                  onTap: (i) {
                    tabController!.index = tabController!.previousIndex;
                  },
                  tabs: [
                    Tab(icon: Text(locale.lblBasicInfo, textAlign: TextAlign.center)),
                    Tab(
                      icon: Text(locale.lblQualification, textAlign: TextAlign.center),
                    ).visible(getStringAsync(USER_ROLE) != UserRoleReceptionist),
                  ],
                ).paddingAll(16),
                TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    ProfileBasicInformation(
                      getDoctorDetail: snap.data,
                      onSave: (bool? s) {
                        if (s ?? false) {
                          tabController!.animateTo(currentIndex + 1);
                        }
                      },
                    ),
                    ProfileQualification(getDoctorDetail: snap.data!).visible(getStringAsync(USER_ROLE) != UserRoleReceptionist),
                  ],
                ).expand(),
              ],
            );
          }
          return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget());
        },
      ),
    );
  }
}
