import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/common/encounter_item_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/medical_history_model.dart';
import 'package:kivicare_flutter/network/encounter_repository.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class EncounterListWidget extends StatefulWidget {
  final String? encounterType;
  final int? id;
  final String? paymentStatus;

  EncounterListWidget({this.encounterType, this.id, this.paymentStatus});

  @override
  _EncounterListWidgetState createState() => _EncounterListWidgetState();
}

class _EncounterListWidgetState extends State<EncounterListWidget> {
  GlobalKey<FormState> formKey = GlobalKey();

  AsyncMemoizer<MedicalHistoryModel> _memorizer = AsyncMemoizer();

  TextEditingController textCont = TextEditingController();

  bool isInteractionOn = false;

  List<EncounterType>? encounterTypeList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    textCont.clear();
  }

  void saveDetails() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      Map request = {
        "encounter_id": "${widget.id}",
        "type": "${widget.encounterType}",
        "title": textCont.text.trim(),
      };

      await saveMedicalHistoryData(request).then((value) {
        encounterTypeList!.add(value);
        textCont.clear();
        getMedicalHistoryResponse(widget.id.validate(), widget.encounterType!.toLowerCase());
        toast("${widget.encounterType.capitalizeFirstLetter() + locale.lblAdded}");
      }).catchError((e) {
        toast(e.toString());
      });

      appStore.setLoading(false);
    }
  }

  void deleteDetails(int id, int index) async {
    appStore.setLoading(true);

    Map request = {
      "id": "$id",
    };

    await deleteMedicalHistoryData(request).then((value) {
      textCont.clear();
      encounterTypeList!.removeAt(index);
      isInteractionOn = false;
      getMedicalHistoryResponse(widget.id.validate(), widget.encounterType!.toLowerCase());
      toast("${widget.encounterType} " + locale.lblAllRecordsDeleted);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
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
    return Body(
      child: Stack(
        children: [
          FutureBuilder<MedicalHistoryModel>(
            future: _memorizer.runOnce(() => getMedicalHistoryResponse(widget.id.validate(), widget.encounterType!.toLowerCase())),
            builder: (context, snap) {
              if (snap.hasData) {
                encounterTypeList = snap.data!.encounterType;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.encounterType.capitalizeFirstLetter()}s (${encounterTypeList!.length})", style: boldTextStyle()),
                      16.height,
                      ListView.separated(
                        itemCount: encounterTypeList!.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          EncounterType data = encounterTypeList![index];

                          return EncounterItemWidget(
                            data: data,
                            onTap: () {
                              showConfirmDialogCustom(
                                context,
                                title: 'Are you sure you want to delete the problem?',
                                dialogType: DialogType.DELETE,
                                onAccept: (p0) {
                                  deleteDetails(data.id.toInt(), index);
                                },
                              );
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(color: viewLineColor);
                        },
                      ),
                    ],
                  ),
                );
              }
              return snapWidgetHelper(
                snap,
                errorWidget: NoDataFoundWidget(text: errorMessage),
                loadingWidget: LoaderWidget(),
              );
            },
          ).paddingBottom(60),
          Observer(
            builder: (context) {
              return NoDataFoundWidget(
                text: "No ${widget.encounterType} founds ",
                iconSize: 130,
              ).center().visible(appStore.isLoading || encounterTypeList.validate().isEmpty);
            },
          ),
          !isPatient() && widget.paymentStatus != 'paid'
              ? Positioned(
                  bottom: 16,
                  right: 16,
                  left: 16,
                  child: Form(
                    key: formKey,
                    child: SizedBox(
                      width: context.width() - 35,
                      child: AppTextField(
                        controller: textCont,
                        textFieldType: TextFieldType.NAME,
                        minLines: 1,
                        maxLines: 5,
                        autoFocus: false,
                        errorThisFieldRequired: "${widget.encounterType.capitalizeFirstLetter()} " + locale.lblFieldIsRequired,
                        decoration: inputDecoration(context: context, labelText: locale.lblEnter + ' ${widget.encounterType}'),
                        keyboardType: TextInputType.multiline,
                        suffix: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            saveDetails();
                          },
                        ),
                      ),
                    ),
                  ),
                )
              : 0.height,
          LoaderWidget().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
