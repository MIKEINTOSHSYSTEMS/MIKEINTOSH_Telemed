import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/components/common_row_widget.dart';
import 'package:kivicare_flutter/components/side_date_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/patient_encounter_list_model.dart';
import 'package:kivicare_flutter/network/encounter_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/encounter_dashboard_screen.dart';
import 'package:kivicare_flutter/screens/patient/screens/patient_encounter_dashboard_screen.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class EncounterWidget extends StatelessWidget {
  final PatientEncounterData data;

  EncounterWidget({required this.data});

  Widget buildPopupMenuWidget({required BuildContext context}) {
    return PopupMenuButton(
      onSelected: (value) async {
        if (value == 0) {
          if (isPatient()) {
            PatientEncounterDashboardScreen(id: data.id.toInt()).launch(context);
          } else {
            EncounterDashboardScreen(id: data.id, name: data.patient_name).launch(context);
          }
        } else if (value == 1) {
          showConfirmDialogCustom(
            context,
            dialogType: DialogType.DELETE,
            title: locale.lblDeleteRecordConfirmation + " ${data.clinic_name.validate()}?",
            onAccept: (p0) async {
              Map<String, dynamic> request = {"patient_id": data.id};

              appStore.setLoading(true);

              await deletePatientData(request).then((value) {
                toast(locale.lblAllRecordsFor + " ${data.clinic_name.validate()} " + locale.lblAreDeleted);
              }).catchError((e) {
                toast(e.toString());
              });

              appStore.setLoading(false);
            },
          );
        }
      },
      child: Icon(Icons.more_vert_outlined, size: 20),
      itemBuilder: (BuildContext context) {
        List<PopupMenuItem> list = [];

        list.add(
          PopupMenuItem(
            value: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FaIcon(FontAwesomeIcons.gaugeHigh, size: 16).withWidth(20),
                6.width,
                Text(locale.lblDashboard, style: primaryTextStyle(size: 14)),
              ],
            ),
          ),
        );
        list.add(
          PopupMenuItem(
            value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FaIcon(FontAwesomeIcons.trash, size: 16, color: Colors.red).withWidth(20),
                6.width,
                Text(locale.lblDelete, style: primaryTextStyle(size: 14, color: Colors.red)),
              ],
            ),
          ),
        );
        return list;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SideDateWidget(tempDate: DateFormat(CONVERT_DATE).parse(data.encounter_date.validate())),
          Container(
            height: 60,
            child: VerticalDivider(
              color: Colors.grey.withOpacity(0.5),
              width: 25,
              thickness: 1,
              indent: 4,
              endIndent: 1,
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${data.clinic_name.validate()}", style: boldTextStyle()).expand(),
                  16.width,
                  buildPopupMenuWidget(context: context),
                ],
              ),
              4.height,
              CommonRowWidget(title: locale.lblDoctor, value: data.doctor_name.validate(), valueColor: primaryColor, valueSize: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(locale.lblDescription + ': ', style: secondaryTextStyle()),
                      4.width,
                      Text(
                        data.description.validate(value: 'N/A').trim(),
                        style: boldTextStyle(size: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ).expand(),
                    ],
                  ).expand(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: boxDecorationDefault(color: getEncounterStatusColor(data.status).withOpacity(0.2), borderRadius: radius()),
                    child: Text("${getEncounterStatus(data.status)}".toUpperCase(), style: boldTextStyle(size: 10, color: getEncounterStatusColor(data.status), letterSpacing: 1)),
                  )
                ],
              ),
            ],
          ).expand()
        ],
      ),
    );
  }
}
