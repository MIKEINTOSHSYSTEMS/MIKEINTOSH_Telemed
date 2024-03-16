import 'dart:async';

import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/network/doctor_repository.dart';
import 'package:momona_healthcare/screens/receptionist/screens/doctor/add_doctor_screen.dart';
import 'package:momona_healthcare/screens/receptionist/screens/doctor/component/doctor_list_component.dart';
import 'package:momona_healthcare/screens/receptionist/screens/doctor/doctor_details_screen.dart';
import 'package:momona_healthcare/screens/shimmer/screen/doctor_fragment_shimmer.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/cached_value.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DoctorListFragment extends StatefulWidget {
  @override
  _DoctorListFragmentState createState() => _DoctorListFragmentState();
}

class _DoctorListFragmentState extends State<DoctorListFragment> {
  Future<List<UserModel>>? future;

  TextEditingController searchCont = TextEditingController();

  List<UserModel> doctorList = [];

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

    future = getDoctorListWithPagination(
      searchString: searchCont.text,
      doctorList: doctorList,
      clinicId: userStore.userClinicId.validate().toInt(),
      page: page,
      lastPageCallback: (b) => isLastPage = b,
    ).whenComplete(() {
      appStore.setLoading(false);
      if (searchCont.text.isNotEmpty) {
        showClear = true;
      } else {
        showClear = false;
      }
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
      throw e;
    });
  }

  Future<void> _onClearSearch() async {
    searchCont.clear();
    hideKeyboard(context);
    init(showLoader: true);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (isPatient()) getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isReceptionist()
          ? null
          : appBarWidget(
              locale.lblClinicDoctor,
              textColor: Colors.white,
              systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
            ),
      body: Stack(
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
                  hintText: locale.lblSearchDoctor,
                  prefixIcon: ic_search.iconImage().paddingAll(16),
                  suffixIcon: !showClear
                      ? Offstage()
                      : ic_clear.iconImage().paddingAll(16).appOnTap(
                          () async {
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
            ],
          ).paddingOnly(left: 16, right: 16, bottom: 16, top: isReceptionist() ? 0 : 16),
          SnapHelperWidget<List<UserModel>>(
            future: future,
            initialData: cachedDoctorList,
            loadingWidget: DoctorShimmerFragment().paddingTop(16),
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
              return AnimatedScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                disposeScrollController: true,
                padding: EdgeInsets.fromLTRB(16, isPatient() ? 16 : 0, 16, 140),
                listAnimationType: ListAnimationType.None,
                slideConfiguration: SlideConfiguration(verticalOffset: 400),
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
                    init(showLoader: false);
                    return await 1.seconds.delay;
                  }
                },
                children: [
                  AnimatedWrap(
                    runSpacing: 16,
                    listAnimationType: listAnimationType,
                    itemCount: snap.validate().length,
                    itemBuilder: (context, index) => DoctorListComponent(
                      data: snap.validate()[index],
                      callForRefreshAfterDelete: () {
                        init();
                      },
                    ).appOnTap(
                      () {
                        DoctorDetailScreen(
                          doctorData: snap.validate()[index],
                          refreshCall: () {
                            init();
                          },
                        ).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then(
                          (isDoctorDeleted) {
                            if (isDoctorDeleted ?? false) {
                              init();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ).visible(
                snap.isNotEmpty,
                defaultWidget: SingleChildScrollView(
                  child: NoDataFoundWidget(text: searchCont.text.isEmpty ? locale.lblNoDataFound : locale.lblCantFindDoctorYouSearchedFor),
                ).center().visible(snap.isEmpty && !appStore.isLoading),
              );
            },
          ).paddingTop(74),
          LoaderWidget().visible(appStore.isLoading).center()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await AddDoctorScreen().launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then(
            (value) {
              if (value ?? false) {
                init();
              }
            },
          );
        },
      ).visible(isVisible(SharedPreferenceKey.kiviCareDoctorAddKey)),
    );
  }
}
