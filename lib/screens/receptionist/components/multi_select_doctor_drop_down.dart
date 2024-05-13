import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/user_model.dart';
import 'package:kivicare_flutter/screens/receptionist/screens/doctor/component/doctor_list_component.dart';
import 'package:kivicare_flutter/screens/shimmer/components/doctor_shimmer_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_flutter/network/doctor_repository.dart';

class MultiSelectDoctorDropDown extends StatefulWidget {
  final int? clinicId;
  final List<int>? selectedDoctorsId;

  final Function(int)? refreshMappingTableIdsList;

  final Function(List<UserModel> selectedDoctor)? onSubmit;

  MultiSelectDoctorDropDown({this.clinicId, this.refreshMappingTableIdsList, this.selectedDoctorsId, this.onSubmit});

  @override
  _MultiSelectDoctorDropDownState createState() => _MultiSelectDoctorDropDownState();
}

class _MultiSelectDoctorDropDownState extends State<MultiSelectDoctorDropDown> {
  Future<List<UserModel>>? future;

  TextEditingController searchCont = TextEditingController();
  List<UserModel> doctorList = [];

  int page = 1;

  bool isLastPage = false;
  bool isFirst = true;
  bool showClear = false;

  @override
  void initState() {
    super.initState();
    init(showLoader: false);
  }

  Future<void> init({bool showLoader = true, String? searchString}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }

    future = getDoctorListWithPagination(
      clinicId: widget.clinicId,
      doctorList: doctorList,
      searchString: searchCont.text,
      page: page,
      lastPageCallback: (b) => isLastPage = b,
    ).then((value) {
      appStore.setLoading(false);
      doctorList = value;
      return value;
    }).whenComplete(() {
      if (searchCont.text.isNotEmpty) {
        showClear = true;
      } else {
        showClear = false;
      }
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
      throw e;
    });
  }

  Future<void> _onSearchClear() async {
    hideKeyboard(context);

    searchCont.clear();
    init();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblSelectDoctor, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Observer(builder: (context) {
        return Stack(
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
                          _onSearchClear();
                        },
                      ),
              ),
              onChanged: (newValue) {
                if (newValue.isEmpty) {
                  showClear = false;
                  _onSearchClear();
                } else {
                  Timer(pageAnimationDuration, () {
                    init();
                  });
                  showClear = true;
                }
                setState(() {});
              },
              onFieldSubmitted: (searchString) {
                hideKeyboard(context);
                init();
              },
            ).paddingOnly(left: 16, right: 16, top: 16),
            SnapHelperWidget<List<UserModel>>(
              future: future,
              loadingWidget: AnimatedWrap(
                runSpacing: 16,
                spacing: 16,
                children: List.generate(
                  4,
                  (index) => DoctorShimmerComponent(),
                ),
              ),
              onSuccess: (snap) {
                snap.forEach((element) {
                  element.firstName = element.displayName.validate().split(' ').first;
                  element.lastName = element.displayName.validate().split(' ').last;
                  element.doctorId = element.iD.toString();
                  element.userId = element.iD;
                });

                if (widget.selectedDoctorsId != null && isFirst) {
                  snap.forEach((element) {
                    if (widget.selectedDoctorsId!.contains(element.iD)) {
                      element.isCheck = true;
                    }
                  });
                  isFirst = false;
                }

                if (snap.isEmpty && !appStore.isLoading) {
                  return SingleChildScrollView(child: NoDataFoundWidget(text: searchCont.text.isEmpty ? locale.lblNoDataFound : locale.lblCantFindDoctorYouSearchedFor)).center();
                }

                return AnimatedListView(
                  itemCount: snap.length,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 90),
                  onNextPage: () {
                    if (!isLastPage) {
                      setState(() {
                        page++;
                      });
                      init();
                    }
                  },
                  onSwipeRefresh: () async {
                    setState(() {
                      page = 1;
                      isFirst = true;
                    });
                    init(showLoader: false);

                    await 1.seconds.delay;
                  },
                  itemBuilder: (context, index) {
                    UserModel userData = snap[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          userData.isCheck = !userData.isCheck;
                        });
                        if (userData.isCheck == false) {
                          widget.refreshMappingTableIdsList?.call(userData.doctorId.toInt());
                        }
                      },
                      child: DoctorListComponent(
                        data: userData,
                        isSelected: userData.isCheck,
                      ).paddingSymmetric(vertical: 8),
                    );
                  },
                );
              },
            ).paddingOnly(left: 16, right: 16, top: 80),
            LoaderWidget().visible(appStore.isLoading).center()
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          widget.onSubmit!.call(doctorList.where((element) => element.isCheck == true).toList());
          finish(context);
        },
      ),
    );
  }
}
