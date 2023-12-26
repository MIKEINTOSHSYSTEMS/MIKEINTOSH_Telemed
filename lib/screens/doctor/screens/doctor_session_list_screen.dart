import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_schedule_model.dart';
import 'package:kivicare_flutter/network/doctor_sessions_repository.dart';
import 'package:kivicare_flutter/screens/doctor/components/doctor_session_list_component.dart';
import 'package:kivicare_flutter/screens/doctor/screens/add_session_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorSessionListScreen extends StatefulWidget {
  @override
  _DoctorSessionListScreenState createState() => _DoctorSessionListScreenState();
}

class _DoctorSessionListScreenState extends State<DoctorSessionListScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
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
    return Container(
      child: FutureBuilder<DoctorSessionModel>(
        future: getDoctorSessionData(clinicData: isProEnabled() ? getIntAsync(USER_CLINIC) : getIntAsync(USER_CLINIC)),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.sessionData.validate().isEmpty) return NoDataFoundWidget(text: locale.lblNoDataFound).center();

            return AnimatedScrollView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
              disposeScrollController: true,
              listAnimationType: ListAnimationType.FadeIn,
              physics: AlwaysScrollableScrollPhysics(),
              slideConfiguration: SlideConfiguration(verticalOffset: 400),
              onSwipeRefresh: () async {
                getDoctorSessionData(clinicData: isProEnabled() ? getIntAsync(USER_CLINIC) : getIntAsync(USER_CLINIC));
                return await 2.seconds.delay;
              },
              children: [
                16.height,
                Text(locale.lblDoctorSessions + ' (${snap.data!.sessionData!.length.validate()})', style: boldTextStyle(size: titleTextSize)),
                16.height,
                AnimatedListView(
                  itemCount: snap.data!.sessionData!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    SessionData data = snap.data!.sessionData![index];
                    return DoctorSessionListComponent(data: data);
                  },
                ),
              ],
            );
          }
          return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblDoctorSessions, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Body(child: body()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await AddSessionsScreen().launch(context).then((value) {
            if (value ?? false) {
              setState(() {});
            }
          });
        },
      ),
    );
  }
}
