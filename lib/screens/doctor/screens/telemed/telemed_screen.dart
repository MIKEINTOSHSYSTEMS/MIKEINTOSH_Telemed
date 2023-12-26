import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/user_configuration.dart';
import 'package:kivicare_flutter/network/encounter_repository.dart';
import 'package:kivicare_flutter/network/google_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/telemed/component/meet_details.dart';
import 'package:kivicare_flutter/screens/doctor/screens/telemed/component/zoom_details.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';

bool isZoomOn = false;
bool isMeetOn = false;

class TelemedScreen extends StatefulWidget {
  @override
  _TelemedScreenState createState() => _TelemedScreenState();
}

class _TelemedScreenState extends State<TelemedScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isZoomOn = appStore.telemedType == 'zoom';
    isMeetOn = appStore.telemedType == 'meet';
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
      appBar: appBarWidget(locale.lblTelemed, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: FutureBuilder<UserConfiguration>(
          future: getConfiguration(),
          builder: (context, snap) {
            if (snap.hasData) {
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (snap.data!.isTeleMedActive.validate()) ZoomDetails(),
                          16.height,
                          if (snap.data!.isKiviCareGooglemeetActive.validate()) MeetDetails(),
                        ],
                      ),
                    ),
                  ),
                  Observer(
                    builder: (context) => LoaderWidget().visible(appStore.isLoading),
                  )
                ],
              );
            } else {
              return snapWidgetHelper(snap, loadingWidget: LoaderWidget());
            }
          }),
    );
  }
}
/*Future<bool> telemedType({required bool status}) async {
  //if both telemed is off
  if (appStore.telemedType == "") {
    //
  }

  return true;
}*/

Future<bool> setTelemedType({required String type}) async {
  Map<String, dynamic> req = {"user_id": appStore.userId, "telemed_type": type.validate()};

  appStore.setLoading(true);

  return await changeTelemedType(request: req).then((value) {
    appStore.setTelemedType(type.validate(), initiliaze: true);

    appStore.setLoading(false);

    return true;
  }).catchError((e) {
    log(e.toString());
    appStore.setLoading(false);
    return false;
  });
}
