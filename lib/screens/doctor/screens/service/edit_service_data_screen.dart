import 'dart:io';

import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/custom_image_picker.dart';
import 'package:momona_healthcare/components/image_border_component.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/service_duration_model.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/extensions/enums.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class EditServiceDataScreen extends StatefulWidget {
  UserModel? serviceData;
  final int? serviceId;
  final String doctorId;

  final Function(ServiceData)? onSubmit;

  EditServiceDataScreen({this.serviceData, this.serviceId, required this.doctorId, this.onSubmit});

  @override
  State<EditServiceDataScreen> createState() => _EditServiceDataScreenState();
}

class _EditServiceDataScreenState extends State<EditServiceDataScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController serviceNameCont = TextEditingController();
  TextEditingController chargesCont = TextEditingController();

  bool? isActive;
  bool? isMultiSelection;
  bool? isTelemed;

  bool isFirstTime = true;
  bool isUpdate = false;

  DurationModel? selectedDuration;
  UserModel? selectedDoctor;

  List<DurationModel> durationList = getServiceDuration();

  FocusNode serviceCategoryFocus = FocusNode();
  FocusNode serviceNameFocus = FocusNode();
  FocusNode serviceChargesFocus = FocusNode();
  FocusNode doctorSelectionFocus = FocusNode();
  FocusNode serviceDurationFocus = FocusNode();
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.serviceData != null;

    if (isUpdate) {
      selectedDoctor = widget.serviceData;
      chargesCont.text = selectedDoctor!.charges.validate();
      if (widget.serviceData?.imageFile != null) {
        selectedImage = widget.serviceData!.imageFile;
      }

      if (selectedDoctor!.duration != null && widget.serviceData!.duration.toInt() != 0) {
        selectedDuration = durationList.firstWhere((element) => element.value == selectedDoctor!.duration.toInt());
      }
      if (selectedDoctor!.status != null) isActive = selectedDoctor!.status.getBoolInt();
      if (selectedDoctor!.multiple != null) isMultiSelection = selectedDoctor!.multiple;
      isTelemed = selectedDoctor!.isTelemed;
    }
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
            selectedImage = value;
            setState(() {});
          });
        } else if (file == GalleryFileTypes.GALLERY) {
          await getCameraImage(isCamera: false).then((value) {
            selectedImage = value;
            setState(() {});
          });
        }
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? locale.lblEditService : locale.lblAddService,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Form(
        autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
        key: formKey,
        child: AnimatedScrollView(
          padding: EdgeInsets.only(bottom: 120),
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  decoration: boxDecorationDefault(borderRadius: radius(65), color: appStore.isDarkModeOn ? cardDarkColor : context.scaffoldBackgroundColor, shape: BoxShape.circle),
                  child: selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover, width: 126, height: 126).cornerRadiusWithClipRRect(65)
                      : widget.serviceData != null
                          ? ImageBorder(
                              src: widget.serviceData!.serviceImage.validate(),
                              height: 120,
                              width: 120,
                            )
                          : CachedImageWidget(url: '', height: 126, width: 126, fit: BoxFit.cover, circle: true),
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
            ).center().paddingSymmetric(vertical: 16),
            AppTextField(
              focus: serviceChargesFocus,
              nextFocus: serviceDurationFocus,
              controller: chargesCont,
              textFieldType: TextFieldType.NAME,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.justify,
              textInputAction: TextInputAction.next,
              errorThisFieldRequired: locale.lblChargesIsRequired,
              validator: (value) {
                if (value.isEmptyOrNull) return locale.lblChargesIsRequired;
                if (value.toInt().isNegative) return locale.lblChargesIsNegative;
                return null;
              },
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
                borderRadius: radius(),
                value: selectedDuration,
                icon: SizedBox.shrink(),
                dropdownColor: context.cardColor,
                validator: (value) {
                  if (selectedDuration == null) return locale.lblDurationIsRequired;
                  return null;
                },
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
        ).paddingOnly(
          left: 16,
          right: 16,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            ServiceData data = ServiceData(
              displayName: isDoctor() ? userStore.userDisplayName : widget.serviceData!.displayName,
              clinicId: isDoctor() ? selectedDoctor!.clinicId.validate().toString() : userStore.userClinicId.toString(),
              clinicName: isDoctor() ? selectedDoctor!.clinicName : userStore.userClinicName,
              id: widget.serviceId.toString(),
              mappingTableId: isDoctor() ? '' : widget.serviceData!.mappingTableId.validate(),
              doctorId: widget.doctorId,
              multiple: isMultiSelection,
              status: isActive.getIntBool().toString(),
              isTelemed: isTelemed,
              charges: chargesCont.text,
              duration: selectedDuration != null ? selectedDuration?.value.toString() : null,
              imageFile: selectedImage,
              image: isDoctor() ? '' : widget.serviceData!.serviceImage,
            );
            widget.onSubmit?.call(data);
            finish(context);
          } else {
            isFirstTime = !isFirstTime;
            if (isActive == null || isMultiSelection == null || isTelemed == null) {
              toast(locale.lblPleaseChoose);
            }
            setState(() {});
          }
        },
      ),
    );
  }
}
