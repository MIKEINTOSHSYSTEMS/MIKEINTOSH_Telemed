import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/components/role_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_list_model.dart';
import 'package:momona_healthcare/network/doctor_list_repository.dart';
import 'package:momona_healthcare/screens/patient/components/doctor_detail_widget.dart';
import 'package:momona_healthcare/screens/receptionist/screens/r_add_new_doctor.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({Key? key, required this.data}) : super(key: key);

  final DoctorList? data;

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      decoration: boxDecorationDefault(borderRadius: radiusOnly(topLeft: 20, topRight: 20), color: context.scaffoldBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          12.height,
          Container(
            height: 4,
            width: 46,
            decoration: boxDecorationDefault(borderRadius: radius(), color: context.iconColor.withOpacity(0.2)),
          ).center(),
          16.height,
          Row(
            children: [
              16.height,
              Text(locale.lblDoctorDetails, style: boldTextStyle(size: 18)).expand(),
              Divider(color: appSecondaryColor.withOpacity(0.4)).visible(widget.data!.available.validate().isNotEmpty),
              RoleWidget(
                isShowReceptionist: true,
                child: IconButton(
                  icon: FaIcon(Icons.edit, size: 20, color: primaryColor),
                  onPressed: () async {
                    finish(context);
                    await RAddNewDoctor(doctorList: widget.data, isUpdate: true).launch(context).then((value) {
                      if (value ?? false) {
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
              RoleWidget(
                isShowReceptionist: true,
                child: IconButton(
                  icon: FaIcon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () async {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      title: locale.lblAreYouWantToDeleteDoctor,
                      onAccept: (p0) {
                        Map<String, dynamic> request = {
                          "doctor_id": widget.data!.iD,
                        };

                        appStore.setLoading(true);

                        deleteDoctor(request).then((value) {
                          toast(locale.lblDoctorDeleted);
                        }).catchError((e) {
                          toast(e.toString());
                        });

                        appStore.setLoading(false);
                      },
                    );
                  },
                ).paddingRight(16),
              ),
            ],
          ).paddingLeft(16),
          Divider(color: viewLineColor, height: 16),
          10.height,
          if (widget.data!.display_name.validate().isNotEmpty)
            DoctorDetailWidget(
              width: context.width(),
              image: ic_user,
              bgColor: appStore.isDarkModeOn ? cardDarkColor : context.cardColor,
              title: locale.lblName,
              subTitle: "${widget.data!.display_name.validate()}",
            ).paddingSymmetric(horizontal: 16),
          10.height,
          if (widget.data!.user_email.validate().isNotEmpty)
            DoctorDetailWidget(
              width: context.width(),
              image: ic_message,
              bgColor: appStore.isDarkModeOn ? cardDarkColor : context.cardColor,
              title: locale.lblEmail,
              subTitle: "${widget.data!.user_email.validate()}",
            ).paddingSymmetric(horizontal: 16),
          10.height,
          Wrap(
            spacing: 10,
            runSpacing: 16,
            children: [
              if (widget.data!.mobile_number.validate().isNotEmpty)
                DoctorDetailWidget(
                  image: ic_phone,
                  bgColor: appStore.isDarkModeOn ? cardDarkColor : context.cardColor,
                  title: locale.lblContact,
                  subTitle: "${widget.data!.mobile_number.validate()}",
                ),
              if (widget.data!.no_of_experience.toString().validate().isNotEmpty)
                DoctorDetailWidget(
                  image: ic_experience,
                  bgColor: appStore.isDarkModeOn ? cardDarkColor : context.cardColor,
                  title: locale.lblExperience,
                  subTitle: "${widget.data!.no_of_experience.toString().validate()} " + locale.lblYearsExperience,
                ),
            ],
          ).paddingOnly(left: 16),
          25.height,
          Text(locale.lblAvailableOn, style: boldTextStyle(size: 16)).paddingSymmetric(horizontal: 16),
          4.height,
          Divider(color: appSecondaryColor.withOpacity(0.4)).visible(widget.data!.available.validate().isNotEmpty),
          widget.data!.available != null ? 16.height : Offstage(),
          widget.data!.available != null
              ? AnimatedWrap(
                  spacing: 16,
                  runSpacing: 10,
                  itemCount: widget.data!.available!.split(",").length,
                  listAnimationType: ListAnimationType.Scale,
                  itemBuilder: (context, index) {
                    return Container(
                      width: context.width() / 4 - 20,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: boxDecorationDefault(color: appStore.isDarkModeOn ? cardDarkColor : appPrimaryColor),
                      child: Text(
                        '${widget.data!.available!.split(",")[index].capitalizeFirstLetter()}',
                        style: primaryTextStyle(color: Colors.white, size: 14),
                      ),
                    );
                  },
                ).paddingOnly(left: 16, right: 16, bottom: 16)
              : NoDataFoundWidget(iconSize: 120).center(),
        ],
      ).paddingBottom(10),
    );
  }
}
