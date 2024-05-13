import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/custom_image_picker.dart';
import 'package:kivicare_flutter/components/gender_selection_component.dart';
import 'package:kivicare_flutter/components/internet_connectivity_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/qualification_model.dart';
import 'package:kivicare_flutter/model/static_data_model.dart';
import 'package:kivicare_flutter/model/user_model.dart';
import 'package:kivicare_flutter/network/doctor_repository.dart';
import 'package:kivicare_flutter/screens/auth/components/qualification_widget.dart';
import 'package:kivicare_flutter/screens/auth/screens/map_screen.dart';
import 'package:kivicare_flutter/screens/doctor/screens/add_qualification_screen.dart';
import 'package:kivicare_flutter/screens/receptionist/components/multi_select_specialization.dart';
import 'package:kivicare_flutter/screens/receptionist/components/qualification_item_widget.dart';
import 'package:kivicare_flutter/services/location_service.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/enums.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AddDoctorScreen extends StatefulWidget {
  final UserModel? doctorData;
  final VoidCallback? refreshCall;

  AddDoctorScreen({Key? key, this.refreshCall, this.doctorData}) : super(key: key);

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  UniqueKey genderKey = UniqueKey();

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userLogin = TextEditingController();
  TextEditingController contactNumberCont = TextEditingController();
  TextEditingController dobCont = TextEditingController();

  TextEditingController genderCont = TextEditingController();
  TextEditingController specializationCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController postalCodeCont = TextEditingController();

  TextEditingController stateCont = TextEditingController();
  TextEditingController countryCont = TextEditingController();
  TextEditingController experienceCont = TextEditingController();
  TextEditingController signatureCont = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode dobFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  FocusNode specializationFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode postalCodeFocus = FocusNode();
  FocusNode experienceFocus = FocusNode();
  File? selectedProfileImage;

  DateTime selectedDate = DateTime.now();

  List<Qualification> qualificationList = [];
  Qualification qualification = Qualification();

  bool isUpdate = false;
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    multiSelectStore.clearStaticList();
    isUpdate = widget.doctorData != null;

    if (isUpdate) {
      firstNameCont.text = widget.doctorData!.firstName.validate();
      lastNameCont.text = widget.doctorData!.lastName.validate();
      userLogin.text = widget.doctorData!.userLogin.validate();
      emailCont.text = widget.doctorData!.userEmail.validate();
      contactNumberCont.text = widget.doctorData!.mobileNumber.validate();

      if (widget.doctorData!.dob.validate().isNotEmpty) {
        selectedDate = DateFormat(SAVE_DATE_FORMAT).parse(widget.doctorData!.dob.validate());
        dobCont.text = selectedDate.getFormattedDate(SAVE_DATE_FORMAT);
      }
      genderCont.text = widget.doctorData!.gender.validate();
      addressCont.text = widget.doctorData!.address.validate();
      countryCont.text = widget.doctorData!.country.validate();
      cityCont.text = widget.doctorData!.city.validate();
      postalCodeCont.text = widget.doctorData!.postalCode.validate();

      experienceCont.text = widget.doctorData!.noOfExperience.validate().toString();
      signatureCont.text = widget.doctorData!.signatureImg.validate();
      qualificationList = widget.doctorData!.qualifications.validate();

      widget.doctorData!.specialties.validate().forEach((e) {
        multiSelectStore.selectedStaticData.add(StaticData(id: e.id, label: e.label));
      });
      genderKey = UniqueKey();
      setState(() {});
    }
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _chooseImage() async {
    await showInDialog(
      context,
      contentPadding: EdgeInsets.symmetric(vertical: 16),
      title: Text(locale.lblChooseAction, style: boldTextStyle()),
      builder: (p0) {
        return FilePickerDialog(isSelected: (false));
      },
    ).then((file) async {
      if (file != null) {
        if (file == GalleryFileTypes.CAMERA) {
          await getCameraImage().then((value) {
            selectedProfileImage = value;
            setState(() {});
          });
        } else if (file == GalleryFileTypes.GALLERY) {
          await getCameraImage(isCamera: false).then((value) {
            selectedProfileImage = value;
            setState(() {});
          });
        }
      } else {}
    });
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
                        if (DateTime.now().year - selectedDate.year < 18) {
                          toast(locale.lblMinimumAgeRequired + locale.lblCurrentAgeIs + ' ${DateTime.now().year - selectedDate.year}');
                        } else {
                          finish(context);
                          dobCont.text = selectedDate.getFormattedDate(SAVE_DATE_FORMAT).toString();
                        }
                      },
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
                      selectedDate = dateTime;
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
      }).catchError((e) {
        log(e);
        toast(e.toString());
      });

      appStore.setLoading(false);
    }
  }

  //region Widgets

  Widget buildQualificationWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(locale.lblQualification.getApostropheString(apostrophe: false), style: boldTextStyle(color: context.primaryColor, size: 18)).expand(),
              TextButton(
                onPressed: () async {
                  qualification = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: AddQualificationScreen(),
                    ),
                  );
                  qualificationList.add(qualification);
                  setState(() {});
                },
                child: Text(locale.lblAddNewQualification, style: secondaryTextStyle()),
              )
            ],
          ),
          Divider(color: viewLineColor, height: 0),
          8.height,
          if (qualificationList.validate().isNotEmpty)
            AnimatedListView(
              shrinkWrap: true,
              itemCount: qualificationList.validate().length,
              itemBuilder: (context, index) => QualificationItemWidget(
                data: qualificationList[index],
                onEdit: () async {
                  qualification = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: AddQualificationScreen(qualification: qualificationList[index]),
                    ),
                  );
                  qualificationList[index] = qualification;
                  setState(() {});
                },
              ),
            )
          else
            NoDataFoundWidget(iconSize: 100, text: locale.lblNoQualificationsFound).center(),
        ],
      ),
    );
  }

  //endregion

  void saveDoctorDetails() async {
    appStore.setLoading(true);

    Map<String, dynamic> request = {
      "first_name": firstNameCont.text.toString(),
      "last_name": lastNameCont.text.toString(),
      "user_email": emailCont.text.toString(),
      "user_login": userLogin.text.toString(),
      "mobile_number": contactNumberCont.text.toString(),
      "dob": dobCont.text.toString(),
      "gender": genderCont.text.toString(),
      "clinic_id": "${userStore.userClinicId}",
      "specialties": jsonEncode(multiSelectStore.selectedStaticData),
      "no_of_experience": experienceCont.text,
      "address": addressCont.text.toString(),
      "country": countryCont.text.toString(),
      "city": cityCont.text.toString(),
      "postal_code": postalCodeCont.text,
      'qualifications': jsonEncode(qualificationList),
    };
    if (isUpdate) {
      request.putIfAbsent("ID", () => widget.doctorData!.iD.validate());
      request.putIfAbsent("user_login", () => userLogin.text);
    }

    log(request);

    await addUpdateDoctorDetailsAPI(data: request, profileImage: selectedProfileImage).then((value) {
      appStore.setLoading(false);
      toast(value);

      ///TODO ADD status for success to api
      if (value != DOCTOR_ADD_API_UNSUCCESS_MESSAGE) {
        widget.refreshCall?.call();
        finish(context, true);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? locale.lblEditProfile : locale.lblAddDoctorProfile,
        color: appPrimaryColor,
        elevation: 0,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        textColor: Colors.white,
      ),
      body: InternetConnectivityWidget(
        retryCallback: () async {
          await 1.seconds.delay;
          setState(() {});
        },
        child: Body(
          visibleOn: appStore.isLoading,
          child: Form(
            key: formKey,
            child: AnimatedScrollView(
              padding: EdgeInsets.only(bottom: 80, left: 16, right: 16, top: 16),
              listAnimationType: ListAnimationType.None,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecorationDefault(
                        color: appStore.isDarkModeOn ? cardDarkColor : context.scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: viewLineColor),
                      ),
                      child: selectedProfileImage != null
                          ? Image.file(selectedProfileImage!, fit: BoxFit.cover, width: 126, height: 126).cornerRadiusWithClipRRect(65)
                          : CachedImageWidget(
                              url: widget.doctorData != null
                                  ? widget.doctorData!.profileImage.validate().isEmpty
                                      ? ic_no_photo
                                      : widget.doctorData!.profileImage.validate()
                                  : ic_no_photo,
                              height: 126,
                              width: 126,
                              fit: BoxFit.cover,
                              circle: true,
                            ),
                    ).appOnTap(
                      () {
                        _chooseImage();
                      },
                      borderRadius: radius(65),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: boxDecorationDefault(color: appPrimaryColor, shape: BoxShape.circle, border: Border.all(color: white, width: 3)),
                        child: ic_camera.iconImage(size: 14, color: Colors.white),
                      ).appOnTap(
                        () {
                          _chooseImage();
                        },
                        borderRadius: radius(65),
                      ),
                    )
                  ],
                ).center(),
                Text(locale.lblBasicDetails, style: boldTextStyle(color: context.primaryColor, size: 18)),
                Divider(color: viewLineColor, height: 24),
                Wrap(
                  runSpacing: 16,
                  children: [
                    Row(
                      children: [
                        AppTextField(
                          controller: firstNameCont,
                          focus: firstNameFocus,
                          nextFocus: lastNameFocus,
                          textInputAction: TextInputAction.next,
                          textFieldType: TextFieldType.NAME,
                          decoration: inputDecoration(context: context, labelText: locale.lblFirstName),
                        ).expand(),
                        10.width,
                        AppTextField(
                          controller: lastNameCont,
                          focus: lastNameFocus,
                          textInputAction: TextInputAction.next,
                          nextFocus: emailFocus,
                          textFieldType: TextFieldType.NAME,
                          decoration: inputDecoration(context: context, labelText: locale.lblLastName),
                        ).expand(),
                      ],
                    ),
                    AppTextField(
                      controller: emailCont,
                      focus: emailFocus,
                      textInputAction: TextInputAction.next,
                      nextFocus: contactNumberFocus,
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecoration(context: context, labelText: locale.lblEmail),
                    ),
                    Row(
                      children: [
                        AppTextField(
                          controller: contactNumberCont,
                          focus: contactNumberFocus,
                          nextFocus: dobFocus,
                          inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          textFieldType: TextFieldType.PHONE,
                          decoration: inputDecoration(context: context, labelText: locale.lblContactNumber),
                        ).expand(),
                        16.width,
                        AppTextField(
                          controller: dobCont,
                          focus: dobFocus,
                          nextFocus: addressFocus,
                          readOnly: true,
                          isValidationRequired: true,
                          validator: (value) {
                            if (dobCont.text.isEmptyOrNull) return locale.lblBirthDateIsRequired;
                            return null;
                          },
                          errorThisFieldRequired: locale.lblBirthDateIsRequired,
                          textFieldType: TextFieldType.OTHER,
                          decoration: inputDecoration(context: context, labelText: locale.lblDOB),
                          keyboardAppearance: appStore.isDarkModeOn ? Brightness.dark : Brightness.light,
                          selectionControls: EmptyTextSelectionControls(),
                          onTap: () {
                            if (dobCont.text.isNotEmpty) {
                              dateBottomSheet(context, bDate: selectedDate);
                            } else {
                              dateBottomSheet(context);
                            }
                            if (dobCont.text.isNotEmpty) {
                              FocusScope.of(context).requestFocus(addressFocus);
                            }
                          },
                        ).expand(),
                      ],
                    ),
                    GenderSelectionComponent(
                      key: genderKey,
                      type: genderCont.text,
                      onTap: (value) {
                        genderCont.text = value;
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        MultiSelectSpecialization(selectedServicesId: multiSelectStore.selectedStaticData.validate().map((element) => element!.id.validate()).toList())
                            .launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 16, 16, 16),
                        width: context.width(),
                        decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
                        child: Observer(
                          builder: (_) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(locale.lblSpecialization, style: secondaryTextStyle()),
                                if (multiSelectStore.selectedStaticData.validate().isNotEmpty) 16.height,
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List.generate(
                                    multiSelectStore.selectedStaticData.length,
                                    (index) {
                                      StaticData data = multiSelectStore.selectedStaticData[index]!;
                                      return Chip(
                                        label: Text(data.label.validate(), style: primaryTextStyle()),
                                        backgroundColor: context.cardColor,
                                        deleteIcon: Icon(Icons.clear, size: 18),
                                        deleteIconColor: Colors.red,
                                        onDeleted: () {
                                          multiSelectStore.removeStaticItem(data);
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
                    AppTextField(
                      controller: experienceCont,
                      focus: experienceFocus,
                      nextFocus: addressFocus,
                      textInputAction: TextInputAction.next,
                      textFieldType: TextFieldType.OTHER,
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration(context: context, labelText: locale.lblExperience),
                    ),
                  ],
                ).paddingBottom(24),
                Text(locale.lblAddressDetail, style: boldTextStyle(color: context.primaryColor, size: 18)),
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
                ),
                16.height,
                QualificationWidget(
                  qualificationList: qualificationList,
                  callBack: (newQualificationList) {
                    qualificationList = newQualificationList;
                    setState(() {});
                  },
                ),
                if (isUpdate && signatureCont.text.validate().isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(locale.lblSignature, style: boldTextStyle(color: context.primaryColor, size: 18)),
                      if (signatureCont.text.validate().isNotEmpty) Image.memory(getImageFromBase64(signatureCont.text.validate())!).cornerRadiusWithClipRRect(defaultRadius),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppButton(
        text: locale.lblSave,
        onTap: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            showConfirmDialogCustom(
              context,
              primaryColor: context.primaryColor,
              width: context.width() * 0.7,
              height: context.height() * 0.2,
              dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
              title: isUpdate ? locale.lblDoYouWantToUpdateDoctorDetails : locale.lblDoYouWantToSaveNewDoctorDetails,
              positiveText: locale.lblYes,
              negativeText: locale.lblCancel,
              onAccept: (p0) {
                ifTester(context, () {
                  saveDoctorDetails();
                }, userEmail: emailCont.text);
              },
            );
          } else {
            isFirstTime = !isFirstTime;
            setState(() {});
          }
        },
      ).paddingAll(16),
    );
  }
}
