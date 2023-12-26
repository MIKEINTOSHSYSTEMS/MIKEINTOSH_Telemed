import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_dashboard_model.dart';
import 'package:kivicare_flutter/model/patient_list_model.dart';
import 'package:kivicare_flutter/network/doctor_list_repository.dart';
import 'package:kivicare_flutter/network/patient_list_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/appointment/component/d_confirm_appointment_screen.dart';
import 'package:kivicare_flutter/screens/doctor/screens/appointment/component/d_file_upload_component.dart';
import 'package:kivicare_flutter/screens/doctor/screens/appointment/component/d_patient_select_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorAddAppointmentStep2Screen extends StatefulWidget {
  final int? id;
  final UpcomingAppointment? appointmentData;

  DoctorAddAppointmentStep2Screen({this.id, this.appointmentData});

  @override
  State<DoctorAddAppointmentStep2Screen> createState() => _DoctorAddAppointmentStep2ScreenState();
}

class _DoctorAddAppointmentStep2ScreenState extends State<DoctorAddAppointmentStep2Screen> {
  GlobalKey<FormState> formKey = GlobalKey();
  AsyncMemoizer<PatientListModel> _memorizer = AsyncMemoizer();

  List<String> statusList = [locale.lblBooked, locale.lblCheckOut, locale.lblCheckIn, locale.lblCancelled];
  List<String?> patientName = [];
  List<PatientData?> patientList = [];

  TextEditingController descriptionCont = TextEditingController();
  TextEditingController patientNameCont = TextEditingController();
  TextEditingController patientIdCont = TextEditingController();
  bool isUpdate = false;

  String? appointmentStatus = locale.lblBooked;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.appointmentData != null;
    int? id = appointmentStatus!.getStatus();
    appointmentAppStore.setStatusSelected(id);
    if (isUpdate) {
      appointmentAppStore.setSelectedPatient(widget.appointmentData!.patient_name);
      appointmentAppStore.setSelectedPatientId(widget.appointmentData!.patient_id.toInt());
      patientNameCont.text = widget.appointmentData!.patient_name.validate();
      patientIdCont.text = widget.appointmentData!.patient_id.validate();
      descriptionCont.text = widget.appointmentData!.description.validate();
      await getDoctorList(clinicId: widget.appointmentData!.clinic_id.validate().toInt()).then((value) {
        appointmentAppStore.setSelectedDoctor(value.doctorList.validate().firstWhere((element) => element.iD.validate() == widget.appointmentData!.doctor_id.toInt()));
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget buildPatientWidget() {
    return FutureBuilder<PatientListModel>(
      future: _memorizer.runOnce(() => getPatientList()),
      builder: (_, snap) {
        if (snap.hasData) {
          patientName.clear();

          snap.data!.patientData?.forEach((element) {
            patientName.add(element.display_name);
          });
          return AppTextField(
            controller: patientNameCont,
            textFieldType: TextFieldType.OTHER,
            validator: (s) {
              if (s!.trim().isEmpty) return locale.lblPatientNameIsRequired;
              return null;
            },
            decoration: inputDecoration(
              context: context,
              labelText: locale.lblPatientName,
            ).copyWith(suffixIcon: ic_user.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
            readOnly: true,
            onTap: () async {
              String? value = await DPatientSelectScreen(searchList: patientName, name: locale.lblPatientName).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              if (value == null) {
                patientNameCont.clear();
              } else {
                patientList = snap.data!.patientData!.where((element) => element.display_name == value).toList();
                appointmentAppStore.setSelectedPatient(value);
                patientNameCont.text = value;
                patientIdCont.text = patientList.first!.iD.toString();

                appointmentAppStore.setSelectedPatientId(patientIdCont.text.toInt());
              }
              return;
            },
          );
        }

        return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget(size: loaderSize));
      },
    );
  }

  Widget buildBodyWidget() {
    return AbsorbPointer(
      absorbing: isUpdate,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: AnimatedScrollView(
          padding: EdgeInsets.all(16),
          children: [
            16.height,
            buildPatientWidget(),
            16.height,
            AppTextField(
              maxLines: 10,
              minLines: 5,
              controller: descriptionCont,
              textAlign: TextAlign.start,
              textFieldType: TextFieldType.MULTILINE,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblDescription,
              ).copyWith(suffixIcon: ic_description.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
            ),
            16.height,
            DropdownButtonFormField<String>(
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblStatus,
              ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
              icon: SizedBox.shrink(),
              isExpanded: true,
              dropdownColor: Theme.of(context).cardColor,
              value: appointmentStatus,
              onChanged: (value) {
                appointmentStatus = value;
                int? id = appointmentStatus!.getStatus();
                appointmentAppStore.setStatusSelected(id);
                setState(() {});
              },
              items: statusList.map((data) => DropdownMenuItem(value: data, child: Text("$data", style: primaryTextStyle()))).toList(),
            ),
            16.height,
            DFileUploadComponent(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblStep2, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.done, color: textPrimaryDarkColor),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            appointmentAppStore.setDescription(descriptionCont.text.trim());
            hideKeyboard(context);
            await showInDialog(
              context,
              barrierDismissible: false,
              backgroundColor: Theme.of(context).cardColor,
              builder: (p0) {
                return DConfirmAppointmentScreen(appointmentId: widget.appointmentData?.id.toInt());
              },
            );
          }
        },
      ),
    );
  }
}
