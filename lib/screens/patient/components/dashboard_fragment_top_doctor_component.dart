import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/components/view_all_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/user_model.dart';
import 'package:kivicare_flutter/screens/dashboard/fragments/doctor_list_fragment.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/doctor/component/doctor_list_component.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/doctor/doctor_details_screen.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DashBoardFragmentTopDoctorComponent extends StatelessWidget {
  final List<UserModel> doctorList;

  DashBoardFragmentTopDoctorComponent({required this.doctorList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewAllLabel(
          label: locale.lblTopDoctors,
          list: doctorList.validate(),
          viewAllShowLimit: 3,
          onTap: () => DoctorListFragment().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration),
        ),
        if (doctorList.isNotEmpty) 4.height,
        if (doctorList.isNotEmpty)
          Wrap(
            runSpacing: 16,
            spacing: 16,
            children: doctorList
                .map((data) {
                  return GestureDetector(
                    onTap: () {
                      DoctorDetailScreen(doctorData: data).launch(context, pageRouteAnimation: PageRouteAnimation.Fade, duration: 800.milliseconds);
                    },
                    child: DoctorListComponent(data: data),
                  );
                })
                .take(2)
                .toList(),
          ).visible(doctorList.isNotEmpty, defaultWidget: NoDataFoundWidget(text: locale.lblNoDataFound, iconSize: 60).center()),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
