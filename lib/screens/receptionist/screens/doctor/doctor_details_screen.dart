import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momona_healthcare/components/cached_image_widget.dart';
import 'package:momona_healthcare/components/common_row_component.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/view_all_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/network/auth_repository.dart';
import 'package:momona_healthcare/network/doctor_repository.dart';
import 'package:momona_healthcare/screens/patient/screens/review/component/review_widget.dart';
import 'package:momona_healthcare/screens/patient/screens/review/rating_view_all_screen.dart';
import 'package:momona_healthcare/screens/receptionist/components/qualification_item_widget.dart';
import 'package:momona_healthcare/screens/receptionist/screens/doctor/add_doctor_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorDetailScreen extends StatefulWidget {
  final UserModel doctorData;
  final VoidCallback? refreshCall;

  DoctorDetailScreen({Key? key, this.refreshCall, required this.doctorData}) : super(key: key);

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  late UserModel doctor;

  double topPosition = 250;

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark);
    });

    getDoctorData(showLoader: isPatient() || isReceptionist() ? true : false);
  }

  Future<void> getDoctorData({bool showLoader = true}) async {
    doctor = widget.doctorData;

    if (widget.doctorData.doctorId.validate().isNotEmpty && widget.doctorData.doctorId.validate().toInt() != 0) {
      doctor.iD = widget.doctorData.doctorId.toInt();
    }
    if (showLoader) {
      appStore.setLoading(true);
    }
    getSingleUserDetailAPI(doctor.iD.validate()).then((value) {
      appStore.setLoading(false);

      if (value.iD == null) value.iD = doctor.iD;
      if (value.available == null) value.available = doctor.available;
      if (doctor.ratingList.validate().isNotEmpty) value.ratingList = doctor.ratingList;

      if (value.displayName == null) value.displayName = '${value.firstName} ${value.lastName.validate()}';
      doctor = value;
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);

      toast(e.toString());
      log("GET DOCTOR ERROR : ${e.toString()} ");
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> deleteDoctor(int doctorId) async {
    showConfirmDialogCustom(
      context,
      dialogType: DialogType.DELETE,
      title: locale.lblDoYouWantToDeleteDoctor,
      onAccept: (p0) {
        Map<String, dynamic> request = {
          "doctor_id": doctorId,
        };

        appStore.setLoading(true);

        deleteDoctorAPI(request).then((value) {
          appStore.setLoading(false);
          toast(locale.lblDoctorDeleted);
          finish(context, true);
          finish(context, true);
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
          throw e;
        });

        appStore.setLoading(false);
      },
    );
  }

  bool get isEdit {
    return isVisible(SharedPreferenceKey.kiviCareDoctorEditKey);
  }

  bool get isDelete {
    return isVisible(SharedPreferenceKey.kiviCareDoctorDeleteKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: context.height(),
            width: context.width(),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: context.height() / 2,
                    width: context.width(),
                    decoration: boxDecorationDefault(
                      borderRadius: BorderRadius.zero,
                      color: doctor.profileImage.validate().isNotEmpty ? null : context.scaffoldBackgroundColor,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: List.generate(10, (index) => Colors.black.withAlpha(index * 32)),
                      ),
                      image: doctor.profileImage.validate().isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(doctor.profileImage.validate()),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(ic_doctor),
                              colorFilter: appStore.isDarkModeOn ? null : ColorFilter.mode(appPrimaryColor.withOpacity(0.6), BlendMode.dstOver),
                            ),
                    ),
                  ),
                  Container(
                    width: context.width(),
                    height: context.height() * 0.7,
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(top: doctor.profileImage.validate().isEmpty ? 360 : 300),
                    decoration: boxDecorationDefault(
                      color: context.cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        if (doctor.qualifications.validate().isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(locale.lblQualification, style: boldTextStyle()),
                              Wrap(
                                spacing: 6,
                                children: doctor.qualifications.validate().map((element) {
                                  return QualificationItemWidget(
                                    data: element,
                                    showAdd: false,
                                    onEdit: () {},
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        8.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Visiting Days', style: boldTextStyle()),
                            Container(
                              decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(defaultRadius), color: context.cardColor),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ic_calendar.iconImage(size: 20, color: appSecondaryColor),
                                  22.width,
                                  if (doctor.available.validate().isNotEmpty)
                                    Text(
                                      doctor.available.validate().split(',').join(' - ').capitalizeEachWord(),
                                      style: primaryTextStyle(),
                                    ).expand()
                                  else
                                    Text("Dr. ${doctor.displayName} ${locale.lblWeekDaysDataNotFound}", style: primaryTextStyle()).expand(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        10.height,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(locale.lblContact, style: boldTextStyle()),
                            Container(
                              decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(defaultRadius), color: context.cardColor),
                              padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ic_message.iconImage(color: appSecondaryColor, size: 20),
                                      22.width,
                                      Text(doctor.userEmail.validate(), style: primaryTextStyle()).expand(),
                                    ],
                                  ),
                                  12.height,
                                  Row(
                                    children: [
                                      ic_phone.iconImage(color: greenColor, size: 20),
                                      22.width,
                                      Text(doctor.mobileNumber.validate(), style: primaryTextStyle()).expand(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        12.height,
                        if (isProEnabled() && doctor.ratingList.validate().isNotEmpty)
                          Column(
                            children: [
                              ViewAllLabel(
                                label: locale.lblRatingsAndReviews,
                                labelSize: 16,
                                subLabel: '${locale.lblKnowWhatYourPatientsSaysAboutYou} ${doctor.displayName.validate().prefixText(value: 'Dr. ')}',
                                viewAllShowLimit: 5,
                                list: doctor.ratingList.validate(),
                                onTap: () {
                                  RatingViewAllScreen(doctorId: doctor.iD.validate()).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                                },
                              ),
                              16.height,
                              if (doctor.ratingList.validate().isNotEmpty)
                                ...doctor.ratingList.validate().map((e) {
                                  return ReviewWidget(
                                    data: e,
                                    addMargin: false,
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
                                  ).visible(
                                    e.patientName.validate().isNotEmpty,
                                  );
                                }).toList()
                            ],
                          )
                      ],
                    ).paddingTop(48),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: context.width(),
                    margin: EdgeInsets.only(left: 22, right: 22, top: doctor.profileImage.validate().isEmpty ? 330 : 254),
                    decoration: boxDecorationDefault(
                      color: appStore.isDarkModeOn ? appSecondaryColor.withOpacity(0.96) : appPrimaryColor.withOpacity(0.98),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (doctor.displayName.validate().isNotEmpty)
                          RichTextWidget(
                            list: [
                              TextSpan(text: doctor.displayName.validate(), style: boldTextStyle(color: Colors.white, size: 18)),
                              if (doctor.qualifications.validate().isNotEmpty)
                                TextSpan(
                                  text: doctor.qualifications!.map((e) => e.degree.validate().capitalizeFirstLetter()).toList().join(' - ').prefixText(value: ' (').suffixText(value: ')'),
                                  style: primaryTextStyle(color: Colors.white),
                                ),
                            ],
                          ),
                        if (doctor.noOfExperience.validate().toInt() != 0)
                          Text(
                            '${locale.lblExperiencePractitioner}' + '${doctor.noOfExperience.validate().toInt() > 1 ? doctor.noOfExperience.validate() + ' ${locale.lblYears}' : ' ${locale.lblYear}'}',
                            style: secondaryTextStyle(color: Colors.white),
                          ),
                        if (doctor.specialties.validate().isNotEmpty)
                          ReadMoreText(
                            doctor.specialties.validate().map((e) => e.label.validate()).join(' - '),
                            style: secondaryTextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            trimLines: 1,
                            trimMode: TrimMode.Line,
                            colorClickableText: Colors.white70,
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackButton(color: Colors.white),
                      if (isReceptionist())
                        PopupMenuButton(
                          enabled: true,
                          icon: FaIcon(Icons.more_vert, color: Colors.white70),
                          itemBuilder: (context) {
                            return [
                              if (isEdit)
                                PopupMenuItem(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(Icons.edit, size: 18, color: Colors.green),
                                      Text(locale.lblEdit, style: secondaryTextStyle()).paddingLeft(4),
                                    ],
                                  ).appOnTap(
                                    () async {
                                      ifTester(
                                        context,
                                        () async {
                                          await AddDoctorScreen(
                                                  doctorData: doctor,
                                                  refreshCall: () {
                                                    widget.refreshCall?.call();
                                                    getDoctorData();
                                                  })
                                              .launch(
                                                context,
                                                pageRouteAnimation: pageAnimation,
                                                duration: pageAnimationDuration,
                                              )
                                              .then(
                                                (value) => (value) {
                                                  widget.refreshCall?.call();
                                                  getDoctorData();
                                                },
                                              );
                                        },
                                        userEmail: doctor.userEmail.validate(),
                                      );
                                    },
                                  ),
                                ),
                              if (isDelete)
                                PopupMenuItem(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FaIcon(Icons.delete, size: 18, color: Colors.red),
                                          FittedBox(child: Text(locale.lblDelete, style: secondaryTextStyle())).paddingLeft(4),
                                        ],
                                      ).appOnTap(() {
                                        ifTester(context, () => deleteDoctor(doctor.iD.validate()), userEmail: doctor.userEmail.validate());
                                      })
                                    ],
                                  ),
                                ),
                            ];
                          },
                          color: context.cardColor,
                          constraints: BoxConstraints(
                            maxHeight: 100,
                            maxWidth: 80,
                          ),
                        ),
                    ],
                  ).paddingSymmetric(vertical: context.statusBarHeight)
                ],
              ),
            ),
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading).center())
        ],
      ),
    );
  }
}
