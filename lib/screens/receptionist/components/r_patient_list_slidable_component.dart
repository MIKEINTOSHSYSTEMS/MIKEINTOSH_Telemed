import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/patient_list_model.dart';
import 'package:kivicare_flutter/network/encounter_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/add_patient_screen.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/encounter_screen.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class RPatientListSlidableComponent extends StatefulWidget {
  final PatientData? patientData;

  RPatientListSlidableComponent({required this.patientData});

  @override
  _RPatientListSlidableComponentState createState() => _RPatientListSlidableComponentState();
}

class _RPatientListSlidableComponentState extends State<RPatientListSlidableComponent> {
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
      key: ValueKey(widget.patientData!),
      child: Container(
        padding: EdgeInsets.only(left: 8, top: 10, bottom: 10, right: 8),
        decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageWidget(url: widget.patientData!.profileImage, height: 80),
            8.width,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.patientData!.display_name.validate(), style: boldTextStyle(size: 16), maxLines: 2).flexible(),
                    FaIcon(FontAwesomeIcons.gaugeHigh, size: 20, color: appSecondaryColor).paddingAll(8).onTap(
                      () {
                        EncounterScreen(patientData: widget.patientData!, image: widget.patientData!.profileImage).launch(context);
                      },
                    )
                  ],
                ),
                8.height,
                Row(
                  children: [
                    ic_phone.iconImage(size: 14),
                    10.width,
                    Text(widget.patientData!.mobile_number.validate(), style: primaryTextStyle()),
                  ],
                ).onTap(() {
                  commonLaunchUrl("tel:// ${widget.patientData!.mobile_number.validate()}");
                }),
                14.height,
                Row(
                  children: [
                    ic_user.iconImage(size: 14),
                    10.width,
                    Text(widget.patientData!.gender.validate(value: 'N/A').capitalizeFirstLetter(), style: primaryTextStyle()),
                  ],
                ),
              ],
            ).expand()
          ],
        ),
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) async {
              bool? res = await AddPatientScreen(userId: widget.patientData!.iD).launch(context);
              if (res ?? false) setState(() {});
            },
            flex: 2,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), bottomLeft: Radius.circular(defaultRadius)),
            icon: Icons.edit,
            label: locale.lblEdit,
          ),
          SlidableAction(
            flex: 2,
            borderRadius: BorderRadius.only(topRight: Radius.circular(defaultRadius), bottomRight: Radius.circular(defaultRadius)),
            onPressed: (BuildContext context) async {
              showConfirmDialogCustom(
                context,
                dialogType: DialogType.DELETE,
                title: locale.lblDeleteRecordConfirmation + " ${widget.patientData!.display_name}?",
                onAccept: (p0) {
                  Map<String, dynamic> request = {
                    "patient_id": widget.patientData!.iD,
                  };

                  appStore.setLoading(true);

                  deletePatientData(request).then((value) {
                    appStore.setLoading(false);
                    toast(locale.lblAllRecordsFor + " ${widget.patientData!.display_name} " + locale.lblAreDeleted);
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
