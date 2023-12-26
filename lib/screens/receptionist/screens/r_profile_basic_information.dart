import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
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
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class RProfileBasicInformation extends StatefulWidget {
  final GetDoctorDetailModel? getDoctorDetail;
  void Function(bool isChanged)? onSave;
  final int? doctorId;
  final bool isNewDoctor;

  RProfileBasicInformation({this.getDoctorDetail, this.onSave, this.doctorId, this.isNewDoctor = false});

  @override
  _RProfileBasicInformationState createState() => _RProfileBasicInformationState();
}

class _RProfileBasicInformationState extends State<RProfileBasicInformation> {
  GlobalKey<FormState> formKey = GlobalKey();

  List<GenderModel> genderList = [];

  List<Specialty> temp = [];

  var picked = DateTime.now();

  int selectedGender = -1;

  GetDoctorDetailModel? getDoctorDetail;

  bool isUpdate = false;

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

  @override
  void initState() {
    super.initState();
    init();
  }

  void saveBasicInformationData() async {
    hideKeyboard(context);
    Map<String, dynamic> request = {
      "user_email": "${emailCont.text}",
      "first_name": "${firstNameCont.text}",
      "last_name": "${lastNameCont.text}",
      "gender": "$genderValue",
      "dob": "${picked.toString().getFormattedDate(CONVERT_DATE)}",
      "address": "${addressCont.text}",
      "clinic_id": "${getIntAsync(USER_CLINIC)}",
      "city": "${cityCont.text}",
      "country": "${countryCont.text}",
      "postal_code": "${postalCodeCont.text}",
      "mobile_number": "${contactNumberCont.text}",
      "state": "${stateCont.text}",
      "no_of_experience": experienceCont.text,
      "profile_image": "",
      "specialties": jsonEncode(multiSelectStore.selectedStaticData),
    };
    if (isUpdate) {
      request.putIfAbsent("ID", () => "${widget.doctorId.validate()}");
    }
    editProfileAppStore.addData(request);
    toast(locale.lblInformationSaved);
    widget.onSave!.call(true);
  }

  init() async {
    genderList.add(GenderModel(name: locale.lblMale, icon: FontAwesomeIcons.male, value: "male"));
    genderList.add(GenderModel(name: locale.lblFemale, icon: FontAwesomeIcons.female, value: "female"));
    genderList.add(GenderModel(name: locale.lblOther, icon: FontAwesomeIcons.female, value: "other"));
    isUpdate = widget.getDoctorDetail != null;
    if (isUpdate) {
      getDoctorDetail = widget.getDoctorDetail;
      getDoctorDetails();
    }
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
                          bgColor: errorBackGroundColor,
                          textColor: errorTextColor,
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
                  data: CupertinoThemeData(textTheme: CupertinoTextThemeData(dateTimePickerTextStyle: primaryTextStyle(size: 20))),
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
            Row(
              children: [
                AppTextField(
                  controller: firstNameCont,
                  focus: firstNameFocus,
                  nextFocus: lastNameFocus,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(context: context, labelText: locale.lblFirstName),
                ).expand(),
                10.width,
                AppTextField(
                  controller: lastNameCont,
                  focus: lastNameFocus,
                  nextFocus: emailFocus,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(context: context, labelText: locale.lblLastName),
                ).expand(),
              ],
            ),
            16.height,
            if ((getStringAsync(USER_EMAIL) == receptionistEmail || getStringAsync(USER_EMAIL) == doctorEmail || getStringAsync(USER_EMAIL) == patientEmail) && !widget.isNewDoctor)
              AppTextField(
                controller: emailCont,
                focus: emailFocus,
                nextFocus: contactNumberFocus,
                textFieldType: TextFieldType.EMAIL,
                readOnly: true,
                onTap: () {
                  toast(locale.lblDemoEmailCannotBeChanged);
                },
                decoration: inputDecoration(context: context, labelText: locale.lblEmail),
              )
            else
              AppTextField(
                controller: emailCont,
                focus: emailFocus,
                nextFocus: contactNumberFocus,
                textFieldType: TextFieldType.EMAIL,
                decoration: inputDecoration(context: context, labelText: locale.lblEmail),
              ),
            16.height,
            AppTextField(
              controller: contactNumberCont,
              focus: contactNumberFocus,
              nextFocus: dOBFocus,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              textFieldType: TextFieldType.PHONE,
              decoration: inputDecoration(context: context, labelText: locale.lblContactNumber),
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
              decoration: inputDecoration(context: context, labelText: locale.lblDOB),
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
                Text(locale.lblGender1, style: primaryTextStyle()),
                8.height,
                //New Code
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    genderList.length,
                    (index) {
                      return Container(
                        width: 90,
                        padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                        decoration: boxDecorationDefault(borderRadius: radius(defaultRadius), color: context.cardColor),
                        child: Row(
                          children: [
                            Container(
                              padding: selectedGender == index ? EdgeInsets.all(2) : EdgeInsets.all(1),
                              decoration: boxDecorationDefault(
                                shape: BoxShape.circle,
                                border: Border.all(color: selectedGender == index ? primaryColor : secondaryTxtColor.withOpacity(0.5)),
                                color: Colors.transparent,
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
                decoration: boxDecorationDefault(border: Border.all(color: viewLineColor), borderRadius: radius(), color: context.cardColor),
                child: Observer(
                  builder: (_) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locale.lblSpecialization, style: primaryTextStyle()),
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
                                deleteIcon: Icon(Icons.clear, size: 18),
                                deleteIconColor: Colors.red,
                                onDeleted: () {
                                  multiSelectStore.removeStaticItem(data);
                                  temp.remove(data);
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius), side: BorderSide(color: viewLineColor)),
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
              minLines: 2,
              maxLines: 4,
              decoration: inputDecoration(context: context, labelText: locale.lblAddress).copyWith(alignLabelWithHint: true),
            ),
            16.height,
            AppTextField(
              controller: cityCont,
              focus: cityFocus,
              nextFocus: stateFocus,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(context: context, labelText: locale.lblCity),
            ),
            16.height,
            AppTextField(
              controller: stateCont,
              focus: stateFocus,
              nextFocus: countryFocus,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(context: context, labelText: locale.lblState),
            ),
            16.height,
            AppTextField(
              controller: countryCont,
              focus: countryFocus,
              nextFocus: postalCodeFocus,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(context: context, labelText: locale.lblCountry),
            ),
            16.height,
            AppTextField(
              controller: postalCodeCont,
              focus: postalCodeFocus,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(context: context, labelText: locale.lblPostalCode),
            ),
            16.height,
            AppTextField(
              controller: experienceCont,
              focus: experienceCodeFocus,
              textFieldType: TextFieldType.OTHER,
              keyboardType: TextInputType.number,
              decoration: inputDecoration(context: context, labelText: locale.lblExperience),
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
