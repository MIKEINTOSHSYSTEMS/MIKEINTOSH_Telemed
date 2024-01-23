import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_list_model.dart';
import 'package:momona_healthcare/network/doctor_list_repository.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/add_appointment_step3.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/component/doctor_widget.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/component/step_progress_indicator.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class AddAppointmentScreenStep2 extends StatefulWidget {
  @override
  _AddAppointmentScreenStep2State createState() => _AddAppointmentScreenStep2State();
}

class _AddAppointmentScreenStep2State extends State<AddAppointmentScreenStep2> {
  Future<List<DoctorList>>? future;

  List<DoctorList> doctorList = [];

  int page = 1;
  int totalDoctor = 0;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    future = getDoctorListNew(page: page, doctorList: doctorList, getTotalPatient: (p0) => totalDoctor = p0, lastPageCallback: (p0) => isLastPage = p0);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    super.dispose();
  }

  Widget buildBodyWidget() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          Row(
            children: [
              Text(locale.lblChooseYourDoctor, style: boldTextStyle(size: titleTextSize)).expand(),
              16.width,
              StepProgressIndicator(stepTxt: "2/3", percentage: 0.33),
            ],
          ),
          SnapHelperWidget<List<DoctorList>>(
            future: future,
            loadingWidget: LoaderWidget(),
            onSuccess: (snap) {
              return AnimatedListView(
                itemCount: snap.length,
                padding: EdgeInsets.only(bottom: 60),
                shrinkWrap: true,
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    init();
                  }
                },
                itemBuilder: (context, index) {
                  DoctorList data = snap[index];

                  return GestureDetector(
                    onTap: () {
                      if (appointmentAppStore.mDoctorSelected != null ? appointmentAppStore.mDoctorSelected!.iD.validate() == data.iD.validate() : false) {
                        appointmentAppStore.setSelectedDoctor(null);
                      } else {
                        appointmentAppStore.setSelectedDoctor(data);
                      }
                    },
                    child: Observer(builder: (context) {
                      return DoctorWidget(data: data, isSelected: appointmentAppStore.mDoctorSelected != null ? appointmentAppStore.mDoctorSelected!.iD.validate() == data.iD.validate() : false);
                    }),
                  );
                },
              );
            },
          ).paddingTop(80)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: appBarWidget(locale.lblAddNewAppointment, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
          body: buildBodyWidget(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.arrow_forward_outlined),
            onPressed: () {
              if (appointmentAppStore.mDoctorSelected == null)
                toast(locale.lblSelectOneDoctor);
              else {
                AddAppointmentScreenStep3().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              }
            },
          )),
    );
  }
}
