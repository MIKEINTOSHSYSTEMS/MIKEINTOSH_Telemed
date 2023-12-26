import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/get_doctor_detail_model.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class RProfileBasicSettings extends StatefulWidget {
  GetDoctorDetailModel? getDoctorDetail;
  void Function(bool isChanged)? onSave;

  RProfileBasicSettings({this.getDoctorDetail, this.onSave});

  @override
  _RProfileBasicSettingsState createState() => _RProfileBasicSettingsState();
}

class _RProfileBasicSettingsState extends State<RProfileBasicSettings> {
  int? result = 0;

  String resultName = "range";

  bool? mIsTelemedOn = false;

  GetDoctorDetailModel? getDoctorDetail;

  TextEditingController fixedPriceCont = TextEditingController();
  TextEditingController toPriceCont = TextEditingController();
  TextEditingController fromPriceCont = TextEditingController();
  TextEditingController videoPriceCont = TextEditingController();
  TextEditingController mAPIKeyCont = TextEditingController();
  TextEditingController mAPISecretCont = TextEditingController();

  FocusNode fixedPriceFocus = FocusNode();
  FocusNode toPriceFocus = FocusNode();
  FocusNode fromPriceFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getDoctorDetail = widget.getDoctorDetail;
    if (getDoctorDetail != null) {
      if (getDoctorDetail!.price_type.validate() == "range") {
        toPriceCont.text = getDoctorDetail!.price.validate().split('-')[0];
        fromPriceCont.text = getDoctorDetail!.price.validate().split('-')[1];
        result = 0;
        setState(() {});
      } else {
        resultName = 'fixed';
        fixedPriceCont.text = getDoctorDetail!.price.validate();
        result = 1;
        setState(() {});
      }
      videoPriceCont.text = getDoctorDetail!.video_price.toString();
      mAPIKeyCont.text = getDoctorDetail!.api_key.validate();
      mAPISecretCont.text = getDoctorDetail!.api_secret.validate();
      if (getDoctorDetail!.enableTeleMed != null) {
        mIsTelemedOn = getDoctorDetail!.enableTeleMed;
      } else {
        mIsTelemedOn = false;
      }
    }
  }

  void saveBasicSettingData() async {
    Map<String, dynamic> request = {
      "price_type": "$resultName",
    };

    if (resultName == 'range') {
      fixedPriceCont.clear();
      request.putIfAbsent('minPrice', () => toPriceCont.text);
      request.putIfAbsent('maxPrice', () => fromPriceCont.text);
    } else {
      fromPriceCont.clear();
      toPriceCont.clear();
      request.putIfAbsent('price', () => fixedPriceCont.text);
    }

    if (mIsTelemedOn!) {
      request.putIfAbsent('enableTeleMed', () => "$mIsTelemedOn");
      request.putIfAbsent('api_key', () => mAPIKeyCont.text);
      request.putIfAbsent('api_secret', () => mAPISecretCont.text);
      request.putIfAbsent('video_price', () => videoPriceCont.text);
    }

    editProfileAppStore.addData(request);
    toast(locale.lblInformationSaved);
    widget.onSave!.call(true);
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
    return Body(
      child: AnimatedScrollView(
        padding: EdgeInsets.all(16),
        children: [
          10.height,
          Row(
            children: [
              Radio(
                activeColor: context.primaryColor,
                fillColor: MaterialStateProperty.all(context.primaryColor),
                value: 0,
                groupValue: result,
                onChanged: (dynamic value) {
                  result = value;
                  resultName = "range";

                  setState(() {});
                },
              ),
              Text(locale.lblRange, style: primaryTextStyle()),
              Radio(
                activeColor: context.primaryColor,
                fillColor: MaterialStateProperty.all(context.primaryColor),
                value: 1,
                groupValue: result,
                onChanged: (dynamic value) {
                  result = value;
                  resultName = "fixed";
                  setState(() {});
                },
              ),
              Text(locale.lblFixed, style: primaryTextStyle()),
            ],
          ),
          20.height,
          Row(
            children: [
              Container(
                child: AppTextField(
                  controller: toPriceCont,
                  focus: toPriceFocus,
                  textFieldType: TextFieldType.NAME,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration(context: context, labelText: locale.lblToPrice),
                ).expand(),
              ),
              20.width,
              Container(
                child: AppTextField(
                  controller: fromPriceCont,
                  focus: fromPriceFocus,
                  textFieldType: TextFieldType.NAME,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration(context: context, labelText: locale.lblFromPrice),
                ).expand(),
              ),
            ],
          ).visible(result == 0),
          Container(
            child: AppTextField(
              controller: fixedPriceCont,
              focus: fixedPriceFocus,
              textFieldType: TextFieldType.NAME,
              keyboardType: TextInputType.number,
              decoration: inputDecoration(context: context, labelText: locale.lblFixedPrice),
            ),
          ).visible(result == 1),
          16.height,
          telemed(),
        ],
      ),
    );
  }

  Widget telemed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.lblZoomConfiguration, style: boldTextStyle(size: 18, color: primaryColor)),
        16.height,
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(locale.lblTelemed + ' ${mIsTelemedOn! ? locale.lblOn : locale.lblOff}', style: primaryTextStyle()),
          value: mIsTelemedOn!,
          inactiveTrackColor: Colors.grey.shade300,
          activeColor: context.primaryColor,
          selected: mIsTelemedOn!,
          secondary: Icon(FontAwesomeIcons.video, size: 20),
          onChanged: (v) {
            mIsTelemedOn = v;
            setState(() {});
          },
        ),
        Column(
          children: [
            16.height,
            AppTextField(
              controller: videoPriceCont,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(context: context, labelText: locale.lblVideoPrice),
              isValidationRequired: true,
            ),
            16.height,
            AppTextField(
              controller: mAPIKeyCont,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(context: context, labelText: locale.lblAPIKey),
              isValidationRequired: true,
            ),
            16.height,
            AppTextField(
              controller: mAPISecretCont,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(context: context, labelText: locale.lblAPISecret),
              isValidationRequired: true,
            ),
            16.height,
            zoomConfigurationGuide(),
          ],
        ).visible(mIsTelemedOn!),
      ],
    );
  }

  Widget zoomConfigurationGuide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.lblZoomConfigurationGuide, style: boldTextStyle(color: primaryColor, size: 18)),
        16.height,
        Container(
            decoration: BoxDecoration(border: Border.all(color: viewLineColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(locale.lbl1, style: boldTextStyle()),
                    6.width,
                    Text(locale.lblSignUpOrSignIn, style: primaryTextStyle()),
                    Text(
                      locale.lblZoomMarketPlacePortal,
                      style: boldTextStyle(color: primaryColor),
                    ).onTap(() {
                      commonLaunchUrl("https://marketplace.zoom.us/");
                    }).expand(),
                  ],
                ).paddingAll(8),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(locale.lbl2, style: boldTextStyle()),
                    6.width,
                    RichTextWidget(
                      maxLines: 5,
                      list: [
                        TextSpan(text: locale.lblClickOnDevelopButton, style: primaryTextStyle()),
                        TextSpan(
                          text: locale.lblCreateApp,
                          style: boldTextStyle(color: primaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              commonLaunchUrl("https://marketplace.zoom.us/develop/create");
                            },
                        ),
                      ],
                    ).expand(),
                  ],
                ).paddingAll(8),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(locale.lb13, style: boldTextStyle()),
                    6.width,
                    Text(locale.lblChooseAppTypeToJWT, style: primaryTextStyle()).expand(),
                  ],
                ).paddingAll(8),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(locale.lbl4, style: boldTextStyle()),
                    6.width,
                    Text(locale.lblMandatoryMessage, style: primaryTextStyle()).expand(),
                  ],
                ).paddingAll(8),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(locale.lbl5, style: boldTextStyle()),
                    6.width,
                    Text(locale.lblCopyAndPasteAPIKey, style: primaryTextStyle()).expand(),
                  ],
                ).paddingAll(8),
              ],
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: Icon(Icons.arrow_forward, color: textPrimaryDarkColor),
        onPressed: () {
          saveBasicSettingData();
        },
      ),
    );
  }
}
