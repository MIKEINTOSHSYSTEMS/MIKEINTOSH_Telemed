import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/components/status_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/encounter_model.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/network/encounter_repository.dart';
import 'package:momona_healthcare/screens/encounter/screen/add_encounter_screen.dart';
import 'package:momona_healthcare/screens/encounter/screen/encounter_dashboard_screen.dart';
import 'package:momona_healthcare/screens/encounter/screen/patient_encounter_dashboard_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:nb_utils/nb_utils.dart';

class EncounterListComponent extends StatefulWidget {
  final UserModel? patientData;
  final EncounterModel data;
  final VoidCallback? refreshCall;

  EncounterListComponent({required this.data, this.patientData, this.refreshCall});

  @override
  _EncounterListComponentState createState() => _EncounterListComponentState();
}

class _EncounterListComponentState extends State<EncounterListComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  bool get isEdit {
    return isVisible(SharedPreferenceKey.kiviCarePatientEncounterEditKey);
  }

  bool get isDelete {
    return isVisible(SharedPreferenceKey.kiviCarePatientEncounterDeleteKey);
  }

  bool get showEncounter {
    return isVisible(SharedPreferenceKey.kiviCarePatientEncounterViewKey);
  }

  void _handleDeleteAction() {
    showConfirmDialogCustom(
      context,
      dialogType: DialogType.DELETE,
      title: locale.lblDoYouWantToDeleteEncounterDetailsOf,
      onAccept: (p0) {
        Map request = {
          "encounter_id": widget.data.encounterId.validate(),
        };

        appStore.setLoading(true);

        deleteEncounterData(request).then((value) {
          widget.refreshCall?.call();
          appStore.setLoading(false);
          toast(value['message']);
        });
      },
    );
  }

  void _handleEditAction() async {
    await AddEncounterScreen(
      patientEncounterData: widget.data,
      patientId: widget.patientData!.iD,
    ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
      if (value ?? false) widget.refreshCall?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: isEdit || isDelete,
      key: ValueKey(widget.data),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          if (isEdit)
            SlidableAction(
              flex: 1,
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), bottomLeft: Radius.circular(defaultRadius)),
              icon: Icons.edit,
              label: locale.lblEdit,
              onPressed: (BuildContext context) async {
                if ((DateFormat(GLOBAL_FORMAT).parse(widget.data.encounterDate.validate()).difference(DateFormat(SAVE_DATE_FORMAT).parse(DateTime.now().toString())).inDays > 0 ||
                    DateFormat(SAVE_DATE_FORMAT).parse(DateTime.now().toString()) == DateFormat(GLOBAL_FORMAT).parse(widget.data.encounterDate.validate())))
                  _handleEditAction();
                else
                  toast(locale.lblEditHolidayRestriction);
              },
            ),
          if (isDelete)
            SlidableAction(
              flex: 1,
              borderRadius: BorderRadius.only(topRight: Radius.circular(defaultRadius), bottomRight: Radius.circular(defaultRadius)),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: locale.lblDelete,
              onPressed: (BuildContext context) async {
                _handleDeleteAction();
              },
            ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: showEncounter ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isReceptionist())
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data.clinicName.validate(), style: boldTextStyle(size: 18), maxLines: 2).flexible(),
                    ],
                  ),
                if (!isDoctor())
                  RichTextWidget(
                    list: [
                      if (isPatient()) TextSpan(text: locale.lblDoctor.validate().suffixText(value: ' : '), style: secondaryTextStyle(size: 14)),
                      TextSpan(text: widget.data.doctorName.validate().capitalizeEachWord().prefixText(value: 'Dr. '), style: boldTextStyle(size: isPatient() ? 16 : 18)),
                    ],
                  ),
                4.height,
                RichTextWidget(
                  list: [
                    TextSpan(text: locale.lblDate.suffixText(value: " : "), spellOut: true, style: secondaryTextStyle(size: 14)),
                    TextSpan(text: widget.data.encounterDate.validate(), style: primaryTextStyle(size: 14)),
                  ],
                ),
                if (widget.data.description.validate().isNotEmpty) 4.height,
                if (widget.data.description.validate().isNotEmpty)
                  RichTextWidget(
                    list: [
                      TextSpan(text: locale.lblDescription.suffixText(value: " : "), spellOut: true, style: secondaryTextStyle(size: 14)),
                      TextSpan(text: widget.data.description.validate(value: locale.lblNA), style: primaryTextStyle(size: 14)),
                    ],
                  )
              ],
            ).expand(flex: 3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showEncounter)
                  FaIcon(
                    FontAwesomeIcons.gaugeHigh,
                    size: 20,
                    color: appSecondaryColor,
                  ).paddingAll(8).appOnTap(
                    () {
                      if (isDoctor() || isReceptionist()) {
                        EncounterDashboardScreen(encounterId: widget.data.encounterId).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                          widget.refreshCall?.call();
                        });
                      } else
                        PatientEncounterDashboardScreen(
                          id: widget.data.encounterId,
                          callBack: () {
                            widget.refreshCall?.call();
                          },
                        ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                    },
                  ),
                StatusWidget(
                  status: widget.data.status.validate(),
                  isEncounterStatus: true,
                ).paddingTop(8),
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }
}
