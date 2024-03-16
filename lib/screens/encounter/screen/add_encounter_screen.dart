import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/multi_select_service_component.dart';
import 'package:momona_healthcare/components/role_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/clinic_list_model.dart';
import 'package:momona_healthcare/model/encounter_model.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/network/encounter_repository.dart';
import 'package:momona_healthcare/screens/appointment/screen/patient_search_screen.dart';
import 'package:momona_healthcare/screens/appointment/screen/step1_clinic_selection_screen.dart';
import 'package:momona_healthcare/screens/appointment/screen/step2_doctor_selection_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class AddEncounterScreen extends StatefulWidget {
  final EncounterModel? patientEncounterData;
  final int? patientId;

  AddEncounterScreen({this.patientEncounterData, this.patientId});

  @override
  _AddEncounterScreenState createState() => _AddEncounterScreenState();
}

class _AddEncounterScreenState extends State<AddEncounterScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController selectedClinicNameCont = TextEditingController();
  TextEditingController selectedDoctorNameCont = TextEditingController();
  TextEditingController selectedPatientNameCont = TextEditingController();
  TextEditingController encounterDateCont = TextEditingController();
  TextEditingController encounterDescriptionCont = TextEditingController();
  TextEditingController servicesCont = TextEditingController();

  EncounterModel? patientEncounterData;

  FocusNode serviceFocus = FocusNode();

  FocusNode dateFocus = FocusNode();

  Clinic? selectedClinic;

  UserModel? selectedDoctor;

  UserModel? selectedPatient;

  DateTime current = DateTime.now();

  int? clinicId;

  bool isUpdate = false;
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.patientEncounterData != null;
    if (isUpdate) {
      patientEncounterData = widget.patientEncounterData;
      selectedPatientNameCont.text = widget.patientEncounterData!.patientName.validate();
      selectedClinicNameCont.text = widget.patientEncounterData!.clinicName.validate();
      selectedDoctorNameCont.text = widget.patientEncounterData!.doctorName.validate().prefixText(value: 'Dr. ');
      if (patientEncounterData!.encounterDate.validate().isNotEmpty) {
        current = DateFormat(SAVE_DATE_FORMAT).parse(patientEncounterData!.encounterDateGlobal.validate());
        encounterDateCont.text = current.getFormattedDate(SAVE_DATE_FORMAT);
      }

      encounterDescriptionCont.text = patientEncounterData!.description.validate();
      clinicId = patientEncounterData!.clinicId.toInt();

      setState(() {});
    }
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

  void saveEncounter() async {
    appStore.setLoading(true);

    Map request = {
      'date': encounterDateCont.text,
      "description": encounterDescriptionCont.text,
      "status": isUpdate ? widget.patientEncounterData!.status.validate() : '1',
    };

    if (isUpdate) {
      request.putIfAbsent('id', () => widget.patientEncounterData!.encounterId);
      request.putIfAbsent('patient_id', () => widget.patientEncounterData!.patientId.validate());
    } else {
      if (selectedPatient != null) request.putIfAbsent('patient_id', () => selectedPatient?.iD);
    }

    if (isDoctor()) {
      request.putIfAbsent("doctor_id", () => userStore.userId);
      if (isProEnabled()) {
        if (isUpdate) {
          request.putIfAbsent("clinic_id", () => widget.patientEncounterData!.clinicId);
        } else
          request.putIfAbsent("clinic_id", () => selectedClinic?.id);
      } else {
        request.putIfAbsent("clinic_id", () => userStore.userClinicId);
      }
    } else if (isReceptionist()) {
      request.putIfAbsent('patient_id', () => widget.patientId);
      request.putIfAbsent("clinic_id", () => userStore.userClinicId);
      request.putIfAbsent("doctor_id", () => selectedDoctor != null ? selectedDoctor?.iD : widget.patientEncounterData?.doctorId);
    }

    if (widget.patientId != null) {
      request.putIfAbsent('patient_id', () => widget.patientId);
    }

    addEncounterData(request).then((value) {
      appStore.setLoading(false);
      toast(isUpdate ? locale.lblEncounterUpdated : locale.lblAddedNewEncounter);

      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? locale.lblEditEncounterDetail : locale.lblAddNewEncounter,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
            child: AnimatedScrollView(
              padding: EdgeInsets.all(16),
              children: [
                if (isProEnabled())
                  RoleWidget(
                    isShowDoctor: true,
                    child: Column(
                      children: [
                        if (widget.patientId == null)
                          AppTextField(
                            textFieldType: TextFieldType.NAME,
                            controller: selectedPatientNameCont,
                            readOnly: true,
                            decoration: inputDecoration(context: context, labelText: isUpdate ? locale.lblPatientName : locale.lblSelectPatient),
                            onTap: () async {
                              if (!isUpdate) {
                                await PatientSearchScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                                  if (value != null) {
                                    selectedPatient = value;
                                    selectedPatientNameCont.text = selectedPatient!.userDisplayName.validate();
                                    setState(() {});
                                  }
                                });
                              } else
                                toast(locale.lblEditHolidayRestriction);
                            },
                          ),
                        16.height,
                        AppTextField(
                          controller: selectedClinicNameCont,
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          decoration: inputDecoration(context: context, labelText: isUpdate ? locale.lblClinicName : locale.lblSelectClinic),
                          onTap: () async {
                            if (!isUpdate) {
                              await Step1ClinicSelectionScreen(sessionOrEncounter: true, clinicId: isUpdate ? widget.patientEncounterData!.clinicId.toInt() : null)
                                  .launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration)
                                  .then((value) {
                                if (value != null) {
                                  selectedClinic = value!;
                                  selectedClinicNameCont.text = selectedClinic!.name.validate();
                                } else {
                                  toast('${locale.lblPlease} ${locale.lblSelectClinic}');
                                }
                                setState(() {});
                              }).catchError((e) {
                                toast(e.toString());
                              });
                            } else
                              toast(locale.lblEditHolidayRestriction);
                          },
                        ),
                      ],
                    ),
                  ),
                if (!isDoctor()) 16.height,
                RoleWidget(
                  isShowReceptionist: true,
                  isShowPatient: true,
                  child: AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: selectedDoctorNameCont,
                    decoration: inputDecoration(context: context, labelText: isUpdate ? locale.lblDoctorName : locale.lblSelectDoctor),
                    readOnly: true,
                    onTap: () {
                      if (!isUpdate) {
                        Step2DoctorSelectionScreen(doctorId: widget.patientEncounterData?.doctorId.toInt())
                            .launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration)
                            .then((value) {
                          if (value != null) {
                            selectedDoctor = value;
                            selectedDoctorNameCont.text = selectedDoctor!.displayName.validate();
                          } else {
                            toast('${locale.lblPlease} ${locale.lblSelectDoctor}');
                          }
                          setState(() {});
                        }).catchError((e) {
                          toast(e.toString());
                        });
                      }
                    },
                  ),
                ),
                16.height,
                AppTextField(
                  keyboardAppearance: appStore.isDarkModeOn ? Brightness.dark : Brightness.light,
                  selectionControls: EmptyTextSelectionControls(),
                  onTap: () {
                    if (isUpdate &&
                        DateFormat(SAVE_DATE_FORMAT).parse(widget.patientEncounterData!.encounterDateGlobal.validate()).isBefore(DateFormat(SAVE_DATE_FORMAT).parse(DateTime.now().toString()))) {
                      toast(locale.lblEditHolidayRestriction);
                    } else {
                      datePickerComponent(
                        context,
                        initialDate: current,
                        helpText: locale.lblSelectEncounterDate,
                        onDateSelected: (selectedDate) {
                          if (selectedDate != null) {
                            current = selectedDate;
                            encounterDateCont.text = current.getFormattedDate(SAVE_DATE_FORMAT);
                            setState(() {});
                          } else {
                            //
                          }
                        },
                      );
                    }
                  },
                  controller: encounterDateCont,
                  readOnly: true,
                  focus: dateFocus,
                  textFieldType: TextFieldType.NAME,
                  suffix: Icon(Icons.date_range),
                  decoration: inputDecoration(context: context, labelText: locale.lblDate),
                ),
                16.height,
                AppTextField(
                  controller: encounterDescriptionCont,
                  textFieldType: TextFieldType.MULTILINE,
                  isValidationRequired: false,
                  maxLines: 14,
                  textAlign: TextAlign.start,
                  minLines: 5,
                  decoration: inputDecoration(context: context, labelText: locale.lblDescription),
                ),
              ],
            ),
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading).center())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            showConfirmDialogCustom(
              context,
              dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
              primaryColor: context.primaryColor,
              title: isUpdate ? locale.lblDoYouWantToUpdateEncounter : locale.lblDoYouWantToAddEncounter,
              onAccept: (p0) {
                saveEncounter();
              },
            );
          } else {
            isFirstTime = !isFirstTime;
            setState(() {});
          }
        },
      ),
    );
  }
}
