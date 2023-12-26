import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/common/appointment_quick_view.dart';
import 'package:kivicare_flutter/components/common_row_widget.dart';
import 'package:kivicare_flutter/components/role_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_dashboard_model.dart';
import 'package:kivicare_flutter/network/appointment_respository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/appointment/doctor_add_appointment_step1_screen.dart';
import 'package:kivicare_flutter/screens/doctor/screens/encounter_dashboard_screen.dart';
import 'package:kivicare_flutter/screens/patient/screens/appointment/add_appointment_step3.dart';
import 'package:kivicare_flutter/screens/patient/screens/patient_encounter_dashboard_screen.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/appointment/r_appointment_screen1.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/date_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/int_extesnions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonAppointmentWidget extends StatefulWidget {
  final UpcomingAppointment? upcomingData;
  final int index;

  CommonAppointmentWidget({this.upcomingData, required this.index});

  @override
  _CommonAppointmentWidgetState createState() => _CommonAppointmentWidgetState();
}

class _CommonAppointmentWidgetState extends State<CommonAppointmentWidget> {
  String today = DateTime.now().getFormattedDate(CONVERT_DATE);

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
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

  void changeAppointmentStatus(BuildContext context) async {
    await showConfirmDialogCustom(context,
        title: locale.lblUpdateAppointmentStatus,
        cancelable: false,
        onCancel: (s) {
          finish(context);
        },
        primaryColor: primaryColor,
        dialogType: DialogType.CONFIRMATION,
        onAccept: (ctx) {
          if (widget.upcomingData!.status.toInt() == 1) {
            updateStatus(id: widget.upcomingData!.id.toInt(), status: 4);
          } else if (widget.upcomingData!.status.toInt() == 4) {
            if (getStringAsync(USER_DATA).isNotEmpty) {
              push(EncounterDashboardScreen(id: widget.upcomingData!.encounter_id));
            }
          }
        });
  }

  void deleteAppointmentValue(BuildContext context) async {
    showConfirmDialogCustom(
      context,
      dialogType: DialogType.DELETE,
      title: locale.lblAreDeleteAppointment,
      onAccept: (p0) {
        deleteAppointmentById(widget.upcomingData!.id.toInt());
      },
    );
  }

  void get telemedData async {
    if (isDoctor()) {
      commonLaunchUrl(widget.upcomingData!.zoomData!.startUrl!);
    } else if (isPatient()) {
      commonLaunchUrl(widget.upcomingData!.zoomData!.joinUrl!);
    } else {
      toast(locale.lblYouCannotStart);
    }
  }

  void updateStatus({int? id, int? status}) async {
    appStore.setLoading(true);
    Map<String, dynamic> request = {
      "appointment_id": id.toString(),
      "appointment_status": status.toString(),
    };

    await updateAppointmentStatus(request).then((value) {
      LiveStream().emit(UPDATE, true);
      LiveStream().emit(APP_UPDATE, true);
      finish(context);

      toast(locale.lblChangedTo + " ${status.getStatus()}");
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  void deleteAppointmentById(int id) async {
    appStore.setLoading(true);
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

  Widget buildStatusWidget() {
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: boxDecorationDefault(
          color: successTextColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(defaultRadius)),
        ),
        child: Text(getStatus(widget.upcomingData!.status.validate()), style: boldTextStyle(size: 12, color: white)),
      ),
    );
  }

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
            borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), bottomLeft: Radius.circular(defaultRadius)),
            icon: Icons.edit,
            label: locale.lblEdit,
          ),
          SlidableAction(
            // An action can be bigger than the others.
            borderRadius: BorderRadius.only(topRight: Radius.circular(defaultRadius), bottomRight: Radius.circular(defaultRadius)),
            onPressed: deleteAppointmentValue,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: locale.lblDelete,
          ),
        ],
      ),
      child: Container(
        decoration: boxDecorationDefault(color: context.cardColor),
        width: context.width(),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
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
                      ),
                      16.width,
                      Wrap(
                        runSpacing: 10,
                        children: [
                          Text(getRoleWiseAppointmentName(name: widget.upcomingData!.doctor_name.validate()), style: boldTextStyle()),
                          RoleWidget(isShowReceptionist: true, child: CommonRowWidget(title: locale.lblDoctor, value: widget.upcomingData!.doctor_name.validate(), isMarquee: true)),
                          CommonRowWidget(title: locale.lblService, value: widget.upcomingData!.getVisitTypes),
                          CommonRowWidget(title: locale.lblDate, value: widget.upcomingData!.getAppointmentStartTime.validate()),
                          CommonRowWidget(title: locale.lblTime, value: widget.upcomingData!.getAppointmentTime.validate()),
                          CommonRowWidget(title: locale.lblDesc, value: widget.upcomingData!.description.validate()),
                          CommonRowWidget(
                            title: locale.lblPrice,
                            value: widget.upcomingData!.all_service_charges.getFormattedPrice(),
                            valueColor: primaryColor,
                          ),
                        ],
                      ).expand(),
                    ],
                  ),
                  8.height,
                  Row(
                    children: [
                      Flexible(
                        child: AppButton(
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
                                      decoration: boxDecorationDefault(
                                        color: successTextColor,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(defaultRadius)),
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
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: (isEncounterDashboard || isCheckIn)
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(defaultRadius),
                                    bottomLeft: Radius.circular(defaultRadius),
                                  )
                                : BorderRadius.all(Radius.circular(defaultRadius)),
                          ),
                          child: FittedBox(
                            child: FittedBox(child: Text(locale.lblViewDetails, style: boldTextStyle(color: white, size: 12))),
                          ),
                          color: appPrimaryColor,
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
                  ),
                ],
              ),
            ),
            buildStatusWidget(),
          ],
        ),
      ),
    );
  }
}
