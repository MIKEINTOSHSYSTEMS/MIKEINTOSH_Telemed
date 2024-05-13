import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/custom_image_picker.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/service_duration_model.dart';
import 'package:kivicare_flutter/model/service_model.dart';
import 'package:kivicare_flutter/model/static_data_model.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/enums.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceDataFormComponent extends StatefulWidget {
  final ServiceData? serviceData;
  ServiceDataFormComponent({this.serviceData});

  @override
  _ServiceDataFormComponentState createState() => _ServiceDataFormComponentState();
}

class _ServiceDataFormComponentState extends State<ServiceDataFormComponent> {
  Future<StaticDataModel>? future;

  ServiceData serviceData = ServiceData();

  int selectedIndex = -1;

  bool isUpdate = false;
  bool isFirstTime = true;
  bool isFirst = false;
  bool? isActive;
  bool? isMultiSelection;
  bool? isTelemed;

  DurationModel? selectedDuration;

  List<DurationModel> durationList = getServiceDuration();
  List<String> names = [];

  TextEditingController chargesCont = TextEditingController();

  File? selectedImage;

  List<File> serviceImage = [];

  FocusNode serviceChargesFocus = FocusNode();

  FocusNode serviceDurationFocus = FocusNode();

  void init() async {
    isUpdate = widget.serviceData != null;

    if (isUpdate) {
      chargesCont.text = serviceData.charges.validate();
      if (widget.serviceData?.imageFile != null) {
        selectedImage = widget.serviceData!.imageFile;
      }

      if (widget.serviceData != null && widget.serviceData!.duration.toInt() != 0) {
        selectedDuration = durationList.firstWhere((element) => element.value == widget.serviceData!.duration.toInt());
      }
      if (widget.serviceData!.status != null) isActive = widget.serviceData!.status.getBoolInt();
      if (widget.serviceData!.multiple != null) isMultiSelection = widget.serviceData!.multiple;
      isTelemed = widget.serviceData!.isTelemed;
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
    return Column(
      children: [
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
    );
  }
}
