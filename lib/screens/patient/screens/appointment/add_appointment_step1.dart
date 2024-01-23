import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/login_response_model.dart';
import 'package:momona_healthcare/network/clinic_repository.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/add_appointment_step2.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/add_appointment_step3.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/component/clinic_widget.dart';
import 'package:momona_healthcare/screens/patient/screens/appointment/component/step_progress_indicator.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class AddAppointmentScreenStep1 extends StatefulWidget {
  @override
  _AddAppointmentScreenStep1State createState() => _AddAppointmentScreenStep1State();
}

class _AddAppointmentScreenStep1State extends State<AddAppointmentScreenStep1> {
  Future<List<Clinic>>? future;

  List<Clinic> clinicList = [];

  int page = 1;
  int totalClinic = 0;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    future = getClinicListNew(page: page, appointmentList: clinicList, getTotalPatient: (p0) => totalClinic = p0, lastPageCallback: (p0) => isLastPage = p0);
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBodyWidget() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Row(
            children: [
              Text(locale.lblChooseYourClinic, style: boldTextStyle(size: titleTextSize)).expand(),
              16.width,
              StepProgressIndicator(stepTxt: "1/3", percentage: 0.33),
            ],
          ),
          SnapHelperWidget<List<Clinic>>(
            future: future,
            loadingWidget: LoaderWidget(),
            onSuccess: (snap) {
              return AnimatedListView(
                itemCount: snap.length,
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    init();
                  }
                },
                padding: EdgeInsets.only(bottom: 60),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Clinic data = snap[index];

                  return GestureDetector(
                    onTap: () {
                      if (appointmentAppStore.mClinicSelected != null ? appointmentAppStore.mClinicSelected!.clinic_id.validate() == data.clinic_id.validate() : false) {
                        appointmentAppStore.setSelectedClinic(null);
                      } else {
                        appointmentAppStore.setSelectedClinic(data);
                      }
                    },
                    child: Observer(
                      builder: (context) {
                        return ClinicWidget(data: data, isSelected: appointmentAppStore.mClinicSelected != null ? appointmentAppStore.mClinicSelected!.clinic_id.validate() == data.clinic_id.validate() : false);
                      },
                    ),
                  );
                },
              );
            },
          ).paddingTop(80),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblAddNewAppointment, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context), textColor: Colors.white),
      body: buildBodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_outlined),
        onPressed: () {
          if (appointmentAppStore.mClinicSelected == null)
            toast(locale.lblSelectOneClinic);
          else {
            if (appStore.isBookedFromDashboard) {
              AddAppointmentScreenStep3().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            } else {
              AddAppointmentScreenStep2().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            }
          }
        },
      ),
    );
  }
}
