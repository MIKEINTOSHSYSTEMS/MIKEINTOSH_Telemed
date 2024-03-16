import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/components/view_all_widget.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/screens/patient/components/category_widget.dart';
import 'package:momona_healthcare/screens/patient/screens/patient_service_list_screen.dart';

import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/screens/patient/screens/view_service_detail_screen.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardFragmentDoctorServiceComponent extends StatelessWidget {
  final List<ServiceData> service;
  DashboardFragmentDoctorServiceComponent({required this.service});

  @override
  Widget build(BuildContext context) {
    if (service.isEmpty) return NoDataFoundWidget(text: locale.lblNoServicesFound);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: locale.lblClinicServices,
          list: service,
          viewAllShowLimit: 3,
          onTap: () {
            PatientServiceListScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
          },
        ).paddingSymmetric(horizontal: 16, vertical: 8),
        HorizontalList(
          spacing: 16,
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          itemCount: service.take(4).toList().length,
          itemBuilder: (context, index) {
            ServiceData serviceData = service[index];

            return GestureDetector(
              onTap: () {
                ViewServiceDetailScreen(serviceData: serviceData).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
              },
              child: CategoryWidget(data: serviceData),
            );
          },
        ),
      ],
    );
  }
}
