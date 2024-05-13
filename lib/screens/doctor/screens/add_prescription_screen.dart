import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/prescription_model.dart';
import 'package:kivicare_flutter/network/prescription_repository.dart';
import 'package:kivicare_flutter/screens/encounter/component/auto_complete_field_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class AddPrescriptionScreen extends StatefulWidget {
  final int? encounterId;
  final PrescriptionData? prescriptionData;

  AddPrescriptionScreen({this.encounterId, this.prescriptionData});

  @override
  _AddPrescriptionScreenState createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
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
  bool isFirstTime = true;

  PrescriptionData? prescriptionData;

  @override
  void initState() {
    super.initState();
    init(showLoader: true);
  }

  Future<void> init({bool showLoader = false}) async {
    isUpdate = widget.prescriptionData != null;
    if (showLoader) {
      appStore.setLoading(true);
    }
    if (isUpdate) {
      prescriptionData = widget.prescriptionData;
      prescriptionNameCont.text = prescriptionData!.name.validate();
      prescriptionFrequencyCont.text = prescriptionData!.frequency.validate();
      prescriptionDurationCont.text = prescriptionData!.duration.validate();
      prescriptionInstructionCont.text = prescriptionData!.instruction.validate();
    }
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void savePrescriptionDetails() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    Map request = {
      "encounter_id": widget.encounterId,
      "name": prescriptionNameCont.text.validate(),
      "frequency": prescriptionFrequencyCont.text.validate(),
      "duration": prescriptionDurationCont.text.validate(),
      "instruction": prescriptionInstructionCont.text.validate(),
    };

    await savePrescriptionDataAPI(request).then((value) {
      appStore.setLoading(false);
      toast(locale.lblPrescriptionAdded);
      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void updatePrescriptionDetails() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    Map request = {
      "id": widget.prescriptionData!.id.validate().validate(),
      "encounter_id": widget.encounterId.validate(),
      "name": prescriptionNameCont.text.validate(),
      "frequency": prescriptionFrequencyCont.text.validate(),
      "duration": prescriptionDurationCont.text.validate(),
      "instruction": prescriptionInstructionCont.text.validate(),
    };

    await savePrescriptionDataAPI(request).then((value) {
      appStore.setLoading(false);
      toast(locale.lblUpdatedSuccessfully);
      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void deletePrescriptionDetails() async {
    appStore.setLoading(true);

    Map request = {
      "id": prescriptionData!.id,
    };

    await deletePrescriptionDataAPI(request).then((value) {
      appStore.setLoading(false);
      toast(locale.lblPrescriptionDeleted);
      1.seconds.delay;
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
      return Stack(
        fit: StackFit.expand,
        children: [
          Form(
            key: formKey,
            child: AnimatedScrollView(
              padding: EdgeInsets.all(16),
              listAnimationType: ListAnimationType.None,
              children: [
                Text(locale.lblAddPrescription, style: boldTextStyle(size: 18)),
                16.height,
                Column(
                  children: [
                    AutoCompleteFieldScreen(
                      encounterId: widget.encounterId.validate().toString(),
                      isFrequency: false,
                      name: isUpdate ? prescriptionNameCont.text.validate() : '',
                      onTap: (value) {
                        prescriptionNameCont.text = value;
                      },
                    ),
                    16.height,
                    AutoCompleteFieldScreen(
                      name: isUpdate ? prescriptionFrequencyCont.text.validate() : '',
                      encounterId: widget.encounterId.validate().toString(),
                      isFrequency: true,
                      onTap: (value) {
                        prescriptionFrequencyCont.text = value;
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
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading).center())
        ],
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
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                showConfirmDialogCustom(
                  context,
                  title: locale.lblDoYouWantToDeletePrescription,
                  dialogType: DialogType.DELETE,
                  onAccept: (p0) {
                    deletePrescriptionDetails();
                  },
                );
              },
            ),
        ],
      ),
      body: body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            showConfirmDialogCustom(
              context,
              dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
              title: isUpdate ? locale.lblDoYouWantToUpdatePrescription : locale.lblDoYouWantToAddPrescription,
              onAccept: (p0) {
                isUpdate ? updatePrescriptionDetails() : savePrescriptionDetails();
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
