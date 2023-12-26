import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/get_doctor_detail_model.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/add_qualification_screen.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileQualification extends StatefulWidget {
  final GetDoctorDetailModel getDoctorDetail;

  ProfileQualification({required this.getDoctorDetail});

  @override
  _ProfileQualificationState createState() => _ProfileQualificationState();
}

class _ProfileQualificationState extends State<ProfileQualification> {
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
  void didUpdateWidget(covariant ProfileQualification oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void saveDetails() async {
    Map<String, dynamic> request = {
      "qualifications": jsonEncode(widget.getDoctorDetail.qualifications),
    };
    editProfileAppStore.addData(request);
    appStore.setLoading(true);
    await updateProfile(context, editProfileAppStore.editProfile, file: image != null ? File(image!.path) : null).then((value) {
      //
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBodyWidget() {
    return Body(
      child: Stack(
        children: [
          AnimatedScrollView(
            padding: EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 16),
            listAnimationType: ListAnimationType.FadeIn,
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: TextButton(
                  onPressed: () async {
                    bool? res = await AddQualificationScreen(data: widget.getDoctorDetail, qualificationList: widget.getDoctorDetail.qualifications.validate()).launch(context);
                    if (res ?? false) {
                      setState(() {});
                    }
                  },
                  child: Text("+${locale.lblAddNewQualification}", style: boldTextStyle(color: primaryColor, size: 16)),
                ),
              ),
              if (widget.getDoctorDetail.qualifications.validate().isNotEmpty)
                AnimatedListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 70),
                  itemCount: widget.getDoctorDetail.qualifications.validate().length,
                  itemBuilder: (BuildContext context, int index) {
                    Qualification data = widget.getDoctorDetail.qualifications![index];
                    return Container(
                      decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ic_graduation_cap.iconImage(),
                              16.width,
                              Marquee(
                                child: Text(data.degree.validate().toUpperCase(), style: boldTextStyle(size: 16)),
                              ).expand(),
                              8.width,
                              IconButton(
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                icon: ic_edit.iconImage(size: 18, color: context.iconColor),
                                onPressed: () {
                                  AddQualificationScreen(qualification: data, data: widget.getDoctorDetail, qualificationList: widget.getDoctorDetail.qualifications).launch(context);
                                },
                              ),
                            ],
                          ),
                          UL(
                            symbolColor: appSecondaryColor,
                            children: [
                              Text(data.university.validate(), style: secondaryTextStyle()),
                              Text(data.year.toString().validate(), style: secondaryTextStyle()),
                            ],
                          ).paddingOnly(left: 42),
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
              onTap: () {
                showConfirmDialogCustom(
                  context,
                  dialogType: DialogType.UPDATE,
                  primaryColor: context.primaryColor,
                  title: "Are you sure you want to submit the qualification?",
                  onAccept: (p0) => saveDetails(),
                );
              },
              width: context.width(),
              text: locale.lblSaveAndContinue,
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
