import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/gender_selection_component.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/network/patient_list_repository.dart';
import 'package:kivicare_flutter/screens/auth/screens/map_screen.dart';
import 'package:kivicare_flutter/services/location_service.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';

class AddPatientScreen extends StatefulWidget {
  final int? userId;

  AddPatientScreen({this.userId});

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  UniqueKey genderKey = UniqueKey();
  GlobalKey<FormState> passwordFormKey = GlobalKey();

  DateTime? birthDate;

  String? bloodGroup;
  String? userLogin = "";

  bool isUpdate = false;
  bool isFirstTime = true;

  List<String> bloodGroupList = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController contactNumberCont = TextEditingController();
  TextEditingController dOBCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController countryCont = TextEditingController();

  TextEditingController stateCont = TextEditingController();
  TextEditingController postalCodeCont = TextEditingController();
  TextEditingController genderCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode dOBFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode countryFocus = FocusNode();

  FocusNode stateFocus = FocusNode();
  FocusNode postalCodeFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isUpdate = widget.userId != null;
    birthDate = DateTime.now();
    if (isUpdate) {
      appStore.setLoading(true);

      await getSingleUserDetailAPI(widget.userId).then((value) {
        appStore.setLoading(false);
        firstNameCont.text = value.firstName.validate();
        lastNameCont.text = value.lastName.validate();
        emailCont.text = value.userEmail.validate();
        contactNumberCont.text = value.mobileNumber.validate();
        addressCont.text = value.address.validate(value: '');
        cityCont.text = value.city.validate();
        countryCont.text = value.country.validate();
        postalCodeCont.text = value.postalCode.validate();
        userLogin = value.userLogin.validate();
        genderCont.text = value.gender.validate();
        genderKey = UniqueKey();
        dOBCont.text = value.dob.validate();
        if (!value.dob.isEmptyOrNull) birthDate = DateTime.parse(value.dob.validate(value: ' '));
        if (!value.bloodGroup.isEmptyOrNull) bloodGroup = value.bloodGroup.validate(value: '');
        setState(() {});
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  Future<void> _handleSetLocationClick() async {
    final hasPermission = await handlePermission();

    if (!hasPermission) {
      throw locale.lblPermissionDenied;
    }
    if (hasPermission) {
      String? res = await MapScreen(latitude: getDoubleAsync(SharedPreferenceKey.latitudeKey), latLong: getDoubleAsync(SharedPreferenceKey.longitudeKey)).launch(context);

      if (res != null) {
        addressCont.text = res;
        setState(() {});
      }
    }
  }

  Future<void> _handleCurrentLocationClick() async {
    final hasPermission = await handlePermission();

    if (!hasPermission) {
      throw locale.lblPermissionDenied;
    }
    if (hasPermission) {
      appStore.setLoading(true);

      await getUserLocation().then((value) {
        addressCont.text = value;

        setState(() {});
        appStore.setLoading(false);
      }).catchError((e) {
        log(e);
        toast(e.toString());
      });

      appStore.setLoading(false);
    }
  }

  void addNewPatientDetail() async {
    appStore.setLoading(true);

    Map request = {
      "first_name": firstNameCont.text.validate(),
      "last_name": lastNameCont.text.validate(),
      "user_email": emailCont.text.validate(),
      "mobile_number": contactNumberCont.text.validate(),
      "gender": genderCont.text.toLowerCase(),
      "dob": birthDate!.getFormattedDate(SAVE_DATE_FORMAT).validate(),
      "address": addressCont.text.validate(),
      "city": cityCont.text.validate(),
      "country": countryCont.text.validate(),
      "postal_code": postalCodeCont.text.validate(),
      "blood_group": bloodGroup.validate(),
      'role': UserRolePatient,
    };
    request.putIfAbsent('clinic_id', () => userStore.userClinicId.validate());

    await addNewUserAPI(request).then((value) {
      appStore.setLoading(false);
      toast(locale.lblNewPatientAddedSuccessfully);
      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void updatePatientDetail() async {
    appStore.setLoading(true);

    Map request = {
      "ID": widget.userId,
      "first_name": firstNameCont.text.validate(),
      "last_name": lastNameCont.text.validate(),
      "user_email": emailCont.text.validate(),
      "mobile_number": contactNumberCont.text.validate(),
      "gender": genderCont.text.validate(),
      "dob": birthDate != null ? birthDate!.getFormattedDate(SAVE_DATE_FORMAT).validate() : null,
      "address": addressCont.text.validate(),
      "city": cityCont.text.validate(),
      "country": countryCont.text.validate(),
      "postal_code": postalCodeCont.text.validate(),
      "blood_group": bloodGroup.validate(),
      "user_login": userLogin,
      'role': UserRolePatient,
    };

    log(request);

    await updatePatientDataAPI(request).then((value) {
      appStore.setLoading(false);
      toast(locale.lblPatientDetailUpdatedSuccessfully);
      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void savePatientDetails() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      showConfirmDialogCustom(
        context,
        primaryColor: context.primaryColor,
        width: context.width() * 0.7,
        height: context.height() * 0.2,
        dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
        title: isUpdate ? locale.lblDoYouWantToUpdatePatientDetails : locale.lblDoYouWantToSaveNewPatientDetails,
        positiveText: locale.lblYes,
        negativeText: locale.lblCancel,
        onAccept: (p0) {
          isUpdate
              ? ifTester(context, () {
                  updatePatientDetail();
                }, userEmail: emailCont.text.validate())
              : addNewPatientDetail();
        },
      );
    } else {
      isFirstTime = false;
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    /*getDisposeStatusBarColor();*/
    super.dispose();
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
                    Text(locale.lblCancel, style: boldTextStyle()).appOnTap(
                      () {
                        finish(context);
                      },
                    ),
                    Text(locale.lblDone, style: boldTextStyle()).appOnTap(
                      () {
                        if (DateTime.now().year - birthDate!.year < 18) {
                          toast(locale.lblMinimumAgeRequired + locale.lblCurrentAgeIs + ' ${DateTime.now().year - birthDate!.year}');
                        } else {
                          finish(context);
                          dOBCont.text = birthDate!.getFormattedDate(SAVE_DATE_FORMAT).toString();
                        }
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    )
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? locale.lblEditPatientDetail : locale.lblAddNewPatient,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
            child: AnimatedScrollView(
              padding: EdgeInsets.only(bottom: 80, left: 16, right: 16, top: 16),
              listAnimationType: ListAnimationType.None,
              children: [
                Text(locale.lblBasicInformation, style: boldTextStyle(size: titleTextSize, color: context.primaryColor)),
                Divider(color: viewLineColor, height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      children: [
                        AppTextField(
                          focus: firstNameFocus,
                          controller: firstNameCont,
                          nextFocus: lastNameFocus,
                          textFieldType: TextFieldType.NAME,
                          textInputAction: TextInputAction.next,
                          errorThisFieldRequired: locale.lblFirstNameIsRequired,
                          decoration: inputDecoration(context: context, labelText: locale.lblFirstName),
                        ).expand(),
                        16.width,
                        AppTextField(
                          focus: lastNameFocus,
                          controller: lastNameCont,
                          nextFocus: emailFocus,
                          textInputAction: TextInputAction.next,
                          errorThisFieldRequired: locale.lblLastNameIsRequired,
                          textFieldType: TextFieldType.NAME,
                          decoration: inputDecoration(context: context, labelText: locale.lblLastName),
                        ).expand(),
                      ],
                    ),
                    AppTextField(
                      controller: emailCont,
                      focus: emailFocus,
                      nextFocus: contactNumberFocus,
                      textInputAction: TextInputAction.next,
                      textFieldType: TextFieldType.EMAIL,
                      errorThisFieldRequired: locale.lblEmailIsRequired,
                      decoration: inputDecoration(context: context, labelText: locale.lblEmail, suffixIcon: ic_message.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                    ),
                    AppTextField(
                      focus: contactNumberFocus,
                      nextFocus: dOBFocus,
                      controller: contactNumberCont,
                      textFieldType: TextFieldType.PHONE,
                      textInputAction: TextInputAction.next,
                      maxLength: 10,
                      isValidationRequired: true,
                      buildCounter: (context, {int? currentLength, bool? isFocused, maxLength}) {
                        return null;
                      },
                      validator: (value) {
                        if (contactNumberCont.text.length < 10) return locale.lblPleaseCheckYourNumber;
                        return null;
                      },
                      decoration: inputDecoration(context: context, labelText: locale.lblContactNumber, suffixIcon: ic_phone.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                    ),
                    AppTextField(
                      controller: dOBCont,
                      focus: dOBFocus,
                      nextFocus: genderFocus,
                      textInputAction: TextInputAction.next,
                      textFieldType: TextFieldType.OTHER,
                      readOnly: true,
                      isValidationRequired: true,
                      validator: (value) {
                        if (dOBCont.text.isEmptyOrNull) return locale.lblBirthDateIsRequired;
                        return null;
                      },
                      errorThisFieldRequired: locale.lblBirthDateIsRequired,
                      decoration: inputDecoration(context: context, labelText: locale.lblDOB, suffixIcon: ic_calendar.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                      onTap: () {
                        if (dOBCont.text.isNotEmpty) {
                          dateBottomSheet(context, bDate: birthDate);
                        } else {
                          dateBottomSheet(context);
                        }
                      },
                    ),
                  ],
                ),
                DropdownButtonFormField(
                  value: bloodGroup,
                  borderRadius: radius(),
                  icon: SizedBox.shrink(),
                  isExpanded: true,
                  dropdownColor: context.cardColor,
                  items: List.generate(
                    bloodGroupList.length,
                    (index) => DropdownMenuItem(value: bloodGroupList[index], child: Text("${bloodGroupList[index]}", style: primaryTextStyle())),
                  ),
                  decoration: inputDecoration(context: context, labelText: locale.lblBloodGroup, suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                  onChanged: (dynamic value) {
                    bloodGroup = value;
                    setState(() {});
                  },
                ).paddingSymmetric(vertical: 16),
                GenderSelectionComponent(
                  key: genderKey,
                  type: genderCont.text,
                  onTap: (String value) {
                    genderCont.text = value;
                  },
                ),
                24.height,
                Text(locale.lblAddressDetail, style: boldTextStyle(size: titleTextSize, color: context.primaryColor)),
                Divider(color: viewLineColor, height: 24),
                Wrap(
                  runSpacing: 16,
                  children: [
                    AppTextField(
                      controller: addressCont,
                      focus: addressFocus,
                      nextFocus: cityFocus,
                      isValidationRequired: false,
                      textFieldType: TextFieldType.MULTILINE,
                      minLines: 2,
                      maxLines: 2,
                      textInputAction: TextInputAction.newline,
                      decoration: inputDecoration(context: context, labelText: locale.lblAddress),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: Text(locale.chooseFromMap, style: boldTextStyle(color: primaryColor, size: 13)),
                          onPressed: () {
                            _handleSetLocationClick();
                          },
                        ).flexible(),
                        TextButton(
                          onPressed: _handleCurrentLocationClick,
                          child: Text(locale.currentLocation, style: boldTextStyle(color: primaryColor, size: 13), textAlign: TextAlign.right),
                        ).flexible(),
                      ],
                    ),
                    AppTextField(
                      controller: countryCont,
                      focus: countryFocus,
                      nextFocus: cityFocus,
                      textInputAction: TextInputAction.next,
                      textFieldType: TextFieldType.OTHER,
                      decoration: inputDecoration(context: context, labelText: locale.lblCountry),
                    ),
                    Row(
                      children: [
                        AppTextField(
                          controller: cityCont,
                          focus: cityFocus,
                          nextFocus: postalCodeFocus,
                          textInputAction: TextInputAction.next,
                          textFieldType: TextFieldType.OTHER,
                          decoration: inputDecoration(context: context, labelText: locale.lblCity),
                        ).expand(),
                        16.width,
                        AppTextField(
                          controller: postalCodeCont,
                          focus: postalCodeFocus,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // Only allows digits
                          ],
                          textFieldType: TextFieldType.OTHER,
                          textInputAction: TextInputAction.done,
                          decoration: inputDecoration(context: context, labelText: locale.lblPostalCode),
                        ).expand()
                      ],
                    ),
                  ],
                ).paddingSymmetric(vertical: 16),
              ],
            ),
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading).center())
        ],
      ),
      bottomNavigationBar: AppButton(text: locale.lblSave, onTap: savePatientDetails).paddingAll(16),
    );
  }
}
