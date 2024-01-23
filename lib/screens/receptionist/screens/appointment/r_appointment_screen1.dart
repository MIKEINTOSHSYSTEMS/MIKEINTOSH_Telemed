import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/components/common/appoitment_slots.dart';
import 'package:momona_healthcare/components/multi_select.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_dashboard_model.dart';
import 'package:momona_healthcare/model/doctor_list_model.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/screens/receptionist/components/doctor_drop_down.dart';
import 'package:momona_healthcare/screens/receptionist/screens/appointment/component/r_date_component.dart';
import 'package:momona_healthcare/screens/receptionist/screens/appointment/r_appointment_screen2.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class RAppointment1Screen extends StatefulWidget {
  final int? id;
  final UpcomingAppointment? data;

  RAppointment1Screen({this.id, this.data});

  @override
  _RAppointment1ScreenState createState() => _RAppointment1ScreenState();
}

class _RAppointment1ScreenState extends State<RAppointment1Screen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController appointmentDateCont = TextEditingController();
  TextEditingController appointmentSlotsCont = TextEditingController();
  TextEditingController servicesCont = TextEditingController();

  List<String?> ids = [];
  List<ServiceData> selectedServicesList = [];

  bool isUpdate = false;

  int doctorDataId = -1;

  UpcomingAppointment? upcomingAppointment;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isUpdate = widget.data != null;

    if (widget.id != null) {
      doctorDataId = widget.id.validate();
    }
    if (isUpdate) {
      upcomingAppointment = widget.data;
      if (upcomingAppointment != null) {
        for (int i = 0; i < upcomingAppointment!.visit_type.validate().length; i++) {
          multiSelectStore.selectedService.add(ServiceData(id: upcomingAppointment!.visit_type![i].id, name: upcomingAppointment!.visit_type![i].service_name, service_id: upcomingAppointment!.visit_type![i].service_id));
        }
        servicesCont.text = multiSelectStore.selectedService.length.toString() + ' ' + locale.lblServicesSelected;
        List<int> temp = [];

        multiSelectStore.selectedService.forEach((element) {
          temp.add(element.service_id.toInt());
        });

        appointmentAppStore.addSelectedService(temp);
        setState(() {});
      }
      if (upcomingAppointment!.appointment_report.validate().isNotEmpty) {
        appointmentAppStore.addReportListString(data: upcomingAppointment!.appointment_report!);
      }
    }

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appointmentAppStore.setSelectedClinic(null);
    appointmentAppStore.setSelectedDoctor(null);
    appointmentAppStore.setDescription(null);
    appointmentAppStore.setSelectedPatient(null);
    appointmentAppStore.setSelectedTime(null);
    super.dispose();

    multiSelectStore.clearList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblStep1, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_outlined, color: textPrimaryDarkColor),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            RAppointmentScreen2(updatedData: upcomingAppointment).launch(context);
          }
        },
      ),
    );
  }

  Widget body() {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AnimatedScrollView(
        padding: EdgeInsets.only(bottom: 26),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          AbsorbPointer(
            absorbing: isUpdate,
            child: DoctorDropDown(
              isValidate: true,
              doctorId: upcomingAppointment?.doctor_id.validate().toInt(),
              onSelected: (DoctorList? doctorCont) {
                appointmentAppStore.setSelectedDoctor(doctorCont);
                multiSelectStore.clearList();
                LiveStream().emit(CHANGE_DATE, true);
                setState(() {});
              },
            ).paddingSymmetric(horizontal: 16),
          ),
          16.height,
          AbsorbPointer(
            absorbing: isUpdate,
            child: AppTextField(
              controller: servicesCont,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblSelectServices,
              ),
              validator: (v) {
                if (v!.trim().isEmpty) return locale.lblServicesIsRequired;
                return null;
              },
              readOnly: true,
              onTap: () async {
                if (appointmentAppStore.mDoctorSelected == null && !isDoctor()) {
                  toast(locale.lblPleaseSelectDoctor);
                } else {
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
                }
                setState(() {});
              },
            ).paddingSymmetric(horizontal: 16),
          ),
          Observer(
            builder: (_) {
              return AbsorbPointer(
                absorbing: isUpdate,
                child: Wrap(
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
                          multiSelectStore.removeItem(data);

                          if (multiSelectStore.selectedService.length > 0) {
                            servicesCont.text = "${multiSelectStore.selectedService.length} " + locale.lblServicesSelected;
                          } else {
                            servicesCont.clear();
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(defaultRadius),
                          side: BorderSide(color: viewLineColor),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ).paddingSymmetric(vertical: 8, horizontal: 16),
          8.height,
          isUpdate
              ? RDateComponent(
                  initialDate: DateTime.parse(upcomingAppointment!.appointment_start_date.validate()),
                )
              : RDateComponent(),
          16.height,
          isUpdate
              ? AppointmentSlots(
                  doctorId: upcomingAppointment!.doctor_id.toInt(),
                  appointmentTime: DateFormat(TIME_WITH_SECONDS).parse(upcomingAppointment!.appointment_start_time!).getFormattedDate(FORMAT_12_HOUR),
                ).paddingSymmetric(horizontal: 16)
              : AppointmentSlots().paddingSymmetric(horizontal: 16),
          16.height,
        ],
      ),
    );
  }
}
