import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momona_healthcare/components/side_date_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/patient_encounter_list_model.dart';
import 'package:momona_healthcare/model/patient_list_model.dart';
import 'package:momona_healthcare/network/encounter_repository.dart';
import 'package:momona_healthcare/screens/doctor/screens/add_encounter_screen.dart';
import 'package:momona_healthcare/screens/doctor/screens/encounter_dashboard_screen.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientEncounterListComponent extends StatefulWidget {
  final PatientData? patientData;
  final PatientEncounterData? data;
  final DateTime? tempDate;

  PatientEncounterListComponent({required this.data, this.tempDate, this.patientData});

  @override
  _PatientEncounterListComponentState createState() => _PatientEncounterListComponentState();
}

class _PatientEncounterListComponentState extends State<PatientEncounterListComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.data!),
      child: Container(
        decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SideDateWidget(tempDate: widget.tempDate!),
            Container(
              height: 60,
              child: VerticalDivider(color: Colors.grey.withOpacity(0.5), width: 25, thickness: 1, indent: 4, endIndent: 1),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.data!.clinic_name.validate(), style: boldTextStyle(size: 18), maxLines: 2).flexible(),
                    FaIcon(
                      FontAwesomeIcons.tachometerAlt,
                      size: 20,
                      color: appSecondaryColor,
                    ).paddingAll(8).onTap(
                      () {
                        EncounterDashboardScreen(id: widget.data!.id, name: widget.data!.patient_name).launch(context);
                      },
                    )
                  ],
                ),
                8.height,
                Row(
                  children: [
                    Text(locale.lblDoctor + ': ', style: secondaryTextStyle(size: 16)),
                    4.width,
                    Text(widget.data!.doctor_name.validate(), style: boldTextStyle(size: 16), maxLines: 2).flexible(),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locale.lblDescription + ': ', style: secondaryTextStyle(size: 16)),
                        4.width,
                        Text(widget.data!.description.validate().trim(), style: boldTextStyle(size: 16), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                      ],
                    ).expand(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: boxDecorationDefault(borderRadius: radius(), color: getEncounterStatusColor(widget.data!.status).withOpacity(0.2)),
                      child: Text(
                        "${getEncounterStatus(widget.data!.status)}".toUpperCase(),
                        style: boldTextStyle(size: 10, color: getEncounterStatusColor(widget.data!.status)),
                      ),
                    )
                  ],
                ),
              ],
            ).expand(),
          ],
        ),
      ),
      //Add New Code
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) async {
              bool? res = await AddEncounterScreen(
                patientEncounterData: widget.data!,
                patientId: widget.patientData!.iD,
              ).launch(context);
              if (res ?? false) {
                setState(() {});
              }
            },
            flex: 1,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), bottomLeft: Radius.circular(defaultRadius)),
            icon: Icons.edit,
            label: locale.lblEdit,
          ),
          SlidableAction(
            flex: 1,
            borderRadius: BorderRadius.only(topRight: Radius.circular(defaultRadius), bottomRight: Radius.circular(defaultRadius)),
            onPressed: (BuildContext context) async {
              showConfirmDialogCustom(
                context,
                dialogType: DialogType.DELETE,
                title: '${locale.lblDeleteRecordConfirmation} ${widget.data!.clinic_name.validate()}',
                onAccept: (p0) {
                  Map request = {
                    "encounter_id": widget.data!.id,
                  };

                  appStore.setLoading(true);

                  deleteEncounterData(request).then((value) {
                    appStore.setLoading(false);
                    toast(" ${locale.lblAllRecordsFor} ${widget.data!.patient_name.validate()} ${locale.lblAreDeleted}");
                    init();
                    setState(() {});
                  }).catchError((e) {
                    appStore.setLoading(false);
                    toast(e.toString());
                  });
                },
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: locale.lblDelete,
          ),
        ],
      ),
    );
  }
}
