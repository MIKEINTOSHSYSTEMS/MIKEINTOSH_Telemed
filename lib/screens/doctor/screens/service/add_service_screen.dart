import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/custom_image_picker.dart';
import 'package:momona_healthcare/components/internet_connectivity_widget.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/role_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/clinic_list_model.dart';
import 'package:momona_healthcare/model/service_duration_model.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/model/static_data_model.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/network/dashboard_repository.dart';
import 'package:momona_healthcare/network/service_repository.dart';
import 'package:momona_healthcare/screens/doctor/components/multi_select_clinic_drop_down.dart';
import 'package:momona_healthcare/screens/doctor/screens/service/edit_service_data_screen.dart';
import 'package:momona_healthcare/screens/receptionist/components/multi_select_doctor_drop_down.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/enums.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AddServiceScreen extends StatefulWidget {
  final ServiceData? serviceData;
  final VoidCallback? callForRefresh;

  List<ServiceData>? serviceList;

  AddServiceScreen({this.serviceData, this.callForRefresh, this.serviceList});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  Future<StaticDataModel>? future;

  int selectedIndex = -1;

  bool isUpdate = false;
  bool isFirstTime = true;
  bool isFirst = false;
  bool? isActive;
  bool? isMultiSelection;
  bool? isTelemed;

  StaticData? category;
  DurationModel? selectedDuration;

  List<int> selectedUsersIdsList = [];
  List<UserModel> selectedDataList = [];
  List<Clinic> selectedClinicList = [];
  List<int> listOfMappingTableId = [];
  List<DurationModel> durationList = getServiceDuration();
  List<String> names = [];
  UserModel? selectedDoctorData;
  Clinic? selectedClinicData;

  TextEditingController serviceNameCont = TextEditingController();
  TextEditingController serviceCategoryCont = TextEditingController();

  TextEditingController chargesCont = TextEditingController();
  TextEditingController doctorCont = TextEditingController();
  TextEditingController clinicCont = TextEditingController();

  File? selectedProfileImage;

  List<File> serviceImage = [];

  FocusNode serviceCategoryFocus = FocusNode();
  FocusNode serviceNameFocus = FocusNode();
  FocusNode serviceChargesFocus = FocusNode();
  FocusNode doctorSelectionFocus = FocusNode();
  FocusNode serviceDurationFocus = FocusNode();
  FocusNode clinicFocus = FocusNode();

  int currentIndex = -1;

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() async {
    isUpdate = widget.serviceData != null;
    if (isDoctor()) {
      if (userStore.userData != null) selectedDoctorData = userStore.userData;
    }

    appStore.setLoading(true);
    future = getStaticDataResponseAPI(SERVICE_TYPE).then((value) {
      appStore.setLoading(false);
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });

    if (isUpdate) {
      serviceCategoryCont.text = widget.serviceData!.type.validate();
      serviceNameCont.text = widget.serviceData!.name.validate();

      if (isReceptionist()) serviceDataForReceptionistIfIsUpdate();
      if (isDoctor()) setInitialData();
    }
    setState(() {});
  }

  void serviceDataForReceptionistIfIsUpdate() {
    if (widget.serviceData!.doctorList != null && widget.serviceData!.doctorList.validate().isNotEmpty) {
      if (widget.serviceData!.doctorList.validate().length == 1) {
        setInitialData();
      } else {
        widget.serviceData!.doctorList.validate().forEach((element) {
          selectedUsersIdsList.add(element.doctorId.validate().toInt());
          selectedDataList.add(element);
        });
        isFirst = true;
      }

      if (selectedDataList.length > 1)
        doctorCont.text = selectedDataList.length.toString() + ' ${locale.lblDoctorsAvailable}';
      else {
        doctorCont.text = 'Dr. ' + selectedDoctorData!.displayName.validate();
      }
    }
  }

  void setInitialData() {
    if (isReceptionist()) {
      selectedDoctorData = widget.serviceData!.doctorList!.first;
      doctorCont.text = 'Dr. ' + selectedDoctorData!.displayName.validate();
      chargesCont.text = selectedDoctorData!.charges.validate();

      selectedUsersIdsList.add(selectedDoctorData!.doctorId.toInt());
      if (selectedDoctorData!.duration != null && selectedDoctorData!.duration.toInt() != 0) {
        selectedDuration = durationList.firstWhere((element) => element.value == selectedDoctorData!.duration.toInt());
      }
      if (selectedDoctorData!.status != null) isActive = selectedDoctorData!.status!.getBoolInt();
      if (selectedDoctorData!.multiple != null) isMultiSelection = selectedDoctorData!.multiple;
      isTelemed = selectedDoctorData!.isTelemed;
      selectedDataList.add(selectedDoctorData!);
    } else {
      if (isUpdate) {
        selectedDoctorData = userStore.userData != null ? userStore.userData : setDoctor(widget.serviceData!, userData: UserModel());
        selectedDoctorData!.serviceImage = widget.serviceData!.image.validate();
        selectedDoctorData!.mappingTableId = widget.serviceData!.mappingTableId.validate();

        selectedDoctorData!.clinicId = widget.serviceData!.clinicId.validate();
        isActive = widget.serviceData!.status!.getBoolInt();
        isMultiSelection = widget.serviceData!.multiple;
        isTelemed = widget.serviceData!.isTelemed;
        setState(() {});
        selectedDataList.add(selectedDoctorData!);
      }
      selectedClinicData = Clinic(name: widget.serviceData!.clinicName, id: widget.serviceData!.clinicId);
      clinicCont.text = selectedClinicData!.name.validate();
      selectedUsersIdsList.add(selectedClinicData!.id.toInt());
      selectedClinicList.add(selectedClinicData!);
      chargesCont.text = widget.serviceData!.charges.validate();
      if (widget.serviceData!.duration != null && (widget.serviceData!.duration.toInt() != 0 || widget.serviceData!.duration.validate().isNotEmpty)) {
        selectedDuration = durationList.firstWhere((element) => element.value == widget.serviceData!.duration.toInt());
      }
    }
  }

  void ifLengthIsGreater() {
    selectedUsersIdsList.clear();
    selectedDataList.forEach((element) {
      selectedUsersIdsList.add(element.doctorId.toInt());
    });
    if (selectedDataList.length == 1) {
      selectedDoctorData = selectedDataList.first;

      chargesCont.text = selectedDoctorData!.charges.validate();
      if (selectedDoctorData!.duration != null && selectedDoctorData!.duration.toInt() != 0) {
        selectedDuration = durationList.firstWhere((element) => element.value == selectedDoctorData!.duration.toInt());
      } else
        selectedDuration = null;

      if (selectedDoctorData!.status != null)
        isActive = selectedDoctorData!.status.getBoolInt();
      else
        isActive = null;
      if (selectedDoctorData!.multiple != null)
        isMultiSelection = selectedDoctorData!.multiple;
      else
        isMultiSelection = null;
      isTelemed = selectedDoctorData!.isTelemed;
      doctorCont.text = 'Dr. ' + selectedDoctorData!.displayName.validate();
      if (selectedDoctorData!.imageFile != null) {
        selectedProfileImage = selectedDoctorData!.imageFile;
      }
    } else {
      doctorCont.text = selectedDataList.length.toString() + " " + locale.lblDoctorsSelected;
    }
  }

  void _handleClick({bool addMappingTableId = false}) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      showConfirmDialogCustom(
        context,
        dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
        primaryColor: context.primaryColor,
        title: isUpdate ? locale.lblDoYouWantToUpdateService : locale.lblDoYouWantToAddNewService,
        onAccept: (c) async {
          Map<String, dynamic> req = {
            "type": serviceCategoryCont.text.isEmpty ? category?.value : serviceCategoryCont.text,
            "name": serviceNameCont.text,
          };
          if (isUpdate) req.putIfAbsent('id', () => widget.serviceData!.id.validate());
          if (isDoctor()) {
            if (selectedDataList.validate().isNotEmpty) {
              selectedDataList.forEachIndexed((element, index) {
                req.putIfAbsent('doctors[$index][charges]', () => chargesCont.text);
                req.putIfAbsent('doctors[$index][duration]', () => selectedDuration!.value.toString());
                req.putIfAbsent('doctors[$index][status]', () => isActive.getIntBool());
                req.putIfAbsent('doctors[$index][is_telemed]', () => isTelemed.getIntBool());
                req.putIfAbsent('doctors[$index][is_multiple_selection]', () => isMultiSelection.getIntBool());
                req.putIfAbsent('doctors[$index][doctor_id]', () => userStore.userId);
                req.putIfAbsent('doctors[$index][clinic_id]', () => element.clinicId);
                if (isUpdate) req.putIfAbsent('doctors[$index][mapping_table_id]', () => widget.serviceData?.mappingTableId);
              });
            }
          }
          if (isReceptionist()) {
            if (selectedDataList.length == 1) {
              selectedDataList.clear();
              selectedDoctorData!.charges = chargesCont.text;
              if (selectedDuration != null) {
                selectedDoctorData!.duration = selectedDuration!.value.toString();
              }
              selectedDoctorData!.status = isActive.getIntBool().toString();
              selectedDoctorData!.isTelemed = isTelemed;
              selectedDoctorData!.multiple = isMultiSelection;
              if (selectedProfileImage != null) {
                selectedDoctorData!.imageFile = selectedProfileImage;
              }
              if (selectedDoctorData != null) selectedDataList.add(selectedDoctorData!);
            }

            if (listOfMappingTableId.isNotEmpty && addMappingTableId) {
              listOfMappingTableId.removeWhere((element) => element == 0);
              listOfMappingTableId.forEachIndexed((element, index) {
                req.putIfAbsent('mapping_table_id[$index]', () => element);
              });
            }
          }

          appStore.setLoading(true);

          await saveServiceAPI(data: req, serviceImage: selectedProfileImage, tempList: selectedDataList).then((value) {
            appStore.setLoading(false);
            toast(value.message);
            finish(context, true);
          }).catchError((e) {
            appStore.setLoading(false);
            toast(e.toString());
          });
        },
      );
    } else {
      isFirstTime = !isFirstTime;
      setState(() {});
    }
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
      }
    });
  }

  void changeStatus(bool? value) {
    isActive = value.validate();

    setState(() {});
  }

  void allowTelemed(bool? value) {
    isTelemed = value.validate();

    setState(() {});
  }

  void changeMultiSelection(bool? value) {
    isMultiSelection = value.validate();

    setState(() {});
  }

  Future<void> deleteService({required UserModel serviceData}) async {
    showConfirmDialogCustom(
      context,
      dialogType: DialogType.DELETE,
      title: locale.lblDoYouWantToDeleteService,
      onAccept: (p0) async {
        Map<String, dynamic> req = {
          "id": widget.serviceData!.id.validate(),
        };
        if (isDoctor()) {
          req.putIfAbsent("doctor_id", () => userStore.userId);
          req.putIfAbsent('service_mapping_id', () => widget.serviceData!.mappingTableId);
        } else {
          listOfMappingTableId.clear();

          listOfMappingTableId.add(serviceData.mappingTableId.toInt());
          req.putIfAbsent('mapping_table_id', () => listOfMappingTableId);
        }
        appStore.setLoading(true);

        await deleteServiceDataAPI(req).then((value) {
          appStore.setLoading(false);
          selectedDataList.remove(serviceData);
          listOfMappingTableId.clear();
          toast(value.message.validate());
          if (selectedDataList.isNotEmpty) {
            ifLengthIsGreater();
            setState(() {});
            widget.callForRefresh?.call();
          } else {
            finish(context, true);
          }
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
        });
      },
    );
  }

  Future<bool> showDeleteDialog() async {
    bool? res = await showConfirmDialogCustom(
      context,
      dialogType: DialogType.DELETE,
      title: 'Do you want to delete service for ${names.join(',')}?',
      positiveText: locale.lblYes,
      negativeText: locale.lblNo,
      onAccept: (BuildContext context) {
        return true;
      },
      onCancel: (context) {
        return false;
      },
    );
    return res ?? false;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  UserModel setDoctor(ServiceData serviceData, {required UserModel userData}) {
    if (isReceptionist()) {
      userData.doctorId = serviceData.doctorId;
      userData.profileImage = serviceData.profileImage;
      userData.mappingTableId = serviceData.mappingTableId;
    } else {
      userData.clinicName = serviceData.clinicName;
      userData.clinicId = serviceData.clinicId;
      userData.doctorId = userStore.userId.toString();
    }
    userData.serviceId = serviceData.serviceId;
    userData.charges = serviceData.charges;
    userData.isTelemed = serviceData.isTelemed;
    userData.status = serviceData.status;
    userData.duration = serviceData.duration;
    userData.multiple = serviceData.multiple;
    userData.imageFile = serviceData.imageFile;
    userData.serviceImage = serviceData.image.validate();

    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: appBarWidget(
          isUpdate ? locale.lblEditService : locale.lblAddService,
          textColor: Colors.white,
          systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
          actions: [
            if (isUpdate && isVisible(SharedPreferenceKey.kiviCareServiceDeleteKey))
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () async {
                  showConfirmDialogCustom(
                    context,
                    dialogType: DialogType.DELETE,
                    title: locale.lblDoYouWantToDeleteService,
                    onAccept: (p0) async {
                      Map<String, dynamic> req = {
                        "id": widget.serviceData!.id.validate(),
                      };
                      if (isDoctor()) {
                        req.putIfAbsent("doctor_id", () => userStore.userId);
                        req.putIfAbsent('mapping_table_id', () => widget.serviceData!.mappingTableId);
                      } else {
                        listOfMappingTableId.clear();
                        selectedDataList.forEachIndexed((element, index) {
                          listOfMappingTableId.add(element.mappingTableId.toInt());
                        });
                        req.putIfAbsent('mapping_table_id', () => listOfMappingTableId);
                      }
                      appStore.setLoading(true);

                      await deleteServiceDataAPI(req).then((value) {
                        appStore.setLoading(false);
                        toast(value.message.validate());
                        finish(context, true);
                      }).catchError((e) {
                        appStore.setLoading(false);
                        toast(e.toString());
                      });
                    },
                  );
                },
              ),
          ],
        ),
        body: InternetConnectivityWidget(
          retryCallback: () {
            init();
          },
          child: Stack(
            children: [
              Form(
                autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                key: formKey,
                child: AnimatedScrollView(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 96),
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Container(
                          decoration: boxDecorationDefault(borderRadius: radius(65), color: appStore.isDarkModeOn ? cardDarkColor : context.scaffoldBackgroundColor, shape: BoxShape.circle),
                          child: selectedProfileImage != null
                              ? Image.file(selectedProfileImage!, fit: BoxFit.cover, width: 126, height: 126).cornerRadiusWithClipRRect(65)
                              : CachedImageWidget(
                                  url: widget.serviceData != null
                                      ? selectedDoctorData != null
                                          ? selectedDoctorData!.serviceImage.validate()
                                          : ""
                                      : '',
                                  height: 126,
                                  width: 126,
                                  fit: BoxFit.cover,
                                  circle: true),
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
                    ).center().paddingBottom(16).visible((isReceptionist() && selectedDataList.length <= 1) || (isDoctor())),
                    20.height,
                    FutureBuilder<StaticDataModel>(
                        future: future,
                        builder: (context, snap) {
                          if (snap.hasData) {
                            if (isUpdate) {
                              List<String> stype = [];
                              if (stype.contains(widget.serviceData!.type.validate())) {
                                category = snap.data?.staticData?.firstWhere((element) => element!.value == widget.serviceData!.type.validate());
                              }

                              if (snap.data != null) {
                                if (snap.data!.staticData != null) {
                                  snap.data?.staticData!.forEach((element) {
                                    stype.add(element!.value.validate());
                                  });
                                  if (stype.contains(widget.serviceData!.type.validate())) {
                                    category = snap.data?.staticData?.firstWhere((element) => element!.value == widget.serviceData!.type.validate());
                                  } else {
                                    category?.value = widget.serviceData!.type.validate();

                                    if (category != null) {
                                      serviceCategoryCont.text = category!.value.validate();
                                    }
                                  }
                                }
                              }
                            }

                            return IgnorePointer(
                              ignoring: isUpdate,
                              child: DropdownButtonFormField<StaticData>(
                                focusNode: serviceCategoryFocus,
                                icon: SizedBox.shrink(),
                                isExpanded: true,
                                borderRadius: radius(),
                                dropdownColor: context.cardColor,
                                autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                                value: category,
                                items: snap.data!.staticData.validate().map<DropdownMenuItem<StaticData>>((serviceData) {
                                  return DropdownMenuItem<StaticData>(
                                    value: serviceData,
                                    onTap: () {
                                      category = serviceData;
                                      serviceCategoryCont.text = serviceData.value.validate();

                                      setState(() {});
                                    },
                                    child: Text(serviceData!.label.validate(), style: primaryTextStyle()),
                                  );
                                }).toList(),
                                onChanged: (category) {
                                  if (isUpdate) return;
                                  if (!isUpdate) {
                                    category = category;
                                    serviceCategoryCont.text = category!.value.validate();
                                    setState(() {});
                                  }
                                },
                                decoration: inputDecoration(
                                  context: context,
                                  labelText: isUpdate ? '${locale.lblCategory}' : '${locale.lblSelect} ${locale.lblCategory}',
                                  suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                                ),
                                validator: (s) {
                                  if (s == null) return locale.lblServiceCategoryIsRequired;
                                  return null;
                                },
                              ),
                            );
                          } else {
                            return Offstage();
                          }
                        }),
                    16.height,
                    AppTextField(
                      nextFocus: isReceptionist() ? doctorSelectionFocus : clinicFocus,
                      controller: serviceNameCont,
                      textFieldType: TextFieldType.NAME,
                      errorThisFieldRequired: locale.lblServiceNameIsRequired,
                      textAlign: TextAlign.justify,
                      decoration: inputDecoration(
                        context: context,
                        labelText: locale.lblService + ' ${locale.lblName}',
                        suffixIcon: ic_services.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                      ),
                    ),
                    16.height,
                    RoleWidget(
                      isShowDoctor: true,
                      child: Column(
                        children: [
                          AppTextField(
                            controller: clinicCont,
                            focus: clinicFocus,
                            textFieldType: TextFieldType.OTHER,
                            isValidationRequired: true,
                            errorThisFieldRequired: locale.clinicIdRequired,
                            nextFocus: serviceChargesFocus,
                            decoration: inputDecoration(
                              context: context,
                              labelText: isUpdate ? locale.lblClinicName : locale.lblSelectClinic,
                              suffixIcon: ic_clinic.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                            ),
                            readOnly: true,
                            onTap: () {
                              MultiSelectClinicDropDown(
                                selectedClinicId: widget.serviceData != null ? selectedUsersIdsList.first : null,
                                onSubmit: (selectedClinicLocalList) {
                                  if (selectedClinicLocalList.isNotEmpty) {
                                    if (selectedClinicList.isNotEmpty) {
                                      selectedClinicList.clear();
                                      selectedClinicLocalList.forEach((clinicData) {
                                        selectedClinicList.add(clinicData);
                                      });
                                    } else {
                                      selectedClinicList = selectedClinicLocalList;
                                    }
                                    selectedDataList.clear();
                                    selectedClinicList.forEach((clinicData) {
                                      selectedDataList.add(
                                        setDoctor(
                                            ServiceData(
                                              clinicId: clinicData.id,
                                              clinicName: clinicData.name,
                                              id: isUpdate ? widget.serviceData?.id : null,
                                              serviceId: isUpdate ? widget.serviceData?.id : null,
                                            ),
                                            userData: UserModel()),
                                      );
                                    });

                                    selectedUsersIdsList.clear();
                                    selectedUsersIdsList = selectedClinicList.map((e) => e.id.toInt()).toList();

                                    if (selectedClinicList.length > 1)
                                      clinicCont.text = selectedClinicLocalList.length.toString() + ' ${locale.lblClinicsSelected}';
                                    else {
                                      if (!isUpdate) {
                                        selectedClinicData = selectedClinicLocalList.first;
                                        clinicCont.text = selectedClinicData!.name.validate();
                                      } else {
                                        selectedUsersIdsList.clear();
                                        clinicCont.text = selectedClinicLocalList.first.name.validate();
                                        selectedClinicData?.id = selectedClinicLocalList.first.id;
                                        selectedDoctorData = setDoctor(
                                          ServiceData(
                                              clinicId: selectedClinicData?.id,
                                              clinicName: selectedClinicLocalList.first.name.validate(),
                                              serviceId: isUpdate ? widget.serviceData?.serviceId : null,
                                              id: isUpdate ? widget.serviceData?.id : null),
                                          userData: UserModel(),
                                        );
                                        selectedUsersIdsList.add(selectedClinicLocalList.first.id.toInt());
                                      }
                                    }
                                  } else {
                                    clinicCont.clear();
                                    selectedClinicList.clear();
                                    selectedUsersIdsList.clear();
                                  }
                                  setState(() {});
                                },
                                selectedClinicIds: selectedUsersIdsList,
                              ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                            },
                            validator: (value) {
                              if (value!.isEmpty) return locale.lblSelectOneClinic;
                              return null;
                            },
                          ),
                          16.height.visible(selectedClinicList.length > 1),
                          Wrap(
                            direction: Axis.horizontal,
                            runSpacing: 12,
                            spacing: 12,
                            children: List.generate(selectedClinicList.length, (index) {
                              Clinic data = selectedClinicList[index];
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                width: context.width() / 2 - 24,
                                decoration: boxDecorationDefault(
                                  border: Border.all(color: borderColor),
                                  color: context.cardColor,
                                  borderRadius: radius(24),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      data.name.validate(),
                                      style: primaryTextStyle(color: context.iconColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ).expand(),
                                    ic_clear.iconImage().paddingAll(4).appOnTap(() {
                                      setState(() {
                                        selectedClinicList.remove(data);
                                        selectedUsersIdsList.remove(data.id.toInt());
                                      });

                                      if (selectedClinicList.length > 1)
                                        clinicCont.text = selectedClinicList.length.toString() + ' ${locale.lblClinicsAvailable}';
                                      else {
                                        selectedClinicData = selectedClinicList.first;
                                        clinicCont.text = selectedClinicData!.name.validate();
                                      }
                                      setState(() {});
                                    }),
                                  ],
                                ),
                              );
                            }),
                          ).visible(selectedClinicList.length > 1),
                        ],
                      ),
                    ),
                    RoleWidget(
                      isShowReceptionist: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            controller: doctorCont,
                            focus: doctorSelectionFocus,
                            textFieldType: TextFieldType.OTHER,
                            isValidationRequired: true,
                            errorThisFieldRequired: locale.lblSelectOneDoctor,
                            readOnly: true,
                            validator: (value) {
                              if (selectedDataList.isEmpty)
                                return locale.lblPleaseSelectDoctor;
                              else
                                return null;
                            },
                            onTap: () {
                              MultiSelectDoctorDropDown(
                                clinicId: userStore.userClinicId.toInt(),
                                selectedDoctorsId: selectedUsersIdsList,
                                refreshMappingTableIdsList: (dId) {
                                  if (selectedDataList.isNotEmpty) {
                                    selectedDataList.forEach((element) {
                                      if (element.doctorId.toInt() == dId) {
                                        if (!listOfMappingTableId.any((e) => e == element.mappingTableId.toInt())) {
                                          listOfMappingTableId.add(element.mappingTableId.toInt());
                                          names.add(element.displayName.validate());
                                        }
                                      }
                                    });
                                    selectedDataList.removeWhere((element) => element.doctorId.toInt() == dId);
                                  }
                                },
                                onSubmit: (selectedDoctorsList) {
                                  setState(() {
                                    isFirst = false;
                                  });

                                  if (selectedDoctorsList.isNotEmpty) {
                                    selectedDoctorsList.forEach((element) {
                                      int index = selectedDataList.indexWhere((userData) => userData.doctorId.toInt() == element.doctorId.toInt());
                                      if (index > 0) {
                                        selectedDataList[index] = selectedDataList[index];
                                      }
                                      if (index < 0) {
                                        if (!selectedUsersIdsList.contains(element.doctorId.toInt())) {
                                          selectedDataList.add(element);
                                        }
                                      }
                                    });
                                  }

                                  if (selectedDataList.isNotEmpty) {
                                    selectedDataList.forEach((element) {
                                      if (listOfMappingTableId.contains(element.mappingTableId)) {
                                        listOfMappingTableId.remove(element.mappingTableId);
                                        names.remove(element.displayName);
                                      }
                                    });
                                    ifLengthIsGreater();
                                  }

                                  setState(() {});
                                },
                              ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                            },
                            decoration: inputDecoration(
                              context: context,
                              labelText: locale.lblSelectDoctor,
                              suffixIcon: ic_user.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                            ).copyWith(alignLabelWithHint: true),
                          ),
                          if (selectedDataList.length > 1)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${locale.lblNote} : ${locale.lblDoctorTapMsg}",
                                  style: secondaryTextStyle(size: 10, color: appSecondaryColor),
                                ).paddingSymmetric(horizontal: 4, vertical: 6),
                                8.height,
                                Wrap(
                                    direction: Axis.horizontal,
                                    runSpacing: 16,
                                    spacing: 16,
                                    children: selectedDataList.map<Widget>((userData) {
                                      UserModel data = userData;
                                      return GestureDetector(
                                        onTap: () {
                                          selectedIndex = selectedDataList.indexOf(data);
                                          setState(() {});
                                          EditServiceDataScreen(
                                            doctorId: data.doctorId.toString(),
                                            serviceData: data,
                                            onSubmit: (serviceData) {
                                              serviceData.displayName = data.displayName;
                                              if (selectedProfileImage != null) {
                                                serviceData.image = selectedProfileImage!.path;
                                              }

                                              data = setDoctor(serviceData, userData: data);
                                              selectedDoctorData = data;
                                              int index = selectedDataList.indexWhere((serviceData) => serviceData.doctorId.toString() == data.doctorId.toString());

                                              if (index < 0) {
                                                selectedDataList.add(data);
                                              } else {
                                                selectedDataList[index] = data;
                                              }
                                            },
                                          ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                          width: context.width() / 2 - 24,
                                          decoration: boxDecorationDefault(
                                            border: Border.all(color: selectedIndex == selectedDataList.indexOf(data) ? appSecondaryColor : borderColor),
                                            color: context.cardColor,
                                            borderRadius: radius(32),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(CupertinoIcons.person, size: 16, color: context.iconColor),
                                              8.width,
                                              Text('Dr. ${data.displayName.validate().split(' ').first}',
                                                      style: primaryTextStyle(color: context.iconColor), maxLines: 1, overflow: TextOverflow.ellipsis)
                                                  .expand(),
                                              if (isVisible(SharedPreferenceKey.kiviCareServiceEditKey))
                                                ic_clear.iconImage(size: 18).paddingAll(4).appOnTap(() {
                                                  if (!listOfMappingTableId.any((e) => e == data.mappingTableId.toInt())) {
                                                    if (isUpdate && data.mappingTableId.toInt() != 0)
                                                      deleteService(serviceData: data);
                                                    else {
                                                      selectedDataList.remove(data);
                                                      if (selectedDataList.isNotEmpty) {
                                                        ifLengthIsGreater();
                                                      }
                                                      setState(() {});
                                                    }
                                                  }
                                                })
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList()),
                              ],
                            )
                        ],
                      ),
                    ),
                    16.height,
                    RoleWidget(
                      isShowDoctor: true,
                      isShowReceptionist: selectedDataList.length <= 1,
                      child: Column(
                        children: [
                          AppTextField(
                            focus: serviceChargesFocus,
                            nextFocus: doctorSelectionFocus,
                            controller: chargesCont,
                            errorThisFieldRequired: locale.lblChargesIsRequired,
                            validator: (value) {
                              if (value.isEmptyOrNull) return locale.lblChargesIsRequired;
                              if (RegExp(r'^[^a-zA-Z0-9]').hasMatch(value.validate()[0])) return locale.lblChargesIsNegative;
                              return null;
                            },
                            textFieldType: TextFieldType.NUMBER,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.justify,
                            decoration: inputDecoration(
                              context: context,
                              labelText: locale.lblCharges,
                              suffixIcon: ic_dollar_icon.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                            ),
                          ),
                          16.height,
                          DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<DurationModel>(
                              focusNode: serviceDurationFocus,
                              value: selectedDuration,
                              icon: SizedBox.shrink(),
                              validator: (value) {
                                if (selectedDuration == null) return locale.lblDurationIsRequired;
                                return null;
                              },
                              borderRadius: radius(),
                              dropdownColor: context.cardColor,
                              autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                              decoration: inputDecoration(
                                context: context,
                                labelText: '${locale.lblSelect} ${locale.lblDuration}',
                                suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                              ),
                              onChanged: (value) {
                                if (!isUpdate) {
                                  selectedDuration = value;
                                  setState(() {});
                                }
                                selectedDuration = value;
                                setState(() {});
                              },
                              items: durationList.map<DropdownMenuItem<DurationModel>>((duration) {
                                return DropdownMenuItem<DurationModel>(
                                  value: duration,
                                  child: Text(duration.label.validate(), style: primaryTextStyle()),
                                );
                              }).toList(),
                            ),
                          ),
                          16.height,
                          Container(
                            decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locale.lblAllowMultiSelectionWhileBooking,
                                  style: primaryTextStyle(color: textSecondaryColorGlobal),
                                ),
                                4.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 0,
                                      children: [
                                        Text(locale.lblYes, style: primaryTextStyle()),
                                        Radio.adaptive(value: true, groupValue: isMultiSelection, onChanged: changeMultiSelection),
                                      ],
                                    ).paddingLeft(38),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 0,
                                      children: [
                                        Text(locale.lblNo, style: primaryTextStyle()),
                                        Radio.adaptive(value: false, groupValue: isMultiSelection, onChanged: changeMultiSelection),
                                      ],
                                    ).paddingRight(38),
                                  ],
                                )
                              ],
                            ),
                          ),
                          16.height,
                          Container(
                            decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locale.lblSetStatus,
                                  style: primaryTextStyle(color: textSecondaryColorGlobal),
                                ),
                                4.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 0,
                                      children: [Text(locale.lblActive, style: primaryTextStyle()), Radio.adaptive(value: true, groupValue: isActive, onChanged: changeStatus)],
                                    ).paddingLeft(22),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 0,
                                      children: [Text(locale.lblInActive, style: primaryTextStyle()), Radio.adaptive(value: false, groupValue: isActive, onChanged: changeStatus)],
                                    ).paddingRight(22),
                                  ],
                                )
                              ],
                            ),
                          ),
                          16.height,
                          Container(
                            decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locale.lblIsThisATelemedService,
                                  style: primaryTextStyle(color: textSecondaryColorGlobal),
                                ),
                                4.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 0,
                                      children: [Text(locale.lblYes, style: primaryTextStyle()), Radio.adaptive(value: true, groupValue: isTelemed, onChanged: allowTelemed)],
                                    ).paddingLeft(38),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 0,
                                      children: [Text(locale.lblNo, style: primaryTextStyle()), Radio.adaptive(value: false, groupValue: isTelemed, onChanged: allowTelemed)],
                                    ).paddingRight(38),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading).center())
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done, color: Colors.white),
          onPressed: () {
            if (isUpdate && listOfMappingTableId.isNotEmpty)
              showDeleteDialog().then((value) {
                Timer(
                  Duration(milliseconds: 400),
                  () {
                    _handleClick(addMappingTableId: value);
                  },
                );
              });
            else {
              if (isDoctor() && isUpdate) {
                if (selectedDataList.validate().first.clinicId != widget.serviceData!.clinicId) {
                  if (widget.serviceList.validate().any((element) => element.clinicId == selectedDataList.first.clinicId && element.serviceId == selectedDataList.first.serviceId)) {
                    toast(locale.lblThisServiceAlreadyExistInClinic);
                  } else {
                    _handleClick();
                  }
                } else {
                  _handleClick();
                }
              } else
                _handleClick();
            }
          },
        ),
      );
    });
  }
}
