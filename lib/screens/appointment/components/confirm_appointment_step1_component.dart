import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/role_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ConfirmAppointmentStep1Component extends StatefulWidget {
  final Function(String)? changeIndexCallback;
  final bool isUpdate;

  ConfirmAppointmentStep1Component({this.changeIndexCallback, this.isUpdate = false});

  @override
  State<ConfirmAppointmentStep1Component> createState() => _ConfirmAppointmentStep1ComponentState();
}

class _ConfirmAppointmentStep1ComponentState extends State<ConfirmAppointmentStep1Component> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        42.height,
        Text("${isDoctor() ? 'Dr. ${userStore.firstName}' : '${userStore.firstName}'}, ${locale.lblAppointmentConfirmation}.", style: primaryTextStyle(), textAlign: TextAlign.center),
        16.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.calendarCheck, size: 20),
            8.width,
            Text(appointmentAppStore.selectedAppointmentDate.getFormattedDate(CONFIRM_APPOINTMENT_FORMAT), style: primaryTextStyle(size: 18)).flexible(),
          ],
        ),
        20.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(appointmentAppStore.mSelectedTime.validate(), style: boldTextStyle(size: 18), textAlign: TextAlign.end).expand(flex: 3),
            VerticalDivider(color: context.dividerColor, thickness: 2).withHeight(20).expand(flex: 1),
            if (isDoctor() || isReceptionist())
              Text(
                "${appointmentAppStore.mPatientSelected?.validate().capitalizeEachWord()}",
                style: boldTextStyle(size: 20),
                textAlign: TextAlign.start,
              ).expand(flex: 3)
            else
              Text(
                "${appointmentAppStore.mDoctorSelected?.displayName.validate().split(' ').first.capitalizeEachWord().prefixText(value: 'Dr. ')}",
                style: boldTextStyle(size: 18),
                textAlign: TextAlign.start,
              ).expand(flex: 3)
          ],
        ),
        if (isProEnabled() && isPatient()) 26.height,
        RoleWidget(
          isShowPatient: isProEnabled(),
          child: RichTextWidget(
            list: [
              TextSpan(text: locale.lblClinic, style: secondaryTextStyle(size: 16)),
              TextSpan(text: " : ", style: primaryTextStyle()),
              TextSpan(text: appointmentAppStore.mClinicSelected?.name.validate(), style: primaryTextStyle()),
            ],
          ),
        ),
        if (appointmentAppStore.mDescription.validate().isNotEmpty) 16.height,
        if (appointmentAppStore.mDescription.validate().isNotEmpty)
          RoleWidget(
            isShowPatient: appointmentAppStore.mDescription != null,
            isShowReceptionist: appointmentAppStore.mDescription != null,
            isShowDoctor: appointmentAppStore.mDescription != null,
            child: RichTextWidget(
              textAlign: TextAlign.start,
              list: [
                TextSpan(text: locale.lblDesc + ' : ', style: primaryTextStyle()),
                TextSpan(text: appointmentAppStore.mDescription, style: primaryTextStyle()),
              ],
            ),
          ),
        if (appointmentAppStore.mDescription.validate().isNotEmpty) 28.height else 24.height,
        if (widget.isUpdate && isPatient())
          RichTextWidget(
            textAlign: TextAlign.start,
            list: [
              TextSpan(text: locale.lblPaymentMethod + ' : ', style: primaryTextStyle()),
              TextSpan(text: appointmentAppStore.mSelectedPaymentMethod, style: primaryTextStyle()),
            ],
          ),
        RoleWidget(
          isShowPatient: isPatient() && paymentMethodList.isNotEmpty && !widget.isUpdate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.lblPaymentMethod, style: boldTextStyle()),
              12.height,
              Container(
                width: context.width(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: boxDecorationDefault(
                  color: context.cardColor,
                  border: Border.all(color: appPrimaryColor, width: 1),
                  borderRadius: radius(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedIndex,
                    icon: ic_arrow_down.iconImage(size: 18, color: context.iconColor),
                    dropdownColor: context.cardColor,
                    hint: Text(locale.lblSelectPaymentMethod, style: secondaryTextStyle()),
                    borderRadius: radius(),
                    items: List.generate(
                      paymentMethodList.length,
                      (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: TextIcon(
                            spacing: 4,
                            edgeInsets: EdgeInsets.zero,
                            text: paymentMethodList[index],
                            textStyle: primaryTextStyle(),
                            prefix: paymentMethodImages[index].iconImageColored(),
                          ),
                        );
                      },
                    ),
                    onChanged: (value) {
                      selectedIndex = value!;

                      setState(() {});
                      appStore.setPaymentMode(paymentModeList[selectedIndex!]);
                      appointmentAppStore.setPaymentMethod(paymentModeList[selectedIndex!]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        if ((isPatient() && paymentMethodList.isNotEmpty) || widget.isUpdate) 20.height,
        Observer(
          builder: (_) => AppButton(
              width: context.width(),
              text: locale.lblConfirmAppointment,
              textStyle: boldTextStyle(color: Colors.white),
              onTap: () {
                if (isPatient() && !widget.isUpdate) {
                  if (paymentMethodList.isNotEmpty && selectedIndex != null) {
                    widget.changeIndexCallback?.call(paymentModeList[selectedIndex!]);
                  } else {
                    if (paymentMethodList.isEmpty) {
                      widget.changeIndexCallback?.call('');
                    } else
                      toast(locale.lblPleaseSelectPayment);
                  }
                } else {
                  widget.changeIndexCallback?.call('');
                }
              }).visible(
            !appStore.isLoading,
            defaultWidget: LoaderWidget(size: loaderSize),
          ),
        ),
      ],
    );
  }
}
