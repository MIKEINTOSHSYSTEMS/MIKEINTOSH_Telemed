import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/components/view_all_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_dashboard_model.dart';
import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/model/patient_dashboard_model.dart';
import 'package:kivicare_flutter/network/dashboard_repository.dart';
import 'package:kivicare_flutter/screens/patient/components/category_widget.dart';
import 'package:kivicare_flutter/screens/patient/components/common_appointment_widget.dart';
import 'package:kivicare_flutter/screens/patient/components/doctor_dashboard_widget.dart';
import 'package:kivicare_flutter/screens/patient/components/news_dashboard_widget.dart';
import 'package:kivicare_flutter/screens/patient/models/news_model.dart';
import 'package:kivicare_flutter/screens/patient/screens/doctor_list_screen.dart';
import 'package:kivicare_flutter/screens/patient/screens/services_screen.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientDashBoardFragment extends StatefulWidget {
  @override
  _PatientDashBoardFragmentState createState() => _PatientDashBoardFragmentState();
}

class _PatientDashBoardFragmentState extends State<PatientDashBoardFragment> {
  double secSpace = 32;

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
  void dispose() {
    super.dispose();
  }

  Widget buildUpcomingAppointmentWidget({required List<UpcomingAppointment> upcomingAppointment}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: locale.lblUpcomingAppointments,
          list: upcomingAppointment.validate(),
          viewAllShowLimit: 2,
        ),
        24.height,
        Wrap(
          runSpacing: 16,
          children: upcomingAppointment.take(2).map((UpcomingAppointment data) {
            return CommonAppointmentWidget(upcomingData: data, index: upcomingAppointment.indexOf(data));
          }).toList(),
        ).visible(
          upcomingAppointment.isNotEmpty,
          defaultWidget: NoDataFoundWidget(text: locale.lblNoUpcomingAppointments).center(),
        ),
      ],
    );
  }

  Widget buildDoctorServiceWidget({required List<Service> service}) {
    if (service.isEmpty) return Offstage();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: locale.lblClinicServices,
          list: service.validate(),
          viewAllShowLimit: 8,
          onTap: () {
            ServicesScreen(servicesList: service).launch(context);
          },
        ),
        16.height,
        AnimatedWrap(
          spacing: 16,
          runSpacing: 16,
          direction: Axis.horizontal,
          itemCount: service.length,
          listAnimationType: ListAnimationType.Scale,
          itemBuilder: (context, index) {
            return CategoryWidget(data: service[index], width: context.width() / 4 - 22, index: index);
          },
        ),
      ],
    );
  }

  Widget buildTopDoctorWidget({required List<DoctorList> doctorList}) {
    if (doctorList.isEmpty) return Offstage();

    return Column(
      children: [
        ViewAllLabel(
          label: locale.lblTopDoctors,
          list: doctorList.validate(),
          viewAllShowLimit: 0,
          onTap: () {
            DoctorListScreen().launch(context);
          },
        ),
        Wrap(
          runSpacing: 8,
          spacing: 16,
          children: doctorList.map((e) => DoctorDashboardWidget(data: e)).take(2).toList(),
        ),
      ],
    );
  }

  Widget newsComponent({required List<NewsData> newsData}) {
    if (newsData.isEmpty) return Offstage();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: locale.lblExpertsHealthTipsAndAdvice,
          subLabel: locale.lblArticlesByHighlyQualifiedDoctors,
          list: newsData.validate(),
          viewAllShowLimit: 2,
          onTap: () {
            patientStore.setBottomNavIndex(2);
          },
        ),
        16.height,
        Wrap(
          runSpacing: 16,
          spacing: 16,
          children: List.generate(
            newsData.take(3).length,
            (index) => NewsDashboardWidget(newsData: newsData[index], index: index),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PatientDashboardModel>(
      future: getPatientDashBoard(),
      builder: (context, snap) {
        if (snap.hasData) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Wrap(
              runSpacing: secSpace,
              children: [
                buildUpcomingAppointmentWidget(upcomingAppointment: snap.data!.upcoming_appointment.validate()),
                buildDoctorServiceWidget(service: snap.data!.serviceList.validate()),
                buildTopDoctorWidget(doctorList: snap.data!.doctor.validate()),
                newsComponent(newsData: snap.data!.news.validate()),
              ],
            ),
          );
        }
        return snapWidgetHelper(snap, loadingWidget: LoaderWidget());
      },
    );
  }
}
