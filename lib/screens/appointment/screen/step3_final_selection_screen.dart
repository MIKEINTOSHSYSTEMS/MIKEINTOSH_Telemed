import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/components/multi_select_service_component.dart';
import 'package:kivicare_flutter/components/price_widget.dart';
import 'package:kivicare_flutter/components/role_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/service_model.dart';
import 'package:kivicare_flutter/model/upcoming_appointment_model.dart';
import 'package:kivicare_flutter/model/user_model.dart';
import 'package:kivicare_flutter/screens/appointment/appointment_functions.dart';
import 'package:kivicare_flutter/screens/appointment/components/appointment_date_component.dart';
import 'package:kivicare_flutter/screens/appointment/components/appointment_slots.dart';
import 'package:kivicare_flutter/screens/appointment/components/confirm_appointment_component.dart';
import 'package:kivicare_flutter/screens/appointment/components/file_upload_component.dart';
import 'package:kivicare_flutter/screens/appointment/screen/patient_search_screen.dart';
import 'package:kivicare_flutter/screens/doctor/screens/service/add_service_screen.dart';
import 'package:kivicare_flutter/screens/patient/components/selected_clinic_widget.dart';
import 'package:kivicare_flutter/screens/patient/components/selected_doctor_widget.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/patient/add_patient_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class Step3FinalSelectionScreen extends StatefulWidget {
  final int? clinicId;
  final int? doctorId;
  final UpcomingAppointmentModel? data;

  Step3FinalSelectionScreen({
    this.data,
    this.doctorId,
    required this.clinicId,
  });

  @override
  State<Step3FinalSelectionScreen> createState() => _Step3FinalSelectionScreenState();
}

class _Step3FinalSelectionScreenState extends State<Step3FinalSelectionScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController descriptionCont = TextEditingController(text: '');
  TextEditingController patientNameCont = TextEditingController();
  TextEditingController servicesCont = TextEditingController();

  bool isUpdate = false;
  bool isFirstTime = true;

  FocusNode patientNameFocus = FocusNode();
  FocusNode serviceFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode slotFocus = FocusNode();
  FocusNode descFocus = FocusNode();

  UserModel? user;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    multiSelectStore.clearList();
    multiSelectStore.setTaxData(null);

    isUpdate = widget.data != null;

    if (isUpdate) {
      appointmentAppStore.setSelectedPatient(widget.data!.patientName.validate());
      appointmentAppStore.setSelectedPatientId(widget.data!.patientId.validate().toInt());
      appointmentAppStore.setSelectedTime(widget.data!.getAppointmentTime);

      if (widget.data!.patientName.validate().isNotEmpty) {
        patientNameCont.text = widget.data!.patientName.validate();
      }

      if (widget.data!.appointmentStartDate.validate().isNotEmpty) {}
      if (widget.data!.visitType.validate().isNotEmpty) {
        widget.data!.visitType.validate().forEach((element) {
          multiSelectStore.selectedService.add(ServiceData(id: element.id, name: element.serviceName, serviceId: element.serviceId, charges: element.charges));
        });

        servicesCont.text = "${multiSelectStore.selectedService.length} " + locale.lblServicesSelected;
      }

      if (widget.data!.taxData != null) multiSelectStore.setTaxData(widget.data!.taxData);

      descriptionCont.text = widget.data!.description.validate();
      if (widget.data!.paymentMethod.validate().isNotEmpty) appointmentAppStore.setPaymentMethod(widget.data!.paymentMethod.validate());

      if (widget.data!.appointmentReport.validate().isNotEmpty) {
        appointmentAppStore.addReportListString(data: widget.data!.appointmentReport.validate());
        appointmentAppStore.addReportData(data: widget.data!.appointmentReport.validate().map((e) => PlatformFile(name: e.url, size: 220)).toList());
      }
    }
    setState(() {});
  }

  void selectServices() async {
    await MultiSelectServiceComponent(
      clinicId: isPatient() || isDoctor() ? appointmentAppStore.mClinicSelected?.id.toInt() : userStore.userClinicId.toInt(),
      selectedServicesId: multiSelectStore.selectedService.map((element) => element.serviceId.validate()).toList(),
    ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
    if (multiSelectStore.selectedService.length > 0)
      servicesCont.text = '${multiSelectStore.selectedService.length} ${locale.lblServicesSelected}';
    else {
      servicesCont.text = locale.lblSelectServices;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblConfirmAppointment, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context), textColor: Colors.white),
      body: Form(
        key: formKey,
        autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
        child: AnimatedScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
          listAnimationType: ListAnimationType.None,
          onSwipeRefresh: () {
            LiveStream().emit(CHANGE_DATE, true);
            setState(() {});
            return 1.seconds.delay;
          },
          children: [
            stepCountWidget(
              name: locale.lblSelectDateTime,
              currentCount: (isDoctor() || isReceptionist()) ? 2 : 3,
              totalCount: (isDoctor() || isReceptionist()) ? 2 : 3,
              percentage: 1,
            ),
            16.height,
            Row(
              children: [
                if (isProEnabled()) SelectedClinicComponent(clinicId: widget.clinicId.validate()).expand(),
                if (isProEnabled()) 16.width,
                SelectedDoctorWidget(
                  clinicId: widget.clinicId.validate(),
                  doctorId: isUpdate ? widget.data!.doctorId.toInt() : widget.doctorId.validate(),
                ).expand(),
              ],
            ),
            16.height,
            RoleWidget(
              isShowDoctor: true,
              isShowReceptionist: true,
              child: Column(
                children: [
                  AppTextField(
                    controller: patientNameCont,
                    textFieldType: TextFieldType.OTHER,
                    focus: patientNameFocus,
                    textInputAction: TextInputAction.next,
                    nextFocus: serviceFocus,
                    validator: (patient) {
                      if (patient!.trim().isEmpty) return locale.lblPatientNameIsRequired;
                      return null;
                    },
                    decoration: inputDecoration(
                      context: context,
                      labelText: locale.lblPatientName,
                      suffixIcon: ic_user.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                    ),
                    readOnly: true,
                    onTap: () async {
                      PatientSearchScreen(selectedData: user).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                        if (value != null) {
                          user = value as UserModel;
                          appointmentAppStore.setSelectedPatientId(user!.iD.validate());
                          appointmentAppStore.setSelectedPatient(user!.displayName);
                          patientNameCont.text = user!.displayName.validate();
                        }
                      });
                    },
                  ),
                  if (patientNameCont.text.isEmptyOrNull)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(locale.lblAddNewPatient, style: secondaryTextStyle(color: appPrimaryColor, size: 10)).paddingOnly(top: 10).appOnTap(
                            () => AddPatientScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then(
                              (value) {
                                if (value ?? false) {
                                  init();
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                    )
                ],
              ),
            ),
            RoleWidget(
              isShowDoctor: true,
              isShowReceptionist: true,
              child: 16.height,
            ),
            Observer(
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: servicesCont,
                      focus: serviceFocus,
                      nextFocus: dateFocus,
                      textInputAction: TextInputAction.next,
                      textFieldType: TextFieldType.NAME,
                      validator: (value) {
                        if (multiSelectStore.selectedService.isEmpty) {
                          return locale.lblSelectServices;
                        } else
                          return null;
                      },
                      decoration: inputDecoration(
                        context: context,
                        labelText: locale.lblSelectServices,
                        suffixIcon: Icon(Icons.arrow_drop_down, color: context.iconColor),
                      ).copyWith(
                        border: multiSelectStore.selectedService.isNotEmpty
                            ? OutlineInputBorder(borderSide: BorderSide.none, borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius))
                            : null,
                        enabledBorder: multiSelectStore.selectedService.isNotEmpty
                            ? OutlineInputBorder(borderSide: BorderSide.none, borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius))
                            : null,
                        focusedBorder: multiSelectStore.selectedService.isNotEmpty
                            ? OutlineInputBorder(borderSide: BorderSide.none, borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius))
                            : null,
                      ),
                      readOnly: true,
                      onTap: () {
                        if (!isUpdate) {
                          selectServices();
                        } else {
                          toast(locale.lblEditHolidayRestriction);
                        }
                      },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radiusOnly(bottomLeft: defaultRadius, bottomRight: defaultRadius)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(locale.lblService.getApostropheString(count: multiSelectStore.selectedService.length, apostrophe: false), style: boldTextStyle(size: 12)).expand(),
                              Text(locale.lblCharges.getApostropheString(count: multiSelectStore.selectedService.length, apostrophe: false), style: boldTextStyle(size: 12)),
                            ],
                          ),
                          Divider(
                            color: context.dividerColor,
                          ),
                          Column(
                            children: List.generate(
                              multiSelectStore.selectedService.length,
                              (index) {
                                ServiceData data = multiSelectStore.selectedService[index];
                                return Row(
                                  children: [
                                    Marquee(child: Text(data.name.validate(), style: primaryTextStyle(size: 14))).expand(),
                                    PriceWidget(
                                      price: data.charges.validate().toDouble().toStringAsFixed(2),
                                      textStyle: primaryTextStyle(size: 14),
                                    ),
                                  ],
                                ).paddingBottom(2);
                              },
                            ),
                          ),
                          Divider(
                            color: context.dividerColor,
                          ),
                          Row(
                            children: [
                              Text((multiSelectStore.taxData != null && multiSelectStore.taxData!.taxList.validate().isNotEmpty) ? locale.lblSubTotal : locale.lblTotal,
                                      style: primaryTextStyle(size: 14))
                                  .expand(),
                              PriceWidget(price: multiSelectStore.selectedService.sumByDouble((p0) => p0.charges.toDouble()).toStringAsFixed(2), textSize: 14),
                            ],
                          ),
                        ],
                      ),
                    ).visible(multiSelectStore.selectedService.isNotEmpty),
                    if (isVisible(SharedPreferenceKey.kiviCareServiceAddKey))
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(locale.lblAddService, style: secondaryTextStyle(color: appPrimaryColor, size: 10)).paddingOnly(top: 10).appOnTap(
                              () => AddServiceScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration),
                            ),
                      ).visible((multiSelectStore.selectedService.isEmpty) && (isDoctor() || isReceptionist())),
                    if (multiSelectStore.taxData != null) 16.height,
                    if (multiSelectStore.taxData != null)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(locale.lblTax, style: boldTextStyle(size: 12)).expand(),
                                16.width,
                                Text(
                                  locale.lblTaxRate,
                                  style: boldTextStyle(size: 12),
                                  textAlign: TextAlign.center,
                                ).expand(flex: 2),
                                16.width,
                                Text(
                                  locale.lblCharges,
                                  style: boldTextStyle(size: 12),
                                  textAlign: TextAlign.end,
                                ).expand(),
                              ],
                            ),
                            Divider(
                              color: context.dividerColor,
                            ),
                            ...multiSelectStore.taxData!.taxList.validate().map<Widget>((data) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(data.taxName.validate().replaceAll(RegExp(r'[^a-zA-Z]'), ''), maxLines: 1, overflow: TextOverflow.ellipsis, style: secondaryTextStyle(size: 14)).expand(),
                                  if (data.taxName.validate().contains('%'))
                                    Text(
                                      data.taxRate.validate().toString().suffixText(value: '%'),
                                      style: primaryTextStyle(size: 14),
                                      textAlign: TextAlign.center,
                                    ).expand(flex: 2)
                                  else
                                    PriceWidget(
                                      price: data.taxRate.validate().toStringAsFixed(2),
                                      textStyle: primaryTextStyle(size: 14),
                                      textAlign: TextAlign.center,
                                    ).paddingLeft(4).expand(flex: 2),
                                  PriceWidget(
                                    price: data.charges.validate().toStringAsFixed(2),
                                    textStyle: primaryTextStyle(size: 14),
                                    textAlign: TextAlign.end,
                                  ).paddingLeft(4).expand(),
                                ],
                              );
                            }).toList(),
                            if (multiSelectStore.taxData != null)
                              Divider(
                                color: context.dividerColor,
                              ),
                            if (multiSelectStore.taxData != null)
                              Row(
                                children: [
                                  Text(locale.lblTotalTax, style: primaryTextStyle(size: 14)).expand(),
                                  PriceWidget(price: multiSelectStore.taxData!.totalTax.validate().toStringAsFixed(2), textStyle: boldTextStyle(size: 14)),
                                ],
                              ),
                            Divider(
                              color: context.dividerColor,
                            ),
                            Row(
                              children: [
                                Text(locale.lblTotal, style: boldTextStyle(size: 14)).expand(),
                                PriceWidget(price: getTotalText().toStringAsFixed(2), textStyle: boldTextStyle(size: 14, color: appPrimaryColor)),
                              ],
                            ),
                          ],
                        ),
                      ).visible(multiSelectStore.taxData!.taxList.validate().isNotEmpty),
                  ],
                );
              },
            ),
            16.height,
            AppointmentDateComponent(initialDate: isUpdate ? DateFormat(SAVE_DATE_FORMAT).parse(widget.data!.appointmentGlobalStartDate.validate()) : DateTime.now()),
            16.height,
            AppointmentSlots(
              date: isUpdate ? widget.data?.getAppointmentSaveDate : getAppointmentDate,
              clinicId: isUpdate ? widget.data?.clinicId.validate() : widget.clinicId.validate().toString(),
              doctorId: isUpdate ? widget.data?.doctorId.validate() : widget.doctorId.validate().toString(),
              appointmentTime: isUpdate ? widget.data?.getAppointmentTime.validate() : '',
            ),
            16.height,
            AppTextField(
              maxLines: 15,
              minLines: 5,
              controller: descriptionCont,
              textInputAction: TextInputAction.done,
              focus: descFocus,
              isValidationRequired: false,
              textFieldType: TextFieldType.MULTILINE,
              decoration: inputDecoration(context: context, labelText: locale.lblDescription),
            ),
            16.height,
            FileUploadComponent().paddingBottom(32),
          ],
        ),
      ),
      bottomNavigationBar: AppButton(
        text: locale.lblBookAppointment,
        onTap: () async {
          appointmentAppStore.setDescription(descriptionCont.text);
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();

            bool? res = await showInDialog(
              context,
              contentPadding: EdgeInsets.zero,
              backgroundColor: context.cardColor,
              barrierDismissible: !isPatient(),
              builder: (p0) {
                return ConfirmAppointmentComponent(appointmentId: widget.data?.id.toInt() ?? null);
              },
            );
            if (res ?? false) {}
          } else {
            isFirstTime = !isFirstTime;
            setState(() {});
          }
        },
      ).paddingAll(16),
    );
  }

  num getTotalText() {
    num total = 0.0;
    if (multiSelectStore.taxData != null) {
      total = (multiSelectStore.selectedService.sumByDouble((p0) => p0.charges.toDouble()) + multiSelectStore.taxData!.totalTax.validate());
    } else
      total = multiSelectStore.selectedService.sumByDouble((p0) => p0.charges.toDouble());
    return total;
  }
}
