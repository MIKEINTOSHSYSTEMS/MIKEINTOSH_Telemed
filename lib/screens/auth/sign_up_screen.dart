import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/gender_model.dart';
import 'package:kivicare_flutter/network/patient_list_repository.dart';
import 'package:kivicare_flutter/screens/auth/components/login_register_widget.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  List<String> bloodGroupList = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];
  List<GenderModel> genderList = [];

  TextEditingController emailCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController contactNumberCont = TextEditingController();
  TextEditingController dOBCont = TextEditingController();
  String? genderValue;
  String? bloodGroup;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode dOBFocus = FocusNode();
  FocusNode bloodGroupFocus = FocusNode();

  late DateTime birthDate;

  int selectedGender = -1;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    genderList.add(GenderModel(name: locale.lblMale, value: "Male"));
    genderList.add(GenderModel(name: locale.lblFemale, value: "Female"));
    genderList.add(GenderModel(name: locale.lblOther, value: "Other"));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      Map request = {
        "first_name": firstNameCont.text.validate(),
        "last_name": lastNameCont.text.validate(),
        "user_email": emailCont.text.validate(),
        "mobile_number": contactNumberCont.text.validate(),
        "gender": genderValue.validate().toLowerCase(),
        "dob": birthDate.getFormattedDate(CONVERT_DATE).validate(),
        "blood_group": bloodGroup.validate(),
      };

      await addNewPatientData(request).then((value) {
        finish(context, true);
        toast(locale.lblRegisteredSuccessfully);
      }).catchError((e) {
        toast(e.toString());
      });

      appStore.setLoading(false);
    }
  }

  Future<void> dateBottomSheet(context, {DateTime? bDate}) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext e) {
        return Container(
          height: 245,
          color: appStore.isDarkModeOn ? Colors.black : Colors.white,
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.lblCancel, style: boldTextStyle()).onTap(() {
                      finish(context);
                    }),
                    Text(locale.lblDone, style: boldTextStyle()).onTap(() {
                      if (DateTime.now().year - birthDate.year < 18) {
                        toast(
                          locale.lblMinimumAgeRequired + locale.lblCurrentAgeIs + ' ${DateTime.now().year - birthDate.year}',
                          bgColor: errorBackGroundColor,
                          textColor: errorTextColor,
                        );
                      } else {
                        finish(context);
                        dOBCont.text = birthDate.getFormattedDate(BIRTH_DATE_FORMAT).toString();
                      }
                    })
                  ],
                ).paddingOnly(top: 8, left: 8, right: 8, bottom: 8),
              ),
              Container(
                height: 200,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(dateTimePickerTextStyle: primaryTextStyle(size: 20)),
                  ),
                  child: CupertinoDatePicker(
                    minimumDate: DateTime(1900, 1, 1),
                    minuteInterval: 1,
                    initialDateTime: bDate == null ? DateTime.now() : bDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      birthDate = dateTime;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Body(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      64.height,
                      Image.asset(appIcon, height: 100, width: 100),
                      16.height,
                      RichTextWidget(
                        list: [
                          TextSpan(text: APP_FIRST_NAME, style: boldTextStyle(size: 32, letterSpacing: 1)),
                          TextSpan(text: APP_SECOND_NAME, style: primaryTextStyle(size: 32, letterSpacing: 1)),
                        ],
                      ).center(),
                      32.height,
                      Text(locale.lblSignUpAsPatient, style: secondaryTextStyle(size: 14)),
                      24.height,
                      AppTextField(
                        textStyle: primaryTextStyle(),
                        controller: firstNameCont,
                        textFieldType: TextFieldType.NAME,
                        focus: firstNameFocus,
                        errorThisFieldRequired: locale.lblFirstNameIsRequired,
                        nextFocus: lastNameFocus,
                        decoration: inputDecoration(
                          context: context,
                          labelText: locale.lblFirstName,
                        ).copyWith(suffixIcon: ic_user.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(),
                        controller: lastNameCont,
                        textFieldType: TextFieldType.NAME,
                        focus: lastNameFocus,
                        nextFocus: emailFocus,
                        errorThisFieldRequired: locale.lblLastNameIsRequired,
                        decoration: inputDecoration(
                          context: context,
                          labelText: locale.lblLastName,
                        ).copyWith(suffixIcon: ic_user.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(),
                        controller: emailCont,
                        textFieldType: TextFieldType.EMAIL,
                        focus: emailFocus,
                        nextFocus: passwordFocus,
                        decoration: inputDecoration(
                          context: context,
                          labelText: locale.lblEmail,
                        ).copyWith(suffixIcon: ic_message.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(),
                        controller: contactNumberCont,
                        focus: contactNumberFocus,
                        nextFocus: dOBFocus,
                        textFieldType: TextFieldType.PHONE,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        isValidationRequired: true,
                        decoration: inputDecoration(
                          context: context,
                          labelText: locale.lblContactNumber,
                        ).copyWith(suffixIcon: ic_phone.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(),
                        controller: dOBCont,
                        nextFocus: bloodGroupFocus,
                        focus: dOBFocus,
                        textFieldType: TextFieldType.NAME,
                        errorThisFieldRequired: locale.lblBirthDateIsRequired,
                        readOnly: true,
                        onTap: () {
                          dateBottomSheet(context);
                        },
                        decoration: inputDecoration(
                          context: context,
                          labelText: locale.lblDOB,
                        ).copyWith(suffixIcon: ic_calendar.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                      ),
                      16.height,
                      DropdownButtonFormField(
                        icon: SizedBox.shrink(),
                        isExpanded: true,
                        focusColor: primaryColor,
                        dropdownColor: context.cardColor,
                        focusNode: bloodGroupFocus,
                        decoration: inputDecoration(
                          context: context,
                          labelText: locale.lblBloodGroup,
                        ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                        validator: (dynamic s) {
                          if (s == null) return locale.lblBloodGroupIsRequired;
                          return null;
                        },
                        onChanged: (dynamic value) {
                          bloodGroup = value;
                        },
                        items: bloodGroupList
                            .map(
                              (bloodGroup) => DropdownMenuItem(
                                value: bloodGroup,
                                child: Text("$bloodGroup", style: primaryTextStyle()),
                              ),
                            )
                            .toList(),
                      ),
                      16.height,
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text("${locale.lblGender1} ${"*"}", style: primaryTextStyle(size: 12)),
                      ),
                      8.height,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
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
                              genderValue = genderList[index].value;
                              selectedGender = index;
                              setState(() {});
                            }, borderRadius: BorderRadius.circular(defaultRadius)).paddingRight(16);
                          },
                        ),
                      ),
                      60.height,
                      AppButton(
                        width: context.width(),
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                        color: primaryColor,
                        padding: EdgeInsets.all(16),
                        child: Text(locale.lblSubmit, style: boldTextStyle(color: textPrimaryDarkColor)),
                        onTap: () {
                          signUp();
                        },
                      ),
                      24.height,
                      LoginRegisterWidget(
                        title: locale.lblAlreadyAMember,
                        subTitle: locale.lblLogin,
                        onTap: () {
                          finish(context);
                        },
                      ),
                      24.height,
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () {
                      finish(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
