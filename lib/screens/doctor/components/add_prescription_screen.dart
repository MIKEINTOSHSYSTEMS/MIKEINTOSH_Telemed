import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/prescription_model.dart';
import 'package:kivicare_flutter/network/prescription_repository.dart';
import 'package:kivicare_flutter/screens/doctor/components/selection_with_search_widget.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class AddPrescriptionScreen extends StatefulWidget {
  final String? text;
  final String? name;
  final int? id;
  final int? pID;
  PrescriptionData? prescriptionData;

  AddPrescriptionScreen({this.text, this.name, this.id, this.pID, this.prescriptionData});

  @override
  _AddPrescriptionScreenState createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  AsyncMemoizer<PrescriptionModel> _memorizer = AsyncMemoizer();

  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController prescriptionNameCont = TextEditingController();
  TextEditingController prescriptionFrequencyCont = TextEditingController();
  TextEditingController prescriptionDurationCont = TextEditingController();
  TextEditingController prescriptionInstructionCont = TextEditingController();

  FocusNode prescriptionNameFocus = FocusNode();
  FocusNode prescriptionFrequencyFocus = FocusNode();
  FocusNode prescriptionDurationFocus = FocusNode();
  FocusNode prescriptionInstructionFocus = FocusNode();

  List<String> pName = [];
  List<String> pFrequency = [];

  bool isUpdate = false;

  PrescriptionData? prescriptionData;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isUpdate = widget.prescriptionData != null;
    if (isUpdate) {
      prescriptionData = widget.prescriptionData;
      prescriptionNameCont.text = prescriptionData!.name.validate();
      prescriptionFrequencyCont.text = prescriptionData!.frequency.validate();
      prescriptionDurationCont.text = prescriptionData!.duration.validate();
      prescriptionInstructionCont.text = prescriptionData!.instruction.validate();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void savePrescriptionDetails() async {
    appStore.setLoading(true);

    Map request = {
      "encounter_id": widget.id,
      "name": prescriptionNameCont.text.validate(),
      "frequency": prescriptionFrequencyCont.text.validate(),
      "duration": prescriptionDurationCont.text.validate(),
      "instruction": prescriptionInstructionCont.text.validate(),
    };

    await savePrescriptionData(request).then((value) {
      toast(locale.lblPrescriptionAdded);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  void updatePrescriptionDetails() async {
    appStore.setLoading(true);

    Map request = {
      "id": widget.pID.validate(),
      "encounter_id": widget.id.validate(),
      "name": prescriptionNameCont.text.validate(),
      "frequency": prescriptionFrequencyCont.text.validate(),
      "duration": prescriptionDurationCont.text.validate(),
      "instruction": prescriptionInstructionCont.text.validate(),
    };

    await savePrescriptionData(request).then((value) {
      toast(locale.lblUpdatedSuccessfully);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  void deletePrescriptionDetails() async {
    appStore.setLoading(true);

    Map request = {
      "id": prescriptionData!.id,
    };

    await deletePrescriptionData(request).then((value) {
      toast(locale.lblPrescriptionDeleted);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body() {
      return FutureBuilder<PrescriptionModel>(
        future: _memorizer.runOnce(() => getPrescriptionResponse("")),
        builder: (context, snap) {
          if (snap.hasData) {
            if (pName.isEmpty) {
              log(snap.data!.prescriptionData.validate().map((e) => e.name.capitalizeFirstLetter()).toList().length);
              pName = snap.data!.prescriptionData.validate().map((e) => e.name.capitalizeFirstLetter()).toList();
            }
            if (pFrequency.isEmpty) {
              pFrequency = snap.data!.prescriptionData.validate().map((e) => e.frequency.capitalizeFirstLetter()).toList();
            }
            return Form(
              key: formKey,
              child: AnimatedScrollView(
                padding: EdgeInsets.all(16),
                children: [
                  Text(locale.lblAddPrescription, style: boldTextStyle(size: 18)),
                  16.height,
                  Column(
                    children: [
                      AppTextField(
                        controller: prescriptionNameCont,
                        focus: this.prescriptionNameFocus,
                        nextFocus: prescriptionFrequencyFocus,
                        textFieldType: TextFieldType.OTHER,
                        validator: (s) {
                          if (s!.trim().isEmpty) return locale.lblPrescriptionRequired;
                          return null;
                        },
                        decoration: inputDecoration(context: context, labelText: locale.lblName),
                        readOnly: true,
                        onTap: () async {
                          String? name = await showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            enableDrag: true,
                            isScrollControlled: true,
                            builder: (context) {
                              return SelectionWithSearchWidget(searchList: pName, name: locale.lblPrescription);
                            },
                          );
                          if (name == null) {
                            prescriptionNameCont.clear();
                          } else {
                            prescriptionNameCont.text = name;
                          }
                        },
                      ),
                      16.height,
                      AppTextField(
                        controller: prescriptionFrequencyCont,
                        focus: prescriptionFrequencyFocus,
                        nextFocus: prescriptionDurationFocus,
                        textFieldType: TextFieldType.OTHER,
                        decoration: inputDecoration(context: context, labelText: locale.lblFrequency),
                        readOnly: true,
                        validator: (s) {
                          if (s!.trim().isEmpty) return locale.lblPrescriptionFrequencyIsRequired;
                          return null;
                        },
                        onTap: () async {
                          String? name = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            enableDrag: true,
                            isDismissible: true,
                            builder: (context) {
                              return SelectionWithSearchWidget(searchList: pFrequency, name: locale.lblFrequency);
                            },
                          );
                          if (name == null) {
                            prescriptionFrequencyCont.clear();
                          } else {
                            prescriptionFrequencyCont.text = name;
                          }
                        },
                      ),
                    ],
                  ),
                  16.height,
                  AppTextField(
                    controller: prescriptionDurationCont,
                    focus: prescriptionDurationFocus,
                    nextFocus: prescriptionInstructionFocus,
                    textFieldType: TextFieldType.OTHER,
                    keyboardType: TextInputType.number,
                    validator: (s) {
                      if (s!.trim().isEmpty) return locale.lblPrescriptionDurationIsRequired;
                      return null;
                    },
                    decoration: inputDecoration(context: context, labelText: locale.lblDurationInDays),
                  ),
                  16.height,
                  AppTextField(
                    controller: prescriptionInstructionCont,
                    focus: prescriptionInstructionFocus,
                    minLines: 5,
                    maxLines: 10,
                    textInputAction: TextInputAction.done,
                    textFieldType: TextFieldType.OTHER,
                    decoration: inputDecoration(context: context, labelText: locale.lblInstruction),
                  ),
                ],
              ),
            );
          }
          return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget());
        },
      );
    }

    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? locale.lblEditPrescriptionDetail : locale.lblAddNewPrescription,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        textColor: Colors.white,
        actions: [
          if (isUpdate)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                showConfirmDialogCustom(
                  context,
                  title: locale.lblAreYouSure,
                  dialogType: DialogType.DELETE,
                  onAccept: (p0) {
                    deletePrescriptionDetails();
                  },
                );
              },
            ),
        ],
      ),
      body: Body(child: body()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            showConfirmDialogCustom(
              context,
              dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
              title: 'Are you sure you want to submit the form?',
              onAccept: (p0) {
                isUpdate ? updatePrescriptionDetails() : savePrescriptionDetails();
              },
            );
          }
        },
      ),
    );
  }
}
