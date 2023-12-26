import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/network/google_repository.dart';
import 'package:kivicare_flutter/network/telmed_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/telemed/component/zoom_config_guide_component.dart';
import 'package:kivicare_flutter/screens/doctor/screens/telemed/telemed_screen.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class ZoomDetails extends StatefulWidget {
  @override
  State<ZoomDetails> createState() => _ZoomDetailsState();
}

class _ZoomDetailsState extends State<ZoomDetails> {
  var formKey = GlobalKey<FormState>();

  TextEditingController mAPIKeyCont = TextEditingController();
  TextEditingController mAPISecretCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    LiveStream().on("isZoomEnabled", (p0) {
      setState(() {});
    });

    if (isZoomOn) {
      appStore.setLoading(true);

      await getTelemedServices().then((value) {
        appStore.setUserZoomService(value.telemedData!.enableTeleMed.validate(value: false));

        mAPIKeyCont.text = value.telemedData!.api_key.validate();
        mAPISecretCont.text = value.telemedData!.api_secret.validate();
        setState(() {});
      }).catchError((e) {
        toast(e.toString(), print: true);
      });

      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  saveTelemedData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      Map<String, dynamic> request = {
        "enableTeleMed": appStore.telemedType == 'zoom',
        "api_key": "${mAPIKeyCont.text}",
        "api_secret": "${mAPISecretCont.text}",
      };

      await addTelemedServices(request).then((value) async {
        toast(locale.lblTelemedServicesUpdated);

        await setTelemedType(type: 'zoom');

        finish(context);
      }).catchError((e) {
        toast(e.toString());
      });
      appStore.setLoading(false);
    }
  }

  void disableMeet() async {
    disconnectMeet(request: {"doctor_id": appStore.userId}).then((value) async {
      removeKey("meetUserName");
      removeKey("meetPhotoUrl");
      removeKey("meetUserEmail");

      isMeetOn = false;
      LiveStream().emit("isMeetEnabled");
      isZoomOn = true;
      setState(() {});

      await setTelemedType(type: '');

      toast(value.message.validate());
    }).catchError((e) {
      toast(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Observer(
            builder: (_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingItemWidget(
                    title: locale.lblZoomConfiguration + ' ${appStore.zoomService.validate() ? locale.lblOn : locale.lblOff}',
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
                            if (isMeetOn) {
                              if (appStore.telemedType == 'googleMeet') {
                                await showConfirmDialogCustom(
                                  context,
                                  dialogType: DialogType.ACCEPT,
                                  title: "${locale.lblYouCanUseOneMeetingServiceAtTheTimeWeAreDisablingGoogleMeetService}.",
                                  onAccept: (c) {
                                    disableMeet();
                                  },
                                );
                              } else {
                                isMeetOn = false;
                                LiveStream().emit("isMeetEnabled");
                                isZoomOn = true;
                              }
                            } else {
                              isZoomOn = true;
                            }
                          } else {
                            if (appStore.telemedType == 'zoom') {
                              setTelemedType(type: '');
                            }
                            isZoomOn = false;
                          }
                          setState(() {});
                        },
                        value: isZoomOn,
                      ),
                    ),
                  ),
                  8.height,
                  if (isZoomOn)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          controller: mAPIKeyCont,
                          textFieldType: TextFieldType.OTHER,
                          decoration: inputDecoration(context: context, labelText: locale.lblAPIKey),
                          validator: (v) {
                            if (v!.trim().isEmpty) return locale.lblAPIKeyCannotBeEmpty;
                            return null;
                          },
                        ),
                        16.height,
                        AppTextField(
                          controller: mAPISecretCont,
                          textFieldType: TextFieldType.OTHER,
                          decoration: inputDecoration(context: context, labelText: locale.lblAPISecret),
                          validator: (v) {
                            if (v!.trim().isEmpty) return locale.lblAPISecretCannotBeEmpty;
                            return null;
                          },
                        ),
                        16.height,
                        AppButton(
                          width: context.width(),
                          text: locale.lblSave,
                          onTap: () {
                            saveTelemedData();
                          },
                        ),
                        16.height,
                        Text(locale.lblZoomConfigurationGuide, style: boldTextStyle(color: primaryColor, size: 18)),
                        16.height,
                        ZoomConfigGuideComponent(),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
