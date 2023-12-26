import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/common/appoitment_slots.dart';
import 'package:kivicare_flutter/components/common/clinic_drop_down.dart';
import 'package:kivicare_flutter/components/multi_select.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_dashboard_model.dart';
import 'package:kivicare_flutter/model/login_response_model.dart';
import 'package:kivicare_flutter/model/service_model.dart';
import 'package:kivicare_flutter/screens/doctor/screens/appointment/component/d_date_component.dart';
import 'package:kivicare_flutter/screens/doctor/screens/appointment/doctor_add_appointment_step2_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorAddAppointmentStep1Screen extends StatefulWidget {
  final int? id;
  final UpcomingAppointment? appointmentData;

  DoctorAddAppointmentStep1Screen({this.id, this.appointmentData});

  @override
  State<DoctorAddAppointmentStep1Screen> createState() => _DoctorAddAppointmentStep1ScreenState();
}

class _DoctorAddAppointmentStep1ScreenState extends State<DoctorAddAppointmentStep1Screen> {
  var formKey = GlobalKey<FormState>();

  bool isUpdate = false;

  TextEditingController appointmentDateCont = TextEditingController();
  TextEditingController appointmentSlotsCont = TextEditingController();
  TextEditingController servicesCont = TextEditingController();

  List<String?> serviceIds = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.appointmentData != null;

    if (isUpdate) {
      multiSelectStore.clearList();

      if (widget.appointmentData!.visit_type.validate().isNotEmpty) {
        multiSelectStore.selectedService.addAll(widget.appointmentData!.visit_type!.map((e) => ServiceData(id: e.id, name: e.service_name, service_id: e.service_id)));
        servicesCont.text = "${multiSelectStore.selectedService.length} " + locale.lblServicesSelected;
        appointmentAppStore.addSelectedService(multiSelectStore.selectedService.map((element) => element.id.toInt()).toList());
        appointmentAppStore.addReportListString(data: widget.appointmentData!.appointment_report.validate());
      }
    } else {
      appointmentAppStore.setSelectedAppointmentDate(DateTime.now());
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appointmentAppStore.setSelectedClinic(null);
    appointmentAppStore.setSelectedDoctor(null);
    multiSelectStore.selectedService.clear();
    appointmentAppStore.setDescription(null);
    appointmentAppStore.setSelectedPatient(null);
    appointmentAppStore.setSelectedTime(null);
    super.dispose();
  }

  Widget buildBodyWidget() {
    return Body(
      child: Form(
        key: formKey,
        child: AnimatedScrollView(
          children: [
            16.height,
            if (isProEnabled())
              AbsorbPointer(
                absorbing: isUpdate,
                child: ClinicDropDown(
                  isValidate: true,
                  clinicId: widget.appointmentData?.clinic_id?.toInt(),
                  onSelected: (Clinic? value) {
                    appointmentAppStore.setSelectedClinic(value);
                  },
                ).paddingSymmetric(vertical: 0, horizontal: 16),
              ),
            16.height,
            AbsorbPointer(
              absorbing: isUpdate,
              child: AppTextField(
                controller: servicesCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(
                  context: context,
                  labelText: locale.lblSelectServices,
                ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                validator: (v) {
                  if (v!.trim().isEmpty) return locale.lblServicesIsRequired;
                  return null;
                },
                readOnly: true,
                onTap: () async {
                  serviceIds.clear();
                  if (multiSelectStore.selectedService.validate().isNotEmpty) {
                    serviceIds.addAll(multiSelectStore.selectedService.map((element) => element.service_id.validate()));
                  }
                  bool? res = await MultiSelectWidget(selectedServicesId: serviceIds).launch(context);

                  if (res ?? false) {
                    appointmentAppStore.addSelectedService(multiSelectStore.selectedService.map((element) => element.id.toInt().validate()).toList());
                    if (multiSelectStore.selectedService.length > 0) {
                      servicesCont.text = "${multiSelectStore.selectedService.length} " + locale.lblServicesSelected;
                    }
                  }
                },
              ).paddingSymmetric(horizontal: 16),
            ),
            Observer(
              builder: (_) {
                return Wrap(
                  spacing: 8,
                  children: List.generate(
                    multiSelectStore.selectedService.length,
                    (index) {
                      ServiceData data = multiSelectStore.selectedService[index];
                      return Chip(
                        label: Text('${data.name}', style: primaryTextStyle()),
                        backgroundColor: Theme.of(context).cardColor,
                        deleteIcon: Icon(Icons.clear),
                        deleteIconColor: Colors.red,
                        onDeleted: () {
                          showConfirmDialogCustom(
                            context,
                            dialogType: DialogType.DELETE,
                            onAccept: (p0) {
                              finish(context);
                              multiSelectStore.removeItem(data);
                              if (multiSelectStore.selectedService.length > 0) {
                                servicesCont.text = "${multiSelectStore.selectedService.length} " + locale.lblServicesSelected;
                              } else {
                                servicesCont.clear();
                              }
                            },
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: radius(),
                          side: BorderSide(color: viewLineColor),
                        ),
                      );
                    },
                  ),
                );
              },
            ).paddingSymmetric(horizontal: 16),
            16.height,
            DDateComponent(initialDate: isUpdate ? DateTime.parse(widget.appointmentData!.appointment_start_date.validate()) : null),
            16.height,
            AppointmentSlots(doctorId: widget.appointmentData?.doctor_id.toInt(), appointmentTime: widget.appointmentData?.getAppointmentTime).paddingSymmetric(horizontal: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblStep1, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.arrow_forward_outlined, color: textPrimaryDarkColor),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();

            DoctorAddAppointmentStep2Screen(appointmentData: widget.appointmentData).launch(context);
          }
        },
      ),
    );
  }
}
