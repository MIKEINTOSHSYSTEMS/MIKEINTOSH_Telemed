import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_schedule_model.dart';
import 'package:kivicare_flutter/screens/doctor/screens/add_session_screen.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorSessionListComponent extends StatefulWidget {
  final SessionData? data;

  DoctorSessionListComponent({required this.data});

  @override
  _DoctorSessionListComponentState createState() => _DoctorSessionListComponentState();
}

class _DoctorSessionListComponentState extends State<DoctorSessionListComponent> {
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
    return GestureDetector(
      onTap: () async {
        bool? res = await AddSessionsScreen(sessionData: widget.data!).launch(context);
        if (res ?? false) {
          setState(() {});
        }
      },
      child: Container(
        decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
        margin: EdgeInsets.only(top: 8, bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedImageWidget(
                  url: '',
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  radius: 120,
                ),
                16.width,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.data!.clinic_name.validate()}', style: boldTextStyle(size: 16)),
                    16.height,
                    if (appStore.userRole!.toLowerCase() == UserRoleReceptionist)
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Doctor: ", style: secondaryTextStyle(size: 16)),
                              Text('${widget.data!.doctors.validate()}', style: boldTextStyle()).flexible(),
                            ],
                          ),
                          8.height,
                        ],
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locale.lblSpeciality, style: secondaryTextStyle(size: 16)),
                        Text('${widget.data!.specialties.validate()}', style: boldTextStyle()).flexible(),
                      ],
                    ),
                    8.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locale.lblOpen, style: secondaryTextStyle(size: 16)),
                        Text(
                          '${widget.data!.days!.map((e) => e.validate().capitalizeFirstLetter()).join(" - ")}',
                          style: boldTextStyle(),
                        ).paddingOnly(top: 1).flexible(),
                      ],
                    ),
                  ],
                ).expand(),
              ],
            ),
            16.height,
            Container(
              decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ic_morning.iconImage(size: 22, color: Colors.orange),
                      10.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.lblMorning, style: secondaryTextStyle()),
                          6.height,
                          Text("${widget.data!.morningStart.validate()} to ${widget.data!.morningEnd.validate()}", style: boldTextStyle(size: 14)),
                        ],
                      ).expand(),
                    ],
                  ).expand(),
                  16.width,
                  Row(
                    children: [
                      ic_evening.iconImage(size: 22, color: Colors.red),
                      10.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.lblEvening, style: secondaryTextStyle()),
                          6.height,
                          widget.data!.eveningStart.validate() == "-"
                              ? Text('--', style: boldTextStyle())
                              : Text(
                                  "${widget.data!.eveningStart.validate()} to ${widget.data!.eveningEnd.validate()} ",
                                  style: boldTextStyle(size: 14),
                                ),
                        ],
                      ).expand(),
                    ],
                  ).expand(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
