import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_dashboard_model.dart';
import 'package:kivicare_flutter/model/patient_list_model.dart';
import 'package:kivicare_flutter/network/patient_list_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/appointment/component/d_file_upload_component.dart';
import 'package:kivicare_flutter/screens/doctor/screens/appointment/component/d_patient_select_component.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/appointment/component/r_confirm_appointment_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class RAppointmentScreen2 extends StatefulWidget {
  final UpcomingAppointment? updatedData;

  RAppointmentScreen2({this.updatedData});

  @override
  _RAppointmentScreen2State createState() => _RAppointmentScreen2State();
}

class _RAppointmentScreen2State extends State<RAppointmentScreen2> {
  GlobalKey<FormState> formKey = GlobalKey();
  AsyncMemoizer<PatientListModel> _memorizer = AsyncMemoizer();

  List<String> statusList = [locale.lblBooked, locale.lblCheckOut, locale.lblCheckIn, locale.lblCancelled];
  List<String?> pName = [];

  bool isUpdate = false;

  String? statusCont = locale.lblBooked;
  TextEditingController descriptionCont = TextEditingController();
  TextEditingController patientNameCont = TextEditingController();
  TextEditingController patientIdCont = TextEditingController();
  Map<String, dynamic> request = {};
  List<PatientData> list = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    int? id = statusCont!.getStatus();
    appointmentAppStore.setStatusSelected(id);
    isUpdate = widget.updatedData != null;
    if (isUpdate) {
      appointmentAppStore.setSelectedDoctor(listAppStore.doctorList.firstWhereOrNull(
        (element) => element!.iD == widget.updatedData!.doctor_id.toInt(),
      ));
      appointmentAppStore.setSelectedPatient(widget.updatedData!.patient_name);
      appointmentAppStore.setSelectedPatientId(widget.updatedData!.patient_id.toInt());
      patientNameCont.text = widget.updatedData!.patient_name!;
      patientIdCont.text = widget.updatedData!.patient_id!;
      descriptionCont.text = widget.updatedData!.description.validate();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblStep2, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Body(child: body()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.done, color: textPrimaryDarkColor),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            appointmentAppStore.setDescription(descriptionCont.text);
            hideKeyboard(context);
            await showInDialog(
              context,
              barrierDismissible: false,
              backgroundColor: Theme.of(context).cardColor,
              builder: (p0) {
                return isUpdate ? RConfirmAppointmentScreen(appointmentId: widget.updatedData?.id.toInt()) : RConfirmAppointmentScreen();
              },
            );
          }
        },
      ),
    );
  }

  Widget body() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: AnimatedScrollView(
        padding: EdgeInsets.all(16),
        children: [
          DFileUploadComponent(),
          16.height,
          FutureBuilder<PatientListModel>(
            future: _memorizer.runOnce(() => getPatientList()),
            builder: (_, snap) {
              if (snap.hasData) {
                pName.clear();

                snap.data!.patientData!.forEach((element) {
                  pName.add(element.display_name);
                });
                return AppTextField(
                  controller: patientNameCont,
                  textFieldType: TextFieldType.OTHER,
                  validator: (s) {
                    if (s!.trim().isEmpty) return locale.lblPatientNameIsRequired;
                    return null;
                  },
                  decoration: inputDecoration(context: context, labelText: locale.lblPatientName),
                  readOnly: true,
                  onTap: () async {
                    String? name = await DPatientSelectScreen(searchList: pName, name: locale.lblPatientName).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);

                    if (name == null) {
                      patientNameCont.clear();
                    } else {
                      list = snap.data!.patientData!.where((element) {
                        return element.display_name == name;
                      }).toList();
                      appointmentAppStore.setSelectedPatient(name);
                      patientNameCont.text = name;
                      patientIdCont.text = list[0].iD.toString();

                      appointmentAppStore.setSelectedPatientId(patientIdCont.text.toInt());
                    }
                  },
                );
              }

              return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget(size: loaderSize));
            },
          ),
          16.height,
          DropdownButtonFormField(
            decoration: inputDecoration(
              context: context,
              labelText: locale.lblStatus,
            ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
            isExpanded: true,
            dropdownColor: context.cardColor,
            value: statusCont,
            icon: SizedBox.shrink(),
            onChanged: (dynamic value) {
              statusCont = value;
              int? id = statusCont!.getStatus();
              appointmentAppStore.setStatusSelected(id);
              setState(() {});
            },
            items: statusList
                .map(
                  (data) => DropdownMenuItem(
                    value: data,
                    child: Text("$data", style: primaryTextStyle()),
                  ),
                )
                .toList(),
          ),
          16.height,
          AppTextField(
            maxLines: 10,
            minLines: 5,
            controller: descriptionCont,
            textAlign: TextAlign.start,
            textFieldType: TextFieldType.MULTILINE,
            decoration: inputDecoration(context: context, labelText: locale.lblDescription),
          )
        ],
      ),
    );
  }
}
