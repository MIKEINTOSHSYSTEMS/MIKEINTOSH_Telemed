import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/role_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/encounter_model.dart';
import 'package:momona_healthcare/network/encounter_repository.dart';
import 'package:momona_healthcare/network/prescription_repository.dart';
import 'package:momona_healthcare/network/report_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/add_prescription_screen.dart';
import 'package:momona_healthcare/screens/doctor/screens/add_report_screen.dart';
import 'package:momona_healthcare/screens/encounter/component/encounter_type_list_component.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/enums.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:nb_utils/nb_utils.dart';

class EncounterExpandableView extends StatefulWidget {
  final String encounterType;
  final EncounterModel encounterData;
  final VoidCallback? callForRefresh;

  EncounterExpandableView({
    required this.encounterType,
    required this.encounterData,
    this.callForRefresh,
    Key? key,
  }) : super(key: key);

  @override
  _EncounterExpandableViewState createState() => _EncounterExpandableViewState();
}

class _EncounterExpandableViewState extends State<EncounterExpandableView> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController descriptionCont = TextEditingController();

  bool showAdd = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    descriptionCont.clear();
  }

  void saveDetails() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      Map request = {
        "encounter_id": "${widget.encounterData.encounterId}",
        "type": "${widget.encounterType.toLowerCase()}",
        "title": descriptionCont.text.trim(),
      };
      hideKeyboard(context);

      await saveMedicalHistoryData(request).then((value) {
        showAdd = !showAdd;
        appStore.setLoading(false);
        descriptionCont.clear();
        widget.callForRefresh?.call();
        setState(() {});
        toast(locale.lblMedicalHistoryHasBeen + " ${locale.lblAddedSuccessfully}");
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  Future<void> callForDelete({required EncounterTypeEnum encounterTypeEnum, required int id}) async {
    hideKeyboard(context);
    Map request = {
      "id": "$id",
    };
    appStore.setLoading(true);
    switch (encounterTypeEnum) {
      case EncounterTypeEnum.REPORTS:
        await deleteReportAPI(request).then((value) {
          widget.callForRefresh?.call();
          toast(locale.lblReport + ' ' + locale.lblDeletedSuccessfully);
        }).catchError((e) {
          toast(e.toString());
        });
        break;
      case EncounterTypeEnum.PRESCRIPTIONS:
        await deletePrescriptionDataAPI(request).then((value) {
          widget.callForRefresh?.call();
          appStore.setLoading(false);
          toast(locale.lblPrescriptionDeleted);
        }).catchError((e) {
          toast(e.toString());
        });
        break;
      case EncounterTypeEnum.OTHERS:
        await deleteMedicalHistoryData(request).then((value) {
          widget.callForRefresh?.call();
          appStore.setLoading(false);
          toast(locale.lblMedicalHistoryHasBeen + " " + locale.lblDeletedSuccessfully);
        }).catchError((e) {
          toast(e.toString());
        });
        break;
    }
  }

  void deleteDetails({required int id, required EncounterTypeEnum encounterTypeEnum}) async {
    callForDelete(encounterTypeEnum: encounterTypeEnum, id: id);
  }

  Future<void> _handleSendEmailPrescriptionData() async {
    appStore.setLoading(true);
    await sendPrescriptionMailAPI(encounterId: widget.encounterData.encounterId.validate().toInt()).then((value) {
      appStore.setLoading(false);
      toast(value.message.toString());
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
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
  void didUpdateWidget(covariant EncounterExpandableView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  bool get showAddPrescription {
    return isVisible(SharedPreferenceKey.kiviCarePrescriptionAddKey) && widget.encounterData.status.getBoolInt();
  }

  bool get showAddReport {
    return isVisible(SharedPreferenceKey.kiviCarePatientReportAddKey) && widget.encounterData.status.getBoolInt();
  }

  bool get showAddOtherType {
    return isVisible(SharedPreferenceKey.kiviCareMedicalRecordsAddKey) && widget.encounterData.status.getBoolInt();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      children: [
        EncounterTypeList(
          encounterType: widget.encounterType,
          encounterData: widget.encounterData,
          callDelete: callForDelete,
          refreshCall: () {
            widget.callForRefresh?.call();
          },
        ),
        if (widget.encounterData.status == '1')
          RoleWidget(
            isShowDoctor: true,
            isShowReceptionist: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.encounterType == PRESCRIPTION && widget.encounterData.prescription.validate().isNotEmpty)
                  TextButton(onPressed: _handleSendEmailPrescriptionData, child: Text(locale.lblSendPrescriptionOnMail, style: primaryTextStyle(color: Colors.green))),
                if (widget.encounterType == PRESCRIPTION && showAddPrescription)
                  Icon(
                    showAdd ? Icons.remove : Icons.add,
                    color: showAdd ? Colors.red : primaryColor,
                  ).appOnTap(
                    () {
                      if (showAdd) {
                        hideKeyboard(context);
                        descriptionCont.clear();
                      }
                      if (!showAdd && widget.encounterType == PRESCRIPTION)
                        AddPrescriptionScreen(encounterId: widget.encounterData.encounterId.toInt()).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                          if (value ?? false) {
                            showAdd = !showAdd;
                            setState(() {});
                            widget.callForRefresh?.call();
                          } else {
                            setState(() {
                              showAdd = !showAdd;
                            });
                          }
                        });

                      showAdd = !showAdd;
                      setState(() {});
                    },
                  ),
                if (widget.encounterType == REPORT && showAddReport)
                  Icon(
                    showAdd ? Icons.remove : Icons.add,
                    color: showAdd ? Colors.red : primaryColor,
                  ).appOnTap(
                    () {
                      if (showAdd) {
                        hideKeyboard(context);
                        descriptionCont.clear();
                      }

                      if (!showAdd && widget.encounterType == REPORT)
                        AddReportScreen(patientId: widget.encounterData.patientId.toInt()).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                          if (value ?? false) {
                            showAdd = !showAdd;
                            setState(() {});
                            widget.callForRefresh?.call();
                          } else {
                            setState(() {
                              showAdd = !showAdd;
                            });
                          }
                        });

                      showAdd = !showAdd;
                      setState(() {});
                    },
                  ),
              ],
            ).paddingOnly(top: 4, bottom: 16, right: 8),
          ),
        if ((widget.encounterType == PROBLEM || widget.encounterType == OBSERVATION || widget.encounterType == NOTE) && showAddOtherType)
          Form(
            key: formKey,
            child: AppTextField(
              controller: descriptionCont,
              textFieldType: TextFieldType.MULTILINE,
              minLines: 1,
              maxLines: 5,
              autoFocus: false,
              errorThisFieldRequired: locale.lblFieldIsRequired,
              decoration: inputDecoration(context: context, labelText: locale.lblEnter + ' ${widget.encounterType}').copyWith(filled: true, fillColor: context.scaffoldBackgroundColor),
              keyboardType: TextInputType.multiline,
              suffix: IconButton(
                icon: Icon(Icons.send),
                onPressed: saveDetails,
              ),
            ).paddingOnly(right: 4, bottom: 16, left: 4),
          ),
      ],
    );
  }
}
