import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/common/clinic_drop_down.dart';
import 'package:momona_healthcare/components/role_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_list_model.dart';
import 'package:momona_healthcare/model/login_response_model.dart';
import 'package:momona_healthcare/model/patient_encounter_list_model.dart';
import 'package:momona_healthcare/network/encounter_repository.dart';
import 'package:momona_healthcare/screens/receptionist/components/doctor_drop_down.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class AddEncounterScreen extends StatefulWidget {
  final PatientEncounterData? patientEncounterData;
  final int? patientId;

  AddEncounterScreen({this.patientEncounterData, this.patientId});

  @override
  _AddEncounterScreenState createState() => _AddEncounterScreenState();
}

class _AddEncounterScreenState extends State<AddEncounterScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController encounterDateCont = TextEditingController();
  TextEditingController encounterDescriptionCont = TextEditingController();

  PatientEncounterData? patientEncounterData;

  late Clinic selectedClinic;

  late DoctorList selectedDoctor;

  DateTime current = DateTime.now();

  int? clinicId;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isUpdate = widget.patientEncounterData != null;
    if (isUpdate) {
      patientEncounterData = widget.patientEncounterData;
      encounterDateCont.text = patientEncounterData!.encounter_date!.getFormattedDate(APPOINTMENT_DATE_FORMAT);
      current = DateTime.parse(patientEncounterData!.encounter_date!);
      encounterDescriptionCont.text = patientEncounterData!.description.validate();
      clinicId = patientEncounterData!.clinic_id.toInt();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void saveEncounter() async {
    appStore.setLoading(true);

    Map request = {
      "date": encounterDateCont.text,
      "patient_id": widget.patientId,
      "doctor_id": getIntAsync(USER_ID),
      "description": encounterDescriptionCont.text,
      "status": "1",
    };

    if (isDoctor()) {
      if (isProEnabled()) {
        request.putIfAbsent("clinic_id", () => selectedClinic.clinic_id);
      } else {
        request.putIfAbsent("clinic_id", () => getIntAsync(USER_CLINIC));
      }
    } else if (isReceptionist()) {
      request.putIfAbsent("clinic_id", () => getIntAsync(USER_CLINIC));
      request.putIfAbsent("doctor_id", () => selectedDoctor.iD);
    }

    addEncounterData(request).then((value) {
      toast(locale.lblAddedNewEncounter);
      finish(context, true);
    }).catchError((e) {
      toast(e);
    });
    appStore.setLoading(false);
  }

  void updateEncounter() async {
    appStore.setLoading(true);

    Map request = {
      "id": patientEncounterData!.id,
      "date": encounterDateCont.text,
      "patient_id": widget.patientId,
      "description": encounterDescriptionCont.text,
      "status": "1",
    };

    if (isDoctor()) {
      if (isProEnabled()) {
        request.putIfAbsent("clinic_id", () => selectedClinic.clinic_id.validate());
      } else {
        request.putIfAbsent("clinic_id", () => getIntAsync(USER_CLINIC));
      }
    }

    if (isReceptionist()) {
      request.putIfAbsent("clinic_id", () => getIntAsync(USER_CLINIC));
      request.putIfAbsent("doctor_id", () => selectedDoctor.iD);
    }

    addEncounterData(request).then((value) {
      toast(locale.lblEncounterUpdated);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  void datePicker() async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: current,
      locale: Locale(appStore.selectedLanguage),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: appStore.isDarkModeOn
              ? ThemeData.dark()
              : ThemeData.light().copyWith(
                  primaryColor: Color(0xFF4974dc),
                  hintColor: const Color(0xFF4974dc),
                  colorScheme: ColorScheme.light(primary: const Color(0xFF4974dc)),
                ),
          child: child!,
        );
      },
    );
    if (dateTime != null) {
      encounterDateCont.text = dateTime.getFormattedDate(APPOINTMENT_DATE_FORMAT);
      current = dateTime;
      setState(() {});
    }
  }

  Widget buildBodyWidget() {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AnimatedScrollView(
        padding: EdgeInsets.all(16),
        children: [
          if (isProEnabled())
            RoleWidget(
              isShowDoctor: true,
              child: ClinicDropDown(
                clinicId: clinicId,
                isValidate: true,
                onSelected: (Clinic? value) {
                  selectedClinic = value!;
                  setState(() {});
                },
              ),
            ),
          if (!isDoctor()) 16.height,
          RoleWidget(
            isShowReceptionist: true,
            isShowPatient: true,
            child: DoctorDropDown(
              isValidate: true,
              onSelected: (DoctorList? e) {
                selectedDoctor = e!;
                setState(() {});
              },
            ),
          ),
          16.height,
          AppTextField(
            onTap: datePicker,
            controller: encounterDateCont,
            readOnly: true,
            textFieldType: TextFieldType.NAME,
            suffix: Icon(Icons.date_range),
            decoration: inputDecoration(context: context, labelText: locale.lblDate),
          ),
          16.height,
          AppTextField(
            controller: encounterDescriptionCont,
            textFieldType: TextFieldType.MULTILINE,
            maxLines: 14,
            textAlign: TextAlign.start,
            minLines: 5,
            decoration: inputDecoration(context: context, labelText: locale.lblDescription),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? locale.lblEditEncounterDetail : locale.lblAddNewEncounter,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            showConfirmDialogCustom(
              context,
              dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
              primaryColor: context.primaryColor,
              title: "Are you sure you want to submit the form?",
              onAccept: (p0) {
                isUpdate ? updateEncounter() : saveEncounter();
              },
            );
          }
        },
      ),
    );
  }
}
