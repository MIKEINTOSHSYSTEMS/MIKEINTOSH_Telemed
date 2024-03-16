import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momona_healthcare/components/image_border_component.dart';
import 'package:momona_healthcare/components/status_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/screens/encounter/screen/patient_encounter_list_screen.dart';
import 'package:momona_healthcare/screens/receptionist/screens/patient/add_patient_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientListComponent extends StatefulWidget {
  final UserModel? patientData;
  final VoidCallback? refreshCall;
  final Function(int, String)? callDeletePatient;

  PatientListComponent({required this.patientData, this.refreshCall, this.callDeletePatient});

  @override
  _PatientListComponentState createState() => _PatientListComponentState();
}

class _PatientListComponentState extends State<PatientListComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  bool get showEdit {
    return isVisible(SharedPreferenceKey.kiviCarePatientEditKey);
  }

  bool get showDelete {
    return isVisible(SharedPreferenceKey.kiviCarePatientDeleteKey);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Slidable(
        key: ValueKey(widget.patientData!),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            if (showEdit)
              SlidableAction(
                onPressed: (BuildContext context) async {
                  await AddPatientScreen(userId: widget.patientData!.iD).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                    if (value ?? false) {
                      widget.refreshCall?.call();
                    }
                  });
                },
                flex: 2,
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,

                ///Todo remove NOT when delete is implemented
                borderRadius: !showDelete ? BorderRadius.only(topLeft: Radius.circular(defaultRadius), bottomLeft: Radius.circular(defaultRadius)) : BorderRadius.all(Radius.circular(defaultRadius)),
                icon: Icons.edit,
                label: locale.lblEdit,
              ),

            ///Todo has to be implement when dashboard flow will be changed
            /*SlidableAction(
                flex: 2,
                borderRadius: BorderRadius.only(topRight: Radius.circular(defaultRadius), bottomRight: Radius.circular(defaultRadius)),
                onPressed: (BuildContext context) async {
                  showConfirmDialogCustom(
                    context,
                    dialogType: DialogType.DELETE,
                    title: locale.lblDeleteRecordConfirmation + " ${widget.patientData!.displayName}?",
                    onAccept: (p0) {
                      widget.callDeletePatient?.call(widget.patientData!.iD.validate(), widget.patientData!.displayName.validate());
                    },
                  );
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: locale.lblDelete,
              ).visible(showDelete),*/
          ],
        ),
        child: Container(
          padding: EdgeInsets.only(left: 8, top: 10, bottom: 10, right: 8),
          decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageBorder(
                    src: widget.patientData!.profileImage.validate(),
                    height: 40,
                    nameInitial: widget.patientData!.displayName.validate()[0],
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.patientData!.displayName.validate().capitalizeEachWord(), style: boldTextStyle(size: 16), maxLines: 2),
                      8.height,
                      if (widget.patientData!.mobileNumber.validate().isNotEmpty)
                        TextIcon(
                          prefix: ic_phone.iconImage(size: 16),
                          spacing: 8,
                          text: widget.patientData!.mobileNumber.validate(),
                          edgeInsets: EdgeInsets.all(0),
                          textStyle: primaryTextStyle(size: 16),
                          onTap: () => launchCall(widget.patientData!.mobileNumber.validate()),
                        ),
                      4.height,
                      Row(
                        children: [
                          if (widget.patientData!.gender.validate().isNotEmpty)
                            TextIcon(
                              spacing: 8,
                              prefix: ic_user.iconImage(size: 16),
                              text: widget.patientData!.gender.validate(),
                              textStyle: primaryTextStyle(size: 16),
                              edgeInsets: EdgeInsets.all(0),
                            ).expand(),
                          16.width,
                          if (!widget.patientData!.bloodGroup.isEmptyOrNull)
                            TextIcon(
                              spacing: 8,
                              prefix: ic_blood_group.iconImage(size: 16),
                              text: widget.patientData!.bloodGroup.validate(),
                              textStyle: primaryTextStyle(size: 16),
                              edgeInsets: EdgeInsets.all(0),
                            ).expand(),
                        ],
                      ),
                      4.height,
                      TextIcon(
                        spacing: 8,
                        prefix: ic_appointment.iconImage(size: 14),
                        text: widget.patientData!.totalEncounter != '0'
                            ? widget.patientData!.totalEncounter.validate().prefixText(value: locale.lblTotal + ' ').suffixText(value: ' ' + locale.lblEncounter)
                            : locale.lblNoEncounterFound.capitalizeEachWord(),
                        textStyle: primaryTextStyle(size: 16),
                        edgeInsets: EdgeInsets.all(0),
                      ),
                      2.height,
                    ],
                  ).expand(),
                  16.width,
                ],
              ),
              Positioned(
                top: 4,
                right: isRTL ? null : 6,
                left: !isRTL ? null : 6,
                bottom: -4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusWidget(status: widget.patientData!.userStatus.validate(), isActivityStatus: true),
                    if (isVisible(SharedPreferenceKey.kiviCarePatientEncounterListKey))
                      FaIcon(FontAwesomeIcons.gaugeHigh, size: 20, color: appSecondaryColor).paddingAll(8).appOnTap(
                        () {
                          return PatientEncounterListScreen(patientData: widget.patientData!).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                            if (value ?? false) widget.refreshCall?.call();
                          });
                        },
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ).paddingSymmetric(vertical: 8);
    });
  }
}
