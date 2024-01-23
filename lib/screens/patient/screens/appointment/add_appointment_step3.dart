import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/components/body_widget.dart';
import 'package:momona_healthcare/components/common/appoitment_slots.dart';
import 'package:momona_healthcare/components/multi_select.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_dashboard_model.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/network/clinic_repository.dart';
import 'package:momona_healthcare/network/doctor_list_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/appointment/component/d_file_upload_component.dart';
import 'package:momona_healthcare/screens/patient/components/selected_clinic_widget.dart';
import 'package:momona_healthcare/screens/patient/components/selected_doctor_widget.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/component/p_confirm_appointment_screen.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/component/p_date_component.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/component/step_progress_indicator.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class AddAppointmentScreenStep3 extends StatefulWidget {
  final int? id;
  final UpcomingAppointment? data;

  AddAppointmentScreenStep3({this.id, this.data});

  @override
  _AddAppointmentScreenStep3State createState() => _AddAppointmentScreenStep3State();
}

class _AddAppointmentScreenStep3State extends State<AddAppointmentScreenStep3> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController descriptionCont = TextEditingController();
  TextEditingController servicesCont = TextEditingController();

  UpcomingAppointment? upcomingAppointment;

  bool isUpdate = false;

  List<String?> ids = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    multiSelectStore.clearList();
    isUpdate = widget.data != null;
    upcomingAppointment = widget.data;

    if (isUpdate) {
      appStore.setLoading(true);

      if (upcomingAppointment!.visit_type.validate().isNotEmpty) {
        upcomingAppointment!.visit_type.validate().forEach((element) {
          multiSelectStore.selectedService.add(ServiceData(id: element.id, name: element.service_name, service_id: element.service_id));
        });

        servicesCont.text = "${multiSelectStore.selectedService.length} " + locale.lblServicesSelected;
        List<int> temp = [];

        multiSelectStore.selectedService.forEach((element) {
          temp.add(element.service_id.toInt());
        });

        appointmentAppStore.addSelectedService(temp);
      }
      if (upcomingAppointment!.appointment_report != null || upcomingAppointment!.appointment_report.validate().isNotEmpty) {
        appointmentAppStore.addReportListString(data: upcomingAppointment!.appointment_report!);
      }

      log(appointmentAppStore.reportListString.length);

      await getDoctor(clinicId: upcomingAppointment!.clinic_id.validate().toInt()).then((value) {
        appointmentAppStore.setSelectedDoctor(value.firstWhereOrNull(
          (element) => element.iD == upcomingAppointment!.doctor_id.toInt(),
        ));
      });

      await getClinic().then((value) {
        appointmentAppStore.setSelectedClinic(value.firstWhereOrNull(
          (element) => element.clinic_id.validate() == upcomingAppointment!.clinic_id.validate(),
        ));
        appStore.setLoading(false);
      });
    }
    log(upcomingAppointment != null);
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (!appStore.isBookedFromDashboard) {
      appointmentAppStore.setSelectedDoctor(null);
    }
    appointmentAppStore.setDescription(null);
    appointmentAppStore.setSelectedPatient(null);
    appointmentAppStore.setSelectedClinic(null);
    appointmentAppStore.setSelectedTime(null);
    appointmentAppStore.setSelectedPatientId(null);
    super.dispose();
  }

  Widget buildProgressWidget() {
    return Row(
      children: [
        Text(locale.lblSelectDateTime, style: boldTextStyle(size: titleTextSize)).expand(),
        16.width,
        StepProgressIndicator(stepTxt: "3/3", percentage: 1.0),
      ],
    );
  }

  Widget buildClinicAndDoctorWidget() {
    return Row(
      children: [
        if (isProEnabled()) SelectedClinicWidget().expand(),
        if (isProEnabled()) 16.width,
        SelectedDoctorWidget().expand(),
      ],
    );
  }

  Widget buildServicesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: servicesCont,
          textFieldType: TextFieldType.NAME,
          decoration: inputDecoration(context: context, labelText: locale.lblSelectServices),
          readOnly: true,
          onTap: () async {
            if (!isUpdate) {
              if (multiSelectStore.selectedService.validate().isNotEmpty) {
                multiSelectStore.selectedService.forEach((element) {
                  ids.add(element.id);
                });
              }
            } else {
              ids.clear();
              if (multiSelectStore.selectedService.validate().isNotEmpty) {
                multiSelectStore.selectedService.forEach((element) {
                  ids.add(element.service_id);
                });
              }
            }

            bool? res = await MultiSelectWidget(selectedServicesId: ids).launch(context);
            if (res ?? false) {
              List<int> temp = [];

              multiSelectStore.selectedService.forEach((element) {
                temp.add(element.id.toInt());
              });

              appointmentAppStore.addSelectedService(temp);
              if (multiSelectStore.selectedService.length > 0) {
                servicesCont.text = "${multiSelectStore.selectedService.length} " + locale.lblServicesSelected;
              }
              setState(() {});
            }
          },
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
                    backgroundColor: context.cardColor,
                    deleteIcon: Icon(Icons.clear),
                    deleteIconColor: Colors.red,
                    onDeleted: () {
                      multiSelectStore.removeItem(data);
                      if (multiSelectStore.selectedService.length > 0) {
                        servicesCont.text = "${multiSelectStore.selectedService.length} " + locale.lblServicesSelected;
                      } else {
                        servicesCont.clear();
                      }
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius), side: BorderSide(color: viewLineColor)),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblConfirmAppointment, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context), textColor: Colors.white),
      body: Body(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProgressWidget(),
                16.height,
                buildClinicAndDoctorWidget(),
                16.height,
                buildServicesWidget(),
                16.height,
                PDateComponent(initialDate: isUpdate ? DateTime.parse(upcomingAppointment!.appointment_start_date.validate()) : null),
                16.height,
                AppointmentSlots(
                  doctorId: isUpdate ? upcomingAppointment!.doctor_id.toInt() : null,
                  appointmentTime: isUpdate ? DateFormat(TIME_WITH_SECONDS).parse(upcomingAppointment!.appointment_start_time!).getFormattedDate(FORMAT_12_HOUR) : null,
                ),
                AbsorbPointer(
                  absorbing: isUpdate,
                  child: AppTextField(
                    maxLines: 15,
                    minLines: 5,
                    controller: descriptionCont,
                    textFieldType: TextFieldType.MULTILINE,
                    decoration: inputDecoration(context: context, labelText: locale.lblDescription).copyWith(
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                16.height,
                DFileUploadComponent(),
                86.height,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appSecondaryColor,
        label: Text(locale.lblBook, style: boldTextStyle(color: white)).paddingSymmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            hideKeyboard(context);
            appointmentAppStore.setDescription(descriptionCont.text);
            await showInDialog(
              context,
              barrierDismissible: false,
              backgroundColor: context.cardColor,
              builder: (p0) {
                return isUpdate ? PConfirmAppointmentScreen(appointmentId: widget.data?.id.toInt()) : PConfirmAppointmentScreen();
              },
            );
          }
        },
      ),
    );
  }
}
