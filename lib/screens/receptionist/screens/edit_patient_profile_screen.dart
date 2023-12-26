import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/gender_model.dart';
import 'package:kivicare_flutter/model/get_doctor_detail_model.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class EditPatientProfileScreen extends StatefulWidget {
  @override
  _EditPatientProfileScreenState createState() => _EditPatientProfileScreenState();
}

class _EditPatientProfileScreenState extends State<EditPatientProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  AsyncMemoizer<GetDoctorDetailModel> _memorizer = AsyncMemoizer();

  int selectedGender = -1;

  bool isFirst = true;

  PickedFile? selectedImage;

  List<GenderModel> genderList = [];

  var picked = DateTime.now();

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

  @override
  void initState() {
    super.initState();
    init();
  }

  void addEditedData() async {
    appStore.setLoading(true);

    Map<String, dynamic> qualificationRequest = {
      "ID": "${getIntAsync(USER_ID)}",
      "user_email": "${emailCont.text}",
      "first_name": "${firstNameCont.text}",
      "last_name": "${lastNameCont.text}",
      "gender": "$genderValue",
      "dob": "${picked.toString().getFormattedDate(CONVERT_DATE)}",
      "address": "${addressCont.text}",
      "city": "${cityCont.text}",
      "country": "${countryCont.text}",
      "state": "${countryCont.text}",
      "postal_code": "${postalCodeCont.text}",
      "mobile_number": "${contactNumberCont.text}",
      "profile_image": "",
    };

    await updatePatientProfile(qualificationRequest, file: selectedImage != null ? File(selectedImage!.path) : null).then((value) {
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  init() async {
    genderList.add(GenderModel(name: locale.lblMale, icon: FontAwesomeIcons.person, value: "male"));
    genderList.add(GenderModel(name: locale.lblFemale, icon: FontAwesomeIcons.personDress, value: "female"));
    genderList.add(GenderModel(name: locale.lblOther, icon: FontAwesomeIcons.personDress, value: "other"));
    // getDoctorDetails();
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  void getReceiptionistDetails(GetDoctorDetailModel getDoctorDetail) {
    firstNameCont.text = getDoctorDetail.first_name.validate();
    lastNameCont.text = getDoctorDetail.last_name.validate();
    emailCont.text = getDoctorDetail.user_email.validate();
    contactNumberCont.text = getDoctorDetail.mobile_number.validate();
    if (getDoctorDetail.dob.validate().isNotEmpty) {
      dOBCont.text = getDoctorDetail.dob!.getFormattedDate(BIRTH_DATE_FORMAT).validate();
      picked = DateTime.parse(getDoctorDetail.dob!);
    }
    selectedGender = getDoctorDetail.gender == 'male' ? 0 : 1;
    genderValue = getDoctorDetail.gender;
    addressCont.text = getDoctorDetail.address.validate();
    cityCont.text = getDoctorDetail.city.validate();
    stateCont.text = getDoctorDetail.state.validate();
    countryCont.text = getDoctorDetail.country.validate();
    postalCodeCont.text = getDoctorDetail.postal_code.validate();
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
              Row(
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

  Future getImage() async {
    selectedImage = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100);

    setState(() {});
  }

  Widget editProfileBody() {
    return Body(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AnimatedScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 85),
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  decoration: boxDecorationDefault(color: appStore.isDarkModeOn ? cardDarkColor : context.scaffoldBackgroundColor, shape: BoxShape.circle),
                  child: selectedImage != null
                      ? Image.file(File(selectedImage!.path), height: 100, width: 100, fit: BoxFit.cover, alignment: Alignment.center).cornerRadiusWithClipRRect(180)
                      : CachedImageWidget(url: appStore.profileImage.validate(), height: 100, fit: BoxFit.cover, circle: true),
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
                )
              ],
            ).paddingOnly(top: 16, bottom: 16).center(),
            16.height,
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
            (getStringAsync(USER_EMAIL) == receptionistEmail || getStringAsync(USER_EMAIL) == doctorEmail || getStringAsync(USER_EMAIL) == patientEmail)
                ? AppTextField(
                    controller: emailCont,
                    focus: emailFocus,
                    nextFocus: contactNumberFocus,
                    textFieldType: TextFieldType.EMAIL,
                    readOnly: true,
                    decoration: inputDecoration(context: context, labelText: locale.lblEmail),
                    onTap: () {
                      toast(locale.lblDemoEmailCannotBeChanged);
                    },
                  )
                : AppTextField(
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
              textFieldType: TextFieldType.PHONE,
              decoration: inputDecoration(context: context, labelText: locale.lblContactNumber),
            ),
            16.height,
            AppTextField(
              controller: dOBCont,
              focus: dOBFocus,
              nextFocus: addressFocus,
              readOnly: true,
              isValidationRequired: true,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(context: context, labelText: locale.lblDOB),
              onTap: () {
                dateBottomSheet(context);
                if (dOBCont.text.isNotEmpty) {
                  hideKeyboard(context);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    genderList.length,
                    (index) {
                      return Container(
                        width: 90,
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                        decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            Text(genderList[index].name!, style: primaryTextStyle(size: 12, color: secondaryTxtColor)).flexible()
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
            AppTextField(
              controller: addressCont,
              focus: addressFocus,
              nextFocus: cityFocus,
              textFieldType: TextFieldType.MULTILINE,
              decoration: inputDecoration(context: context, labelText: locale.lblAddress).copyWith(alignLabelWithHint: true),
              minLines: 4,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
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
          ],
        ),
      ),
    );
  }

  Widget buildBodyWidget() {
    return FutureBuilder<GetDoctorDetailModel>(
      future: _memorizer.runOnce(() => getUserProfile(getIntAsync(USER_ID))),
      builder: (_, snap) {
        if (snap.hasData) {
          if (isFirst) {
            getReceiptionistDetails(snap.data!);
            isFirst = false;
          }
          return editProfileBody();
        }
        return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        locale.lblEditProfile,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: textPrimaryDarkColor),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            showConfirmDialogCustom(
              context,
              dialogType: DialogType.UPDATE,
              primaryColor: context.primaryColor,
              title: "Are you sure you want to update the form?",
              onAccept: (p0) {
                addEditedData();
              },
            );
          }
        },
      ),
    );
  }
}
