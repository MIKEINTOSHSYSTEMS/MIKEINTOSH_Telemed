import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/gender_model.dart';
import 'package:kivicare_flutter/model/get_doctor_detail_model.dart';
import 'package:kivicare_flutter/model/static_data_model.dart';
import 'package:kivicare_flutter/screens/receptionist/components/multi_select_specialization.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class ProfileBasicInformation extends StatefulWidget {
  final GetDoctorDetailModel? getDoctorDetail;
  void Function(bool isChanged)? onSave;

  ProfileBasicInformation({this.getDoctorDetail, this.onSave});

  @override
  _ProfileBasicInformationState createState() => _ProfileBasicInformationState();
}

class _ProfileBasicInformationState extends State<ProfileBasicInformation> {
  GlobalKey<FormState> formKey = GlobalKey();

  GetDoctorDetailModel? getDoctorDetail;
  GetDoctorDetailModel? data;

  List<GenderModel> genderList = [];

  List<Specialty> temp = [];

  var picked = DateTime.now();

  int selectedGender = -1;
  int? result = 0;

  String resultName = "range";

  bool mIsTelemedOn = false;

  TextEditingController emailCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController contactNumberCont = TextEditingController();
  TextEditingController dOBCont = TextEditingController();
  String? genderValue;
  TextEditingController addressCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController stateCont = TextEditingController();
  TextEditingController countryCont = TextEditingController();
  TextEditingController postalCodeCont = TextEditingController();
  TextEditingController experienceCont = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode dOBFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode postalCodeFocus = FocusNode();
  FocusNode experienceCodeFocus = FocusNode();

  //Add New Second teb

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
    data = widget.getDoctorDetail;
  }

  init() async {
    multiSelectStore.clearStaticList();
    genderList.add(GenderModel(name: locale.lblMale, icon: FontAwesomeIcons.male, value: "male"));
    genderList.add(GenderModel(name: locale.lblFemale, icon: FontAwesomeIcons.female, value: "female"));
    genderList.add(GenderModel(name: locale.lblOther, icon: FontAwesomeIcons.female, value: "other"));
    getDoctorDetail = widget.getDoctorDetail;
    getDoctorDetails();

    // Add New Code
    getDoctorDetail = widget.getDoctorDetail;
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
  }

  // Add New Code

  void saveBasicSettingData() async {
    Map<String, dynamic> request = {
      "price_type": "$resultName",
    };

    if (resultName == 'range') {
      fixedPriceCont.clear();
      request.putIfAbsent('minPrice', () => fromPriceCont.text);
      request.putIfAbsent('maxPrice', () => toPriceCont.text);
    } else {
      fromPriceCont.clear();
      toPriceCont.clear();
      request.putIfAbsent('price', () => fixedPriceCont.text);
    }
    editProfileAppStore.addData(request);
    toast(locale.lblInformationSaved);
    widget.onSave!.call(true);
  }

  Widget telemed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.lblZoomConfiguration, style: boldTextStyle(size: 18, color: primaryColor)),
        16.height,
        SwitchListTile(
          title: Text(
            locale.lblTelemed + ' ${mIsTelemedOn ? 'On' : 'Off'}',
            style: primaryTextStyle(color: mIsTelemedOn ? successTextColor : textPrimaryColorGlobal),
          ),
          value: mIsTelemedOn,
          selected: mIsTelemedOn,
          secondary: FaIcon(FontAwesomeIcons.video, size: 20),
          activeColor: successTextColor,
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
              validator: (v) {
                if (v!.trim().isEmpty) return locale.lblAPIKeyCannotBeEmpty;
                return null;
              },
            ),
            16.height,
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
            zoomConfigurationGuide(),
          ],
        ).visible(mIsTelemedOn),
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
                  RichTextWidget(
                    list: [
                      TextSpan(text: locale.lblSignUpOrSignIn, style: primaryTextStyle()),
                      TextSpan(
                        text: locale.lblZoomMarketPlacePortal,
                        style: boldTextStyle(color: primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            commonLaunchUrl("https://marketplace.zoom.us/");
                          },
                      ),
                    ],
                  ),
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
          ),
        ),
      ],
    );
  }

  void getDoctorDetails() {
    firstNameCont.text = getDoctorDetail!.first_name.validate();
    lastNameCont.text = getDoctorDetail!.last_name.validate();
    emailCont.text = getDoctorDetail!.user_email.validate();
    contactNumberCont.text = getDoctorDetail!.mobile_number.validate();
    dOBCont.text = getDoctorDetail!.dob.validate().getFormattedDate(BIRTH_DATE_FORMAT);
    picked = DateTime.parse(getDoctorDetail!.dob!);
    selectedGender = getDoctorDetail!.gender == 'male' ? 0 : 1;
    genderValue = getDoctorDetail!.gender;
    addressCont.text = getDoctorDetail!.address.validate();
    cityCont.text = getDoctorDetail!.city.validate();
    stateCont.text = getDoctorDetail!.state.validate();
    countryCont.text = getDoctorDetail!.country.validate();
    postalCodeCont.text = getDoctorDetail!.postal_code.validate();
    experienceCont.text = getDoctorDetail!.no_of_experience.validate();
    getDoctorDetail!.specialties!.forEach((element) {
      multiSelectStore.selectedStaticData.add(StaticData(id: element.id, label: element.label));
      temp.add(Specialty(id: element.id, label: element.label));
    });
  }

  void saveBasicInformationData() async {
    hideKeyboard(context);
    Map<String, dynamic> request = {
      "ID": "${getIntAsync(USER_ID)}",
      "user_email": "${emailCont.text}",
      "user_login": "${data!.user_login}",
      "first_name": "${firstNameCont.text}",
      "last_name": "${lastNameCont.text}",
      "gender": "$genderValue",
      "dob": "${picked.toString().getFormattedDate(CONVERT_DATE)}",
      "address": "${addressCont.text}",
      "city": "${cityCont.text}",
      "country": "${countryCont.text}",
      "postal_code": "${postalCodeCont.text}",
      "mobile_number": "${contactNumberCont.text}",
      "state": "${stateCont.text}",
      "no_of_experience": "${experienceCont.text}",
      "profile_image": image != null ? File(image!.path) : null,
      "specialties": jsonEncode(getDoctorDetail!.specialties),
      "price_type": "$resultName",
    };

    if (resultName == 'range') {
      fixedPriceCont.clear();
      request.putIfAbsent('minPrice', () => fromPriceCont.text);
      request.putIfAbsent('maxPrice', () => toPriceCont.text);
    } else {
      fromPriceCont.clear();
      toPriceCont.clear();
      request.putIfAbsent('price', () => fixedPriceCont.text);
    }

    editProfileAppStore.addData(request);
    toast(locale.lblInformationSaved);
    widget.onSave!.call(true);
  }

  Future<void> dateBottomSheet(context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext e) {
        return Container(
          height: 245,
          color: appStore.isDarkModeOn ? Colors.black : Colors.white,
          child: Column(
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.lblCancel, style: boldTextStyle()).onTap(() {
                      finish(context);
                      setState(() {});
                    }),
                    Text(locale.lblDone, style: boldTextStyle()).onTap(() {
                      if (DateTime.now().year - picked.year < 18) {
                        toast(
                          locale.lblMinimumAgeRequired + locale.lblCurrentAgeIs + ' ${DateTime.now().year - picked.year}',
                        );
                      } else {
                        finish(context);
                        dOBCont.text = picked.getFormattedDate(BIRTH_DATE_FORMAT).toString();
                      }
                    })
                  ],
                ).paddingOnly(top: 8, left: 8, right: 8, bottom: 8),
              ),
              Container(
                height: 200,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: primaryTextStyle(size: 20),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    minimumDate: DateTime(1900, 1, 1),
                    minuteInterval: 1,
                    initialDateTime: picked,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      picked = dateTime;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage() async {
    // image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100);
    image = (await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100)) as PickedFile?;
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSpecializationTap() async {
    List<String?> ids = [];
    if (multiSelectStore.selectedStaticData.validate().isNotEmpty) {
      multiSelectStore.selectedStaticData.forEach((element) {
        ids.add(element!.id);
      });
    }

    bool? res = await MultiSelectSpecialization(selectedServicesId: ids).launch(context);
    if (res ?? false) {
      multiSelectStore.selectedStaticData.forEach((element) {
        temp.add(Specialty(id: element!.id, label: element.label));
      });
      setState(() {});
    }
  }

  Widget buildBodyWidget() {
    return Body(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AnimatedScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 90),
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, shape: BoxShape.circle),
                  child: image != null
                      ? Image.file(File(image!.path), height: 90, width: 90, fit: BoxFit.cover, alignment: Alignment.center).cornerRadiusWithClipRRect(180)
                      : appStore.profileImage.validate().isNotEmpty
                          ? CachedImageWidget(url: appStore.profileImage.validate(), height: 90, fit: BoxFit.cover, circle: true)
                          : Icon(Icons.person_outline_rounded).paddingAll(16),
                ),
                Positioned(
                  bottom: -4,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: boxDecorationDefault(color: appPrimaryColor, shape: BoxShape.circle, border: Border.all(color: white, width: 3)),
                    child: ic_camera.iconImage(size: 14, color: Colors.white),
                  ).onTap(() {
                    getImage();
                  }),
                ),
              ],
            ).paddingOnly(bottom: 16).center(),
            16.height,
            Row(
              children: [
                AppTextField(
                  controller: firstNameCont,
                  focus: firstNameFocus,
                  nextFocus: lastNameFocus,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblFirstName,
                  ).copyWith(suffixIcon: ic_user.iconImage(size: 10, color: grey).paddingAll(14)),
                ).expand(),
                10.width,
                AppTextField(
                  controller: lastNameCont,
                  focus: lastNameFocus,
                  nextFocus: emailFocus,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblLastName,
                  ).copyWith(suffixIcon: ic_user.iconImage(size: 10, color: grey).paddingAll(14)),
                ).expand(),
              ],
            ),
            16.height,
            (getStringAsync(USER_EMAIL) == receptionistEmail || getStringAsync(USER_EMAIL) == doctorEmail || getStringAsync(USER_EMAIL) == patientEmail)
                ? AppTextField(
                    controller: emailCont,
                    focus: emailFocus,
                    nextFocus: contactNumberFocus,
                    textFieldType: TextFieldType.EMAIL,
                    readOnly: true,
                    onTap: () {
                      toast(locale.lblDemoEmailCannotBeChanged);
                    },
                    decoration: inputDecoration(
                      context: context,
                      labelText: locale.lblEmail,
                    ).copyWith(suffixIcon: ic_message.iconImage(size: 10, color: grey).paddingAll(14)),
                  )
                : AppTextField(
                    controller: emailCont,
                    focus: emailFocus,
                    nextFocus: contactNumberFocus,
                    textFieldType: TextFieldType.EMAIL,
                    decoration: inputDecoration(
                      context: context,
                      labelText: locale.lblEmail,
                    ).copyWith(suffixIcon: ic_message.iconImage(size: 10, color: grey).paddingAll(14)),
                  ),
            16.height,
            AppTextField(
              controller: contactNumberCont,
              focus: contactNumberFocus,
              nextFocus: dOBFocus,
              textFieldType: TextFieldType.PHONE,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblContactNumber,
              ).copyWith(suffixIcon: ic_phone.iconImage(size: 10, color: grey).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              controller: dOBCont,
              focus: dOBFocus,
              nextFocus: addressFocus,
              readOnly: true,
              validator: (s) {
                if (s!.trim().isEmpty) return locale.lblFieldIsRequired;
                return null;
              },
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblDOB,
              ).copyWith(suffixIcon: ic_calendar.iconImage(size: 10, color: grey).paddingAll(14)),
              onTap: () {
                dateBottomSheet(context);
                if (dOBCont.text.isNotEmpty) {
                  FocusScope.of(context).requestFocus(addressFocus);
                }
              },
            ),
            16.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.lblGender1, style: primaryTextStyle(size: 12)),
                6.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    genderList.length,
                    (index) {
                      return Container(
                        width: 90,
                        padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                        decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
                        child: Row(
                          children: [
                            Container(
                              padding: selectedGender == index ? EdgeInsets.all(2) : EdgeInsets.all(1),
                              decoration: boxDecorationDefault(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(color: selectedGender == index ? primaryColor : secondaryTxtColor.withOpacity(0.5)),
                              ),
                              child: Container(
                                height: selectedGender == index ? 10 : 10,
                                width: selectedGender == index ? 10 : 10,
                                decoration: boxDecorationDefault(shape: BoxShape.circle, color: selectedGender == index ? primaryColor : white),
                              ),
                            ),
                            8.width,
                            Text(genderList[index].name!, style: primaryTextStyle(size: 12)).flexible()
                          ],
                        ).center(),
                      ).onTap(() {
                        if (selectedGender == index) {
                          selectedGender = -1;
                        } else {
                          genderValue = genderList[index].value;
                          selectedGender = index;
                        }
                        setState(() {});
                      }, borderRadius: BorderRadius.circular(defaultRadius)).paddingRight(16);
                    },
                  ),
                ),
              ],
            ),
            16.height,
            GestureDetector(
              onTap: onSpecializationTap,
              child: Container(
                padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
                width: context.width(),
                decoration: boxDecorationDefault(borderRadius: radius(), border: Border.all(color: viewLineColor), color: context.scaffoldBackgroundColor),
                child: Observer(
                  builder: (_) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locale.lblSpecialization, style: primaryTextStyle(size: 12)),
                        16.height,
                        Wrap(
                          spacing: 8,
                          children: List.generate(
                            multiSelectStore.selectedStaticData.length,
                            (index) {
                              StaticData data = multiSelectStore.selectedStaticData[index]!;
                              return Chip(
                                label: Text('${data.label}', style: primaryTextStyle()),
                                backgroundColor: context.cardColor,
                                deleteIcon: Icon(Icons.clear),
                                deleteIconColor: Colors.red,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius), side: BorderSide(color: viewLineColor)),
                                onDeleted: () {
                                  multiSelectStore.removeStaticItem(data);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            16.height,
            AppTextField(
              controller: addressCont,
              focus: addressFocus,
              nextFocus: cityFocus,
              textFieldType: TextFieldType.MULTILINE,
              minLines: 4,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblAddress,
              ).copyWith(alignLabelWithHint: true, suffixIcon: ic_location.iconImage(size: 10, color: grey).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              controller: cityCont,
              focus: cityFocus,
              nextFocus: stateFocus,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblCity,
              ).copyWith(suffixIcon: ic_location.iconImage(size: 10, color: grey).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              controller: stateCont,
              focus: stateFocus,
              nextFocus: countryFocus,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblState,
              ).copyWith(suffixIcon: ic_location.iconImage(size: 10, color: grey).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              controller: countryCont,
              focus: countryFocus,
              nextFocus: postalCodeFocus,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblCountry,
              ).copyWith(suffixIcon: ic_location.iconImage(size: 10, color: grey).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              controller: postalCodeCont,
              focus: postalCodeFocus,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblPostalCode,
              ).copyWith(suffixIcon: ic_location.iconImage(size: 10, color: grey).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              controller: experienceCont,
              focus: experienceCodeFocus,
              textFieldType: TextFieldType.OTHER,
              keyboardType: TextInputType.number,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblExperience,
              ).copyWith(suffixIcon: ic_experience.iconImage(size: 10, color: grey).paddingAll(14)),
            ),
            //Add New Code
            16.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Text("Price Range*", style: primaryTextStyle(size: 12)),
                16.height,
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 16),
                      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
                      child: Row(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(),
                            child: Radio(
                              value: 0,
                              activeColor: primaryColor,
                              groupValue: result,
                              onChanged: (dynamic value) {
                                result = value;
                                resultName = "range";
                                setState(() {});
                              },
                            ),
                          ),
                          Text(locale.lblRange, style: secondaryTextStyle()),
                        ],
                      ),
                    ),
                    16.width,
                    Container(
                      padding: EdgeInsets.only(right: 16),
                      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
                      child: Row(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(unselectedWidgetColor: secondaryTxtColor.withOpacity(0.5)),
                            child: Radio(
                              value: 1,
                              activeColor: primaryColor,
                              groupValue: result,
                              onChanged: (dynamic value) {
                                result = value;
                                resultName = "fixed";
                                setState(() {});
                              },
                            ),
                          ),
                          Text(locale.lblFixed, style: secondaryTextStyle()),
                        ],
                      ),
                    ),
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
                        decoration: inputDecoration(
                          context: context,
                          labelText: locale.lblToPrice,
                        ).copyWith(suffixIcon: ic_dollar_icon.iconImage(size: 10, color: grey).paddingAll(14)),
                      ).expand(),
                    ),
                    20.width,
                    Container(
                      child: AppTextField(
                        controller: fromPriceCont,
                        focus: fromPriceFocus,
                        textFieldType: TextFieldType.NAME,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration(
                          context: context,
                          labelText: locale.lblFromPrice,
                        ).copyWith(suffixIcon: ic_dollar_icon.iconImage(size: 10, color: grey).paddingAll(14)),
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
                    decoration: inputDecoration(
                      context: context,
                      labelText: locale.lblFixedPrice,
                    ).copyWith(suffixIcon: ic_dollar_icon.iconImage(size: 10, color: grey).paddingAll(14)),
                  ),
                ).visible(result == 1),
                16.height,
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward, color: textPrimaryDarkColor),
        elevation: 0.0,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            saveBasicInformationData();
          }
        },
      ),
    );
  }
}
