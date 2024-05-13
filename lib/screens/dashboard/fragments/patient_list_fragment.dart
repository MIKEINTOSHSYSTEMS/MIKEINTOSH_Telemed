import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/empty_error_state_component.dart';
import 'package:kivicare_flutter/components/internet_connectivity_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/user_model.dart';
import 'package:kivicare_flutter/network/encounter_repository.dart';
import 'package:kivicare_flutter/network/patient_list_repository.dart';
import 'package:kivicare_flutter/screens/doctor/components/patient_list_component.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/patient/add_patient_screen.dart';
import 'package:kivicare_flutter/screens/shimmer/screen/patient_fragment_shimmer.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/cached_value.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class PatientListFragment extends StatefulWidget {
  @override
  State<PatientListFragment> createState() => _PatientListFragmentBodyComponentState();
}

class _PatientListFragmentBodyComponentState extends State<PatientListFragment> {
  TextEditingController searchCont = TextEditingController();

  List<UserModel> patientList = [];

  Future<List<UserModel>>? future;
  int page = 1;

  bool isLastPage = false;
  bool showClear = false;

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

    future = getPatientListAPI(
      page: page,
      patientList: patientList,
      searchString: searchCont.text,
      lastPageCallback: (b) => isLastPage = b,
    ).then((value) {
      return value;
    }).whenComplete(() {
      if (searchCont.text.isNotEmpty) {
        showClear = true;
      } else {
        showClear = false;
      }
      setState(() {});
      appStore.setLoading(false);
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

  void deletePatient(int patientId, String patientDisplayName) {
    Map<String, dynamic> request = {
      "patient_id": patientId,
    };
    appStore.setLoading(true);
    deletePatientData(request).then((value) {
      toast(value.message);
      init();
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Future<void> _onPressed() async {
    if (appStore.isConnectedToInternet)
      await AddPatientScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then(
        (value) {
          if (value ?? false) {
            init();
          }
        },
      );
    else {
      toast(locale.lblNoInternetMsg);
    }
  }

  bool get showEdit {
    return isVisible(SharedPreferenceKey.kiviCarePatientEditKey);
  }

  bool get showDelete {
    return isVisible(SharedPreferenceKey.kiviCarePatientDeleteKey);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didUpdateWidget(covariant PatientListFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: InternetConnectivityWidget(
        retryCallback: () => setState(() {}),
        child: Observer(
          builder: (_) => Stack(
            fit: StackFit.expand,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: searchCont,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(
                      context: context,
                      hintText: locale.lblSearchPatient,
                      prefixIcon: ic_search.iconImage().paddingAll(16),
                      suffixIcon: !showClear
                          ? Offstage()
                          : ic_clear.iconImage().paddingAll(16).appOnTap(
                              () {
                                _onClearSearch();
                              },
                            ),
                    ),
                    onChanged: (newValue) {
                      if (newValue.isEmpty) {
                        showClear = false;
                        _onClearSearch();
                      } else {
                        Timer(pageAnimationDuration, () {
                          init(showLoader: true);
                        });
                        showClear = true;
                      }
                      setState(() {});
                    },
                    onFieldSubmitted: (searchString) {
                      hideKeyboard(context);
                      init(showLoader: true);
                    },
                  ),
                  8.height,
                  if (showEdit || showDelete) Text(locale.lblNote + " : " + locale.lblSwipeLeftToEdit, style: secondaryTextStyle(size: 10, color: appSecondaryColor)),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: isDoctor() ? 8 : 0),
              SnapHelperWidget<List<UserModel>>(
                future: future,
                initialData: isReceptionist() ? cachedClinicPatient : cachedDoctorPatient,
                loadingWidget: PatientFragmentShimmer(),
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
                  if (snap.isEmpty && !appStore.isLoading) {
                    return SingleChildScrollView(
                      child: NoDataFoundWidget(text: (searchCont.text.isNotEmpty) ? locale.lblCantFindPatientYouSearchedFor : locale.lblNoPatientFound),
                    ).center();
                  }
                  return AnimatedScrollView(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 120),
                    disposeScrollController: true,
                    listAnimationType: ListAnimationType.None,
                    onSwipeRefresh: () async {
                      setState(() {
                        page = 1;
                      });
                      init(showLoader: false);
                      return await 1.seconds.delay;
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
                    children: List.generate(
                      snap.length,
                      (index) => PatientListComponent(
                        patientData: snap[index],
                        refreshCall: () {
                          init();
                        },
                        callDeletePatient: (patientId, patientDisplayName) {
                          ifTester(context, () {
                            deletePatient(patientId, patientDisplayName);
                          }, userEmail: snap[index].userEmail);
                        },
                      ).appOnTap(
                        () async {
                          if (showEdit)
                            await AddPatientScreen(userId: snap[index].iD).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
                              if (value ?? false) {
                                init(showLoader: true);
                              }
                            });
                        },
                      ),
                    ),
                  );
                },
              ).paddingTop(92),
              LoaderWidget().visible(appStore.isLoading).center()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => _onPressed(),
      ).visible(isVisible(SharedPreferenceKey.kiviCarePatientAddKey)),
    );
  }
}
