import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/network/doctor_repository.dart';
import 'package:momona_healthcare/screens/appointment/appointment_functions.dart';
import 'package:momona_healthcare/screens/receptionist/screens/doctor/component/doctor_list_component.dart';
import 'package:momona_healthcare/screens/shimmer/components/doctor_shimmer_component.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class Step2DoctorSelectionScreen extends StatefulWidget {
  final int? clinicId;
  final bool isForAppointment;
  final int? doctorId;

  Step2DoctorSelectionScreen({this.clinicId, this.isForAppointment = false, this.doctorId});

  @override
  _Step2DoctorSelectionScreenState createState() => _Step2DoctorSelectionScreenState();
}

class _Step2DoctorSelectionScreenState extends State<Step2DoctorSelectionScreen> {
  Future<List<UserModel>>? future;

  TextEditingController searchCont = TextEditingController();

  List<UserModel> doctorList = [];

  bool isLastPage = false;
  bool showClear = false;

  int page = 1;

  @override
  void initState() {
    super.initState();
    if (appStore.isLoading) {
      appStore.setLoading(false);
    }
    init(showLoader: false);
  }

  Future<void> init({bool showLoader = true}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }

    future = getDoctorListWithPagination(
      searchString: searchCont.text,
      clinicId: widget.clinicId,
      doctorList: doctorList,
      page: page,
      lastPageCallback: (b) => isLastPage = b,
    ).then((value) {
      if (value.validate().isNotEmpty) {
        listAppStore.addDoctor(value);
      }
      if (searchCont.text.isNotEmpty) {
        showClear = true;
      } else {
        showClear = false;
      }
      setState(() {});
      appStore.setLoading(false);
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
      throw e;
    });
  }

  Future<void> _onClearSearch() async {
    hideKeyboard(context);
    searchCont.clear();

    init(showLoader: true);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    appointmentAppStore.setSelectedDoctor(null);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        !widget.isForAppointment.validate() ? locale.lblSelectDoctor : locale.lblAddNewAppointment,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Observer(builder: (context) {
        return Stack(
          children: [
            if (widget.isForAppointment)
              Column(
                children: [
                  AppTextField(
                    controller: searchCont,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(
                      context: context,
                      hintText: locale.lblSearchDoctor,
                      prefixIcon: ic_search.iconImage().paddingAll(16),
                      suffixIcon: showClear
                          ? ic_clear.iconImage().paddingAll(16).appOnTap(
                              () async {
                                _onClearSearch();
                              },
                            )
                          : Offstage(),
                    ),
                    onChanged: (newValue) {
                      if (newValue.isEmpty) {
                        showClear = false;
                        _onClearSearch();
                      } else {
                        Timer(Duration(milliseconds: 500), () {
                          init(showLoader: true);
                        });
                        showClear = true;
                      }
                      setState(() {});
                    },
                    onFieldSubmitted: (searchString) async {
                      hideKeyboard(context);
                      init(showLoader: true);
                    },
                  ),
                  16.height,
                  stepCountWidget(
                    name: locale.lblChooseYourDoctor,
                    currentCount: isPatient() ? 2 : 1,
                    totalCount: isReceptionist() ? 2 : 3,
                    percentage: isPatient() ? 0.66 : 0.50,
                  ),
                ],
              ).paddingSymmetric(vertical: 8),
            SnapHelperWidget<List<UserModel>>(
              future: future,
              loadingWidget: AnimatedWrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  4,
                  (index) => DoctorShimmerComponent(),
                ),
              ),
              errorBuilder: (error) {
                return NoDataWidget(
                  imageWidget: Image.asset(
                    ic_somethingWentWrong,
                    height: 180,
                    width: 180,
                  ),
                  title: error.toString(),
                );
              },
              errorWidget: ErrorStateWidget(),
              onSuccess: (snap) {
                snap.retainWhere((element) => element.userStatus.toInt() == ACTIVE_USER_INT_STATUS);
                if (snap.isEmpty && !appStore.isLoading) {
                  return SingleChildScrollView(
                    child: NoDataFoundWidget(
                      text: searchCont.text.isEmpty ? locale.lblNoActiveDoctorAvailable : locale.lblCantFindDoctorYouSearchedFor,
                    ),
                  ).center();
                }

                return AnimatedListView(
                  itemCount: snap.length,
                  padding: EdgeInsets.only(bottom: 80),
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  onSwipeRefresh: () async {
                    setState(() {
                      page = 1;
                    });
                    init(showLoader: false);
                    await 1.seconds.delay;
                  },
                  onNextPage: () async {
                    if (!isLastPage) {
                      setState(() {
                        page++;
                      });
                      init(showLoader: true);
                      await 1.seconds.delay;
                    }
                  },
                  itemBuilder: (context, index) {
                    UserModel data = snap[index];
                    if (widget.doctorId != null && data.iD == widget.doctorId) {
                      appointmentAppStore.setSelectedDoctor(data);
                    }

                    return GestureDetector(
                      onTap: () {
                        if (appointmentAppStore.mDoctorSelected != null ? appointmentAppStore.mDoctorSelected!.iD.validate() == data.iD.validate() : false) {
                          appointmentAppStore.setSelectedDoctor(null);
                        } else {
                          appointmentAppStore.setSelectedDoctor(data);
                        }
                      },
                      child: Observer(builder: (context) {
                        return DoctorListComponent(data: data, isSelected: appointmentAppStore.mDoctorSelected?.iD.validate() == data.iD.validate()).paddingSymmetric(vertical: 8);
                      }),
                    );
                  },
                );
              },
            ).paddingTop(widget.isForAppointment ? 142 : 0),
            LoaderWidget().visible(appStore.isLoading).center()
          ],
        ).paddingOnly(left: 16, right: 16, top: 16);
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(widget.isForAppointment ? Icons.arrow_forward_outlined : Icons.done),
        onPressed: () {
          if (appointmentAppStore.mDoctorSelected == null) {
            toast(locale.lblSelectOneDoctor);
          } else {
            if (!widget.isForAppointment.validate())
              finish(context, appointmentAppStore.mDoctorSelected);
            else
              doctorNavigation(
                context,
                clinicId: widget.clinicId.validate().toInt(),
                doctorId: appointmentAppStore.mDoctorSelected!.iD.validate(),
              ).then((value) {});
          }
        },
      ),
    );
  }
}
