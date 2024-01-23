import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/common/appointment_quick_view.dart';
import 'package:momona_healthcare/components/common_row_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_dashboard_model.dart';
import 'package:momona_healthcare/network/appointment_respository.dart';
import 'package:momona_healthcare/screens/doctor/screens/appointment/doctor_add_appointment_step1_screen.dart';
import 'package:momona_healthcare/screens/doctor/screens/encounter_dashboard_screen.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/add_appointment_step3.dart';
import 'package:momona_healthcare/screens/patient/screens/patient_encounter_dashboard_screen.dart';
import 'package:momona_healthcare/screens/receptionist/screens/appointment/r_appointment_screen1.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/date_extensions.dart';
import 'package:momona_healthcare/utils/extensions/int_extesnions.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AppointmentWidget extends StatefulWidget {
  final UpcomingAppointment? upcomingData;
  final int index;

  AppointmentWidget({this.upcomingData, required this.index});

  @override
  _AppointmentWidgetState createState() => _AppointmentWidgetState();
}

class _AppointmentWidgetState extends State<AppointmentWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  //region Methods
  void changeAppointmentStatus(BuildContext context) async {
    await showConfirmDialogCustom(
      context,
      title: locale.lblUpdateAppointmentStatus,
      cancelable: false,
      onCancel: (s) {
        finish(context);
      },
      primaryColor: primaryColor,
      dialogType: DialogType.CONFIRMATION,
      onAccept: (ctx) {
        if (widget.upcomingData!.status.toInt() == 1) {
          finish(context);
          appStore.setLoading(true);
          updateStatus(id: widget.upcomingData!.id.toInt(), status: 4);
        } else if (widget.upcomingData!.status.toInt() == 4) {
          if (getStringAsync(USER_DATA).isNotEmpty) {
            finish(context);
            push(EncounterDashboardScreen(id: widget.upcomingData!.encounter_id));
          }
        }
      },
    );
  }

  void deleteAppointmentValue(BuildContext context) async {
    bool? res = await showConfirmDialog(context, locale.lblAreDeleteAppointment, buttonColor: primaryColor);
    if (res ?? false) {
      deleteAppointmentById(widget.upcomingData!.id.toInt());
    }
  }

  void updateStatus({int? id, int? status}) async {
    Map<String, dynamic> request = {
      "appointment_id": id.toString(),
      "appointment_status": status.toString(),
    };

    await updateAppointmentStatus(request).then((value) {
      LiveStream().emit(UPDATE, true);
      LiveStream().emit(APP_UPDATE, true);
      appStore.setLoading(false);

      finish(context);

      toast(locale.lblChangedTo + " ${status.getStatus()}");
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  void deleteAppointmentById(int id) async {
    Map<String, dynamic> request = {"id": id};

    await deleteAppointment(request).then((value) {
      LiveStream().emit(UPDATE, true);
      LiveStream().emit(APP_UPDATE, true);
      LiveStream().emit(DELETE, true);

      toast(locale.lblAppointmentDeleted);
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  //endregion

  //region Conditions
  void get telemedData async {
    if (isDoctor()) {
      commonLaunchUrl(widget.upcomingData!.zoomData!.startUrl!);
    } else if (isPatient()) {
      commonLaunchUrl(widget.upcomingData!.zoomData!.joinUrl!);
    } else {
      toast(locale.lblYouCannotStart);
    }
  }

  bool get isTelemed {
    bool mIsON = false;
    if (!isReceptionist()) {
      if (widget.upcomingData!.zoomData != null && widget.upcomingData!.status.toInt().getStatus() == CheckInStatus) {
        return mIsON = true;
      }
    }
    return mIsON;
  }

  bool get isCheckIn {
    bool mIsCheckIn = false;
    if (isPatient()) {
      mIsCheckIn = false;
    } else {
      if (widget.upcomingData!.status.toInt().getStatus() != CancelledStatus && widget.upcomingData!.status.toInt().getStatus() != CheckOutStatus) {
        mIsCheckIn = DateTime.parse(widget.upcomingData!.appointment_start_date!).difference(DateTime.parse(DateFormat(CONVERT_DATE).format(DateTime.now()))).inDays == 0;
      }
    }
    return mIsCheckIn;
  }

  bool get isEncounterDashboard {
    return widget.upcomingData!.status.toInt().getStatus() == CheckInStatus || widget.upcomingData!.status.toInt().getStatus() == CheckOutStatus;
  }

  bool get isEdit {
    return widget.upcomingData!.status.toInt().getStatus() != CheckOutStatus &&
        widget.upcomingData!.status.toInt().getStatus() != CancelledStatus &&
        widget.upcomingData!.status.toInt().getStatus() != CheckInStatus &&
        DateTime.parse(widget.upcomingData!.appointment_start_date.validate()).difference(DateTime.now()).inDays >= 0;
  }

  //endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context1) {
    return Slidable(
      key: ValueKey(widget.upcomingData),
      enabled: isEdit,
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              if (isPatient()) {
                AddAppointmentScreenStep3(data: widget.upcomingData).launch(
                  context,
                  pageRouteAnimation: PageRouteAnimation.Slide,
                );
              } else if (isReceptionist()) {
                RAppointment1Screen(id: getIntAsync(USER_ID), data: widget.upcomingData).launch(
                  context,
                  pageRouteAnimation: PageRouteAnimation.Slide,
                );
              } else {
                DoctorAddAppointmentStep1Screen(id: getIntAsync(USER_ID), appointmentData: widget.upcomingData).launch(
                  context,
                  pageRouteAnimation: PageRouteAnimation.Slide,
                );
              }
            },
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            borderRadius: radiusOnly(topLeft: defaultRadius, bottomLeft: defaultRadius),
            icon: Icons.edit,
            label: locale.lblEdit,
          ),
          SlidableAction(
            // An action can be bigger than the others.
            borderRadius: radiusOnly(topRight: defaultRadius, bottomRight: defaultRadius),
            onPressed: deleteAppointmentValue,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: locale.lblDelete,
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(defaultRadius), color: context.cardColor),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedImageWidget(
                      // url: data.attchments.validate().isNotEmpty ? data.attchments!.first.validate() : '',
                      url: '',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      radius: 120,
                    ).paddingOnly(top: 16),
                    22.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            20.height,
                            isPatient()
                                ? Text(
                                    "Dr. ${widget.upcomingData!.doctor_name.validate().capitalizeFirstLetter()}",
                                    style: boldTextStyle(size: titleTextSize),
                                  )
                                : Text(
                                    "${widget.upcomingData!.patient_name.validate().capitalizeFirstLetter()}",
                                    style: boldTextStyle(size: titleTextSize),
                                  ),
                            24.height,
                          ],
                        ),
                        Wrap(
                          runSpacing: 10,
                          children: [
                            if (isReceptionist())
                              CommonRowWidget(
                                title: locale.lblDoctor,
                                value: widget.upcomingData!.doctor_name.validate(),
                                isMarquee: true,
                              ),
                            CommonRowWidget(
                              title: locale.lblService,
                              value: '${widget.upcomingData!.visit_type.validate().map((e) => e.service_name.validate()).join(" , ")}',
                            ),
                            CommonRowWidget(
                              title: locale.lblDate,
                              value: widget.upcomingData!.appointment_start_date.validate().getFormattedDate(APPOINTMENT_DATE_FORMAT),
                            ),
                            CommonRowWidget(
                                title: locale.lblTime,
                                value:
                                    '${DateFormat(TIME_WITH_SECONDS).parse(widget.upcomingData!.appointment_start_time!).getFormattedDate(FORMAT_12_HOUR)} - ${DateFormat(TIME_WITH_SECONDS).parse(widget.upcomingData!.appointment_end_time!).getFormattedDate(FORMAT_12_HOUR)}'),
                            CommonRowWidget(
                              title: locale.lblDesc,
                              value: widget.upcomingData!.description.validate().trim().isNotEmpty ? widget.upcomingData!.description.validate() : 'NA',
                            ),
                            CommonRowWidget(
                              title: locale.lblPrice,
                              value: '${appStore.currency.validate()}${widget.upcomingData!.all_service_charges}',
                              valueColor: primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ).expand(),
                  ],
                ),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: AppButton(
                            color: appPrimaryColor,
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: (isEncounterDashboard || isCheckIn)
                                  ? radiusOnly(
                                      topLeft: defaultRadius,
                                      bottomLeft: defaultRadius,
                                    )
                                  : radius(),
                            ),
                            child: FittedBox(
                              child: FittedBox(
                                child: Text(locale.lblViewDetails, style: boldTextStyle(color: white, size: 12)),
                              ),
                            ),
                            onTap: () {
                              showInDialog(
                                context,
                                contentPadding: EdgeInsets.zero,
                                title: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: boxDecorationDefault(color: appSecondaryColor),
                                          child: Image.asset(
                                            ic_appointment,
                                            fit: BoxFit.cover,
                                            height: 22,
                                            width: 22,
                                            color: white,
                                          ),
                                        ),
                                        16.width,
                                        Text(locale.lblAppointmentSummary, style: boldTextStyle(size: 18)).flexible(),
                                      ],
                                    ).paddingOnly(top: 24),
                                    Positioned(
                                      right: -24,
                                      top: -24,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        decoration: boxDecorationWithRoundedCorners(
                                          backgroundColor: successTextColor,
                                          borderRadius: radiusOnly(topRight: defaultRadius),
                                        ),
                                        child: Text(
                                          getStatus(widget.upcomingData!.status.validate()),
                                          style: boldTextStyle(size: 12, color: white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                builder: (p0) {
                                  return AppointmentQuickView(
                                    upcomingAppointment: widget.upcomingData!,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Flexible(
                          child: AppButton(
                            onTap: () {
                              if (isPatient()) {
                                PatientEncounterDashboardScreen(
                                  id: widget.upcomingData!.encounter_id.validate().toInt(),
                                ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                              } else {
                                EncounterDashboardScreen(
                                  id: widget.upcomingData!.encounter_id.validate(),
                                ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                              }
                            },
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: isCheckIn
                                  ? BorderRadius.all(Radius.circular(0))
                                  : BorderRadius.only(
                                      topRight: Radius.circular(defaultRadius),
                                      bottomRight: Radius.circular(defaultRadius),
                                    ),
                            ),
                            child: FittedBox(child: Text(locale.lblEncounter, style: boldTextStyle(color: white, size: 12))),
                            color: appStore.isDarkModeOn ? context.scaffoldBackgroundColor : Colors.black,
                          ),
                        ).visible(isEncounterDashboard),
                        Flexible(
                          child: AppButton(
                            onTap: () {
                              changeAppointmentStatus(context);
                            },
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(defaultRadius),
                                topRight: Radius.circular(defaultRadius),
                              ),
                            ),
                            child: FittedBox(
                              child: Text(locale.lblCheckIn, style: boldTextStyle(color: white, size: 12)).visible(
                                widget.upcomingData!.status.toInt().getStatus() != CheckInStatus,
                                defaultWidget: FittedBox(
                                  child: Text(locale.lblCheckOut, style: boldTextStyle(color: white, size: 12)),
                                ),
                              ),
                            ),
                            color: appSecondaryColor,
                          ),
                        ).visible(isCheckIn),
                      ],
                    ).expand(),
                    24.width,
                    Container(
                      decoration: boxDecorationDefault(shape: BoxShape.circle, color: appPrimaryColor),
                      padding: EdgeInsets.all(12),
                      child: Image.asset(ic_video, width: 16, height: 16, fit: BoxFit.cover, color: white),
                    ).visible(isTelemed).onTap(() => telemedData)
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: boxDecorationDefault(color: successTextColor, borderRadius: radiusOnly(topRight: defaultRadius)),
              child: Text(getStatus(widget.upcomingData!.status.validate()), style: boldTextStyle(size: 12, color: white)),
            ),
          )
        ],
      ).paddingOnly(right: 4),
    );
  }
}
