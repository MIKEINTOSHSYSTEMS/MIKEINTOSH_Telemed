import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/get_doctor_detail_model.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/add_qualification_screen.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class RProfileQualification extends StatefulWidget {
  final GetDoctorDetailModel? getDoctorDetail;

  RProfileQualification({this.getDoctorDetail});

  @override
  _RProfileQualificationState createState() => _RProfileQualificationState();
}

class _RProfileQualificationState extends State<RProfileQualification> {
  List<Qualification>? qualificationList = [];

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isUpdate = widget.getDoctorDetail != null;
    if (isUpdate) {
      qualificationList = widget.getDoctorDetail!.qualifications;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didUpdateWidget(covariant RProfileQualification oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void saveDetails() async {
    appStore.setLoading(true);

    Map<String, dynamic> request = {
      "qualifications": jsonEncode(qualificationList),
    };
    editProfileAppStore.addData(request);

    await addDoctor(editProfileAppStore.editProfile).then((value) {
      finish(context, true);
      toast(locale.lblDoctorAddedSuccessfully);
      setDynamicStatusBarColor();
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  void updateDetails() async {
    appStore.setLoading(true);

    Map<String, dynamic> request = {
      "qualifications": jsonEncode(qualificationList),
    };
    editProfileAppStore.addData(request);

    await updateReceptionistDoctor(editProfileAppStore.editProfile).then((value) {
      finish(context, true);
      toast(locale.lblDoctorUpdatedSuccessfully);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  void dispose() {
    super.dispose();
    setDynamicStatusBarColor(color: scaffoldLightColor);
  }

  Widget buildBodyWidget() {
    return Body(
      child: Stack(
        children: [
          AnimatedScrollView(
            padding: EdgeInsets.all(16),
            listAnimationType: ListAnimationType.FadeIn,
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Container(
                  padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                  decoration: boxDecorationDefault(borderRadius: radius()),
                  child: Text(locale.lblAddNewQualification, style: boldTextStyle(color: primaryColor)).onTap(
                    () async {
                      bool? res = await AddQualificationScreen(qualificationList: qualificationList).launch(context);
                      if (res ?? false) {
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
              16.height,
              if (qualificationList.validate().isNotEmpty)
                AnimatedListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 60),
                  itemCount: qualificationList == null ? 0 : qualificationList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    Qualification data = qualificationList![index];
                    return Container(
                      decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(defaultRadius), color: context.cardColor),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ic_graduation_cap.iconImage(size: 24, color: appSecondaryColor),
                              16.width,
                              Text(data.degree!.toUpperCase().validate(), style: boldTextStyle(size: 16)).expand(),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: ic_edit.iconImage(size: 18, color: appStore.isDarkModeOn ? Colors.white : secondaryTxtColor, fit: BoxFit.cover),
                                onPressed: () {
                                  AddQualificationScreen(qualification: data, data: widget.getDoctorDetail, qualificationList: qualificationList).launch(context);
                                },
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (data.university.validate().isNotEmpty)
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: boxDecorationDefault(shape: BoxShape.circle),
                                        ),
                                        8.width,
                                        Text(data.university.validate(), style: secondaryTextStyle()),
                                      ],
                                    ),
                                  ],
                                ),
                              if (data.year.toString().validate().isNotEmpty)
                                Column(
                                  children: [
                                    16.height,
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: boxDecorationDefault(shape: BoxShape.circle),
                                        ),
                                        8.width,
                                        Text(data.year.toString().validate(), style: secondaryTextStyle()),
                                      ],
                                    ),
                                  ],
                                )
                            ],
                          ).paddingOnly(left: 30),
                        ],
                      ),
                    );
                  },
                )
              else
                NoDataFoundWidget(text: locale.lblNoDataFound).center(),
            ],
          ),
          Positioned(
            right: 16,
            left: 16,
            bottom: 16,
            child: AppButton(
              width: context.width(),
              text: locale.lblSaveAndContinue,
              onTap: () {
                showConfirmDialogCustom(
                  context,
                  dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
                  primaryColor: context.primaryColor,
                  title: "Are you sure you want to submit the qualification?",
                  onAccept: (p0) {
                    isUpdate ? updateDetails() : saveDetails();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBodyWidget(),
    );
  }
}
