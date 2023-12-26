import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/prescription_model.dart';
import 'package:kivicare_flutter/network/prescription_repository.dart';
import 'package:kivicare_flutter/screens/doctor/components/add_prescription_screen.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/int_extesnions.dart';
import 'package:nb_utils/nb_utils.dart';

class PrescriptionFragment extends StatefulWidget {
  final int? id;

  PrescriptionFragment({this.id});

  @override
  _PrescriptionFragmentState createState() => _PrescriptionFragmentState();
}

class _PrescriptionFragmentState extends State<PrescriptionFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didUpdateWidget(covariant PrescriptionFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrescriptionModel>(
      future: getPrescriptionResponse(widget.id.toString()),
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data!.prescriptionData.validate().isEmpty)
            return NoDataFoundWidget(
              text: "No Prescriptions founds ",
            );
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPatient())
                      Text(locale.lblPrescription + ' (${snap.data!.total})', style: boldTextStyle(size: 18))
                    else
                      Row(
                        children: [
                          Text(locale.lblPrescription + ' (${snap.data!.total})', style: boldTextStyle(size: 18)),
                          Spacer(),
                          TextButton(
                            child: Text(locale.lblSend_prescription_on_mail),
                            onPressed: () async {
                              appStore.setLoading(true);
                              await sendPrescriptionMail(encounterId: widget.id.validate()).then((value) {
                                toast(value.message.toString());
                              }).catchError((e) {
                                //
                              });
                              appStore.setLoading(false);
                            },
                          ),
                        ],
                      ),
                    16.height,
                    AnimatedListView(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: snap.data!.prescriptionData!.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        PrescriptionData data = snap.data!.prescriptionData![index];
                        DateTime tempDate = new DateFormat(CONVERT_DATE).parse(data.created_at!);
                        return Container(
                          decoration: boxDecorationDefault(
                            color: context.cardColor,
                            border: Border.all(color: context.dividerColor),
                            borderRadius: radius(),
                          ),
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                child: Column(
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(text: tempDate.day.toString(), style: boldTextStyle(size: 22)),
                                          WidgetSpan(
                                            child: Transform.translate(
                                              offset: const Offset(2, -10),
                                              child: Text(
                                                getDayOfMonthSuffix(tempDate.day).toString(),
                                                textScaleFactor: 0.7,
                                                style: boldTextStyle(size: 14),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      tempDate.month.getMonthName(),
                                      textAlign: TextAlign.center,
                                      style: secondaryTextStyle(size: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 80,
                                child: VerticalDivider(color: viewLineColor, width: 25, thickness: 1, indent: 1, endIndent: 1),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(data.name.validate(), style: boldTextStyle(size: 16, color: primaryColor)),
                                  5.height,
                                  Text(data.frequency.validate(), style: primaryTextStyle(size: 14)),
                                  5.height,
                                  Text("${data.duration.validate()} " + locale.lblDays, style: primaryTextStyle(size: 14)),
                                  5.height,
                                  ReadMoreText(
                                    data.instruction.validate(),
                                    style: primaryTextStyle(),
                                    trimLines: 1,
                                    trimMode: TrimMode.Line,
                                    locale: Localizations.localeOf(context),
                                  ),
                                ],
                              ).expand(),
                            ],
                          ),
                        ).onTap(() async {
                          await AddPrescriptionScreen(
                            id: widget.id,
                            pID: data.id.toInt(),
                            prescriptionData: data,
                          ).launch(context).then(
                            (value) {
                              if (value ?? false) {
                                getPrescriptionResponse(widget.id.toString());
                                setState(() {});
                              }
                            },
                          );
                        }, highlightColor: Colors.transparent, splashColor: Colors.transparent);
                      },
                    ).paddingBottom(60),
                  ],
                ),
              ),
              Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
            ],
          );
        }
        return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget());
      },
    );
  }
}
