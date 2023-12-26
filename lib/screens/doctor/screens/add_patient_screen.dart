import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/gender_model.dart';
import 'package:kivicare_flutter/model/get_user_detail_model.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/network/patient_list_repository.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AddPatientScreen extends StatefulWidget {
  final int? userId;

  AddPatientScreen({this.userId});

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  GetUserDetailModel? getUserDetail;

  DateTime? birthDate;

  String? genderValue;
  String? bloodGroup;
  String? userLogin = "";

  bool isUpdate = false;

  List<GenderModel> genderList = [];

  List<String> bloodGroupList = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController contactNumberCont = TextEditingController();
  TextEditingController dOBCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController countryCont = TextEditingController();
  TextEditingController postalCodeCont = TextEditingController();

  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode dOBFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode postalCodeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    genderList.add(GenderModel(name: locale.lblMale, value: "Male"));
    genderList.add(GenderModel(name: locale.lblFemale, value: "Female"));
    genderList.add(GenderModel(name: locale.lblOther, value: "Other"));
    isUpdate = widget.userId != null;
    if (isUpdate) {
      appStore.setLoading(true);

      await getUserDetails(widget.userId).then((value) {
        getUserDetail = value;

        firstNameCont.text = getUserDetail!.first_name.validate();
        lastNameCont.text = getUserDetail!.last_name.validate();
        emailCont.text = getUserDetail!.user_email.validate();
        if (getUserDetail!.dob.validate().isNotEmpty) if (getUserDetail!.dob.validate().isNotEmpty) {
          dOBCont.text = getUserDetail!.dob.validate();
          birthDate = DateTime.parse(getUserDetail!.dob.validate());
        }
        contactNumberCont.text = getUserDetail!.mobile_number.validate();
        if (getUserDetail!.gender.validate().isNotEmpty) genderValue = getUserDetail!.gender.capitalizeFirstLetter().validate();
        addressCont.text = getUserDetail!.address.validate();
        cityCont.text = getUserDetail!.city.validate();
        countryCont.text = getUserDetail!.country.validate();
        postalCodeCont.text = getUserDetail!.postal_code.validate();
        if (getUserDetail!.blood_group.validate().isNotEmpty) {
          bloodGroup = getUserDetail!.blood_group.validate(value: '');
        }
        userLogin = getUserDetail!.user_login.validate();
      }).catchError((e) {
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
      "gender": genderValue.validate().toLowerCase(),
      "dob": birthDate!.getFormattedDate(CONVERT_DATE).validate(),
      "address": addressCont.text.validate(),
      "city": cityCont.text.validate(),
      "country": countryCont.text.validate(),
      "postal_code": postalCodeCont.text.validate(),
      "blood_group": bloodGroup.validate(),
    };

    await addNewPatientData(request).then((value) {
      finish(context, true);
      toast(locale.lblNewPatientAddedSuccessfully);
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  void updatePatientDetail() async {
    appStore.setLoading(true);

    Map request = {
      "ID": widget.userId,
      "first_name": firstNameCont.text.validate(),
      "last_name": lastNameCont.text.validate(),
      "user_email": emailCont.text.validate(),
      "mobile_number": contactNumberCont.text.validate(),
      "gender": genderValue.validate(),
      "dob": birthDate != null ? birthDate!.getFormattedDate(CONVERT_DATE).validate() : null,
      "address": addressCont.text.validate(),
      "city": cityCont.text.validate(),
      "country": countryCont.text.validate(),
      "postal_code": postalCodeCont.text.validate(),
      "blood_group": bloodGroup.validate(),
      "user_login": userLogin,
    };

    await updatePatientData(request).then((value) {
      toast(locale.lblPatientDetailUpdatedSuccessfully);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
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
                      if (DateTime.now().year - birthDate!.year < 18) {
                        toast(locale.lblMinimumAgeRequired + locale.lblCurrentAgeIs + ' ${DateTime.now().year - birthDate!.year}');
                      } else {
                        finish(context);
                        dOBCont.text = birthDate!.getFormattedDate(BIRTH_DATE_FORMAT).toString();
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
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  Widget buildBodyWidget() {
    return Body(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AnimatedScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 90),
          children: [
            Text(locale.lblBasicInformation, style: boldTextStyle(size: titleTextSize)),
            16.height,
            AppTextField(
              controller: firstNameCont,
              nextFocus: lastNameFocus,
              textFieldType: TextFieldType.NAME,
              errorThisFieldRequired: locale.lblFirstNameIsRequired,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblFirstName,
              ).copyWith(suffixIcon: ic_user.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              controller: lastNameCont,
              nextFocus: emailFocus,
              errorThisFieldRequired: locale.lblLastNameIsRequired,
              textFieldType: TextFieldType.NAME,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblLastName,
              ).copyWith(suffixIcon: ic_user.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              controller: emailCont,
              nextFocus: contactNumberFocus,
              textFieldType: TextFieldType.EMAIL,
              errorThisFieldRequired: locale.lblEmailIsRequired,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblEmail,
              ).copyWith(suffixIcon: ic_message.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              nextFocus: dOBFocus,
              controller: contactNumberCont,
              textFieldType: TextFieldType.PHONE,
              maxLength: 10,
              isValidationRequired: true,
              buildCounter: (context, {int? currentLength, bool? isFocused, maxLength}) {
                return null;
              },
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblContactNumber,
              ).copyWith(suffixIcon: ic_phone.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              controller: dOBCont,
              focus: dOBFocus,
              nextFocus: genderFocus,
              textFieldType: TextFieldType.OTHER,
              readOnly: true,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblDOB,
              ).copyWith(suffixIcon: ic_calendar.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
              onTap: () {
                if (dOBCont.text.isNotEmpty) {
                  dateBottomSheet(context, bDate: birthDate);
                } else {
                  dateBottomSheet(context);
                }
              },
            ),
            16.height,
            DropdownButtonFormField(
              value: genderValue,
              icon: SizedBox.shrink(),
              isExpanded: true,
              dropdownColor: context.cardColor,
              focusColor: appPrimaryColor,
              items: List.generate(
                genderList.length,
                (index) => DropdownMenuItem(
                  value: genderList[index].value,
                  child: Text("${genderList[index].name}", style: primaryTextStyle()),
                ),
              ),
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblGender,
              ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
              onChanged: (dynamic value) {
                genderValue = value;
                setState(() {});
              },
              validator: (dynamic s) {
                if (s == null) return locale.lblGenderIsRequired;
                return null;
              },
            ),
            16.height,
            DropdownButtonFormField(
              value: bloodGroup,
              icon: SizedBox.shrink(),
              isExpanded: true,
              dropdownColor: context.cardColor,
              items: List.generate(
                bloodGroupList.length,
                (index) => DropdownMenuItem(value: bloodGroupList[index], child: Text("${bloodGroupList[index]}", style: primaryTextStyle())),
              ),
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblBloodGroup,
              ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
              onChanged: (dynamic value) {
                bloodGroup = value;
                setState(() {});
              },
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
              ).copyWith(
                suffixIcon: Icon(Icons.location_on_outlined, size: 16, color: appStore.isDarkModeOn ? context.iconColor : Colors.black26),
              ),
            ),
            16.height,
            AppTextField(
              controller: cityCont,
              focus: cityFocus,
              nextFocus: countryFocus,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblCity,
              ).copyWith(
                suffixIcon: Icon(Icons.location_on_outlined, size: 16, color: appStore.isDarkModeOn ? context.iconColor : Colors.black26),
              ),
            ),
            16.height,
            Row(
              children: [
                AppTextField(
                  controller: countryCont,
                  focus: countryFocus,
                  nextFocus: postalCodeFocus,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblCountry,
                  ).copyWith(suffixIcon: Icon(Icons.location_on_outlined, size: 16, color: appStore.isDarkModeOn ? context.iconColor : Colors.black26)),
                ).expand(),
                15.width,
                AppTextField(
                  controller: postalCodeCont,
                  focus: postalCodeFocus,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblPostalCode,
                  ).copyWith(suffixIcon: Icon(Icons.location_on_outlined, size: 16, color: appStore.isDarkModeOn ? context.iconColor : Colors.black26)),
                ).expand(),
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
      appBar: appBarWidget(
        isUpdate ? locale.lblEditPatientDetail : locale.lblAddNewPatient,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            showConfirmDialogCustom(
              context,
              dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
              primaryColor: context.primaryColor,
              title: "Are you sure you want to submit the form?",
              onAccept: (p0) {
                isUpdate ? updatePatientDetail() : addNewPatientDetail();
              },
            );
          }
        },
      ),
    );
  }
}
