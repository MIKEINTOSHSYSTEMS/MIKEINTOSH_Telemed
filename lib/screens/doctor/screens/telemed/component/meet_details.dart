import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/response_model.dart';
import 'package:momona_healthcare/network/google_repository.dart';
import 'package:momona_healthcare/network/telmed_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/telemed/telemed_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class MeetDetails extends StatefulWidget {
  @override
  _MeetDetailsState createState() => _MeetDetailsState();
}

class _MeetDetailsState extends State<MeetDetails> {
  bool isDisconnected = false;
  bool isSwitchEnabled = false;

  String? userName = "";
  String? photoUrl = "";
  String? userEmail = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    LiveStream().on("isMeetEnabled", (p0) {
      setState(() {});
    });

    if (appStore.telemedType == "meet") {
      isDisconnected = true;
      userName = getStringAsync('meetUserName');
      photoUrl = getStringAsync('meetPhotoUrl');
      userEmail = getStringAsync('meetUserEmail');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void disableZoom() async {
    appStore.setLoading(true);
    Map<String, dynamic> request = {
      "enableTeleMed": false,
      "api_key": "",
      "api_secret": "",
    };
    log(request);
    await addTelemedServices(request).then((value) async {
      toast(locale.lblTelemedServicesUpdated);

      isZoomOn = false;
      LiveStream().emit("isZoomEnabled");
      isMeetOn = true;
      setState(() {});

      await setTelemedType(type: '');

      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  Widget googleMeet() {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isDisconnected) Text('${locale.lblYouAreConnectedWithTheGoogleCalender}.', style: boldTextStyle()) else Text('${locale.lblPleaseConnectWithYourGoogleAccountToGetAppointmentsInGoogleCalendarAutomatically}.', style: boldTextStyle()),
          CachedImageWidget(
            height: 150,
            width: 150,
            circle: true,
            url: photoUrl.validate(),
          ).visible(photoUrl.validate().isNotEmpty),
          16.height,
          Text(userName.validate(value: ""), style: boldTextStyle(size: 24)).visible(userName.validate().isNotEmpty),
          16.height,
          Text(userEmail.validate(value: ''), style: secondaryTextStyle()).visible(userEmail.validate().isNotEmpty),
          16.height,
          if (!isDisconnected)
            AppButton(
              color: context.scaffoldBackgroundColor,
              elevation: 4,
              textStyle: primaryTextStyle(color: Colors.white),
              child: TextIcon(
                spacing: 16,
                prefix: GoogleLogoWidget(size: 20),
                text: locale.lblConnectWithGoogle,
                onTap: null,
              ),
              onTap: () async {
                setMeetService();
              },
            )
          else
            AppButton(
              color: context.primaryColor,
              elevation: 4,
              textStyle: primaryTextStyle(color: Colors.white),
              text: locale.lblDisconnect,
              onTap: () async {
                showConfirmDialogCustom(
                  context,
                  onAccept: (c) async {
                    disconnectMeet(request: {"doctor_id": appStore.userId}).then((value) {
                      userName = "";
                      photoUrl = "";
                      userEmail = "";
                      removeKey("meetUserName");
                      removeKey("meetPhotoUrl");
                      removeKey("meetUserEmail");
                      isDisconnected = false;

                      setState(() {});

                      toast(value.message.validate());
                    }).catchError((e) {
                      toast(e.toString());
                    });
                  },
                  title: locale.lblAreYouSureYouWantToDisconnect,
                  dialogType: DialogType.CONFIRMATION,
                  positiveText: locale.lblYes,
                );
              },
            ),
        ],
      ).paddingAll(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                SettingItemWidget(
                  title: "${locale.lblGoogleMeet}" + ' ${appStore.userTelemedOn.validate(value: false) ? locale.lblOn : locale.lblOff}',
                  decoration: boxDecorationDefault(color: context.cardColor),
                  padding: EdgeInsets.all(8),
                  trailing: Transform.scale(
                    scale: 1,
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      inactiveTrackColor: Colors.grey.shade300,
                      activeColor: primaryColor,
                      onChanged: (bool value) async {
                        if (value) {
                          if (isZoomOn) {
                            if (appStore.telemedType == 'zoom') {
                              await showConfirmDialogCustom(
                                context,
                                dialogType: DialogType.ACCEPT,
                                title: "${locale.lblYouCanUseOneMeetingServiceAtTheTimeWeAreDisablingZoomService}.",
                                onAccept: (c) {
                                  disableZoom();
                                },
                              );
                            } else {
                              isZoomOn = false;
                              LiveStream().emit("isZoomEnabled");
                              isMeetOn = true;
                            }
                          } else {
                            isMeetOn = true;
                          }
                        } else {
                          if (appStore.telemedType == 'googleMeet') {
                            setTelemedType(type: '');
                          }
                          isMeetOn = false;
                        }
                        setState(() {});
                      },
                      value: isMeetOn,
                    ),
                  ),
                ),
                googleMeet().visible(isMeetOn),
              ],
            ),
          ],
        );
      },
    );
  }

  void setMeetService() async {
    await authService.signInWithGoogle().then((user) async {
      //
      if (user != null) {
        Map<String, dynamic> request = {
          'doctor_id': appStore.userId,
          'code': await user.getIdToken().then((value) => value),
        };

        await connectMeet(request: request).then((value) async {
          ResponseModel data = value;

          userName = user.displayName;
          photoUrl = user.photoURL;
          userEmail = user.email;

          setValue("meetUserName", user.displayName.toString().validate());
          setValue("meetPhotoUrl", user.photoURL.toString().validate());
          setValue("meetUserEmail", user.email.toString().validate());

          isDisconnected = true;
          setState(() {});

          await setTelemedType(type: 'googleMeet');

          toast(data.message);
        }).catchError((e) {
          toast(e.toString());
        });
      }
    }).catchError((e) {
      toast(e.toString());
    });
  }
}
