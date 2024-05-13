import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/clinic_list_model.dart';
import 'package:kivicare_flutter/network/clinic_repository.dart';
import 'package:kivicare_flutter/screens/appointment/components/clinic_list_component.dart';
import 'package:kivicare_flutter/screens/shimmer/components/clinic_shimmer_component.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/extensions/widget_extentions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class MultiSelectClinicDropDown extends StatefulWidget {
  final List<int>? selectedClinicIds;
  final int? selectedClinicId;

  final Function(List<Clinic> selectedDoctor)? onSubmit;

  MultiSelectClinicDropDown({this.selectedClinicIds, this.selectedClinicId, this.onSubmit});

  @override
  _MultiSelectClinicDropDownState createState() => _MultiSelectClinicDropDownState();
}

class _MultiSelectClinicDropDownState extends State<MultiSelectClinicDropDown> {
  Future<List<Clinic>>? future;

  TextEditingController searchCont = TextEditingController();
  List<Clinic> clinicList = [];

  int page = 1;
  int selectedIndex = -1;

  bool isLastPage = false;
  bool isFirst = true;
  bool showClear = false;
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init(showLoader: false);
  }

  Future<void> init({bool showLoader = true}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }
    isUpdate = widget.selectedClinicId != null;
    future = getClinicListAPI(
      page: page,
      clinicList: clinicList,
      searchString: searchCont.text,
      lastPageCallback: (p0) => isLastPage = p0,
    ).then((value) {
      if (isUpdate) {
        selectedIndex = value.indexWhere((element) => element.id.toInt() == widget.selectedClinicId);
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
      appBar: appBarWidget(locale.lblSelectClinic, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Observer(builder: (context) {
        return Stack(
          children: [
            AppTextField(
              controller: searchCont,
              textFieldType: TextFieldType.NAME,
              decoration: inputDecoration(
                context: context,
                hintText: locale.lblSearchClinic,
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
            SnapHelperWidget<List<Clinic>>(
              future: future,
              loadingWidget: AnimatedWrap(
                runSpacing: 16,
                spacing: 16,
                listAnimationType: listAnimationType,
                children: List.generate(
                  4,
                  (index) => ClinicShimmerComponent(),
                ),
              ),
              onSuccess: (snap) {
                if (!isUpdate) {
                  if (widget.selectedClinicIds != null && isFirst) {
                    snap.forEach((element) {
                      if (widget.selectedClinicIds!.contains(element.id.toInt())) {
                        element.isCheck = true;
                      }
                    });
                    isFirst = false;
                  }
                }

                if (snap.isEmpty && !appStore.isLoading) {
                  return SingleChildScrollView(child: NoDataFoundWidget(text: searchCont.text.isEmpty ? locale.lblNoDataFound : locale.lblCantFindClinicYouSearchedFor)).center();
                }

                return AnimatedListView(
                  itemCount: snap.length,
                  padding: EdgeInsets.only(bottom: 90),
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  onNextPage: () async {
                    if (!isLastPage) {
                      setState(() {
                        page++;
                        isFirst = true;
                      });
                      init();
                      await 1.seconds.delay;
                    }
                  },
                  onSwipeRefresh: () async {
                    setState(() {
                      page = 1;
                    });
                    init(showLoader: false);
                    await 1.seconds.delay;
                  },
                  itemBuilder: (context, index) {
                    Clinic clinicData = snap[index];

                    return GestureDetector(
                      onTap: () {
                        if (isUpdate) {
                          selectedIndex = index;
                        } else {
                          clinicData.isCheck = !clinicData.isCheck.validate();
                        }
                        setState(() {});
                      },
                      child: ClinicListComponent(
                        data: clinicData,
                        isSelected: isUpdate ? selectedIndex == index : clinicData.isCheck.validate(),
                      ),
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
          if (!isUpdate)
            widget.onSubmit?.call(clinicList.where((element) => element.isCheck == true).toList());
          else
            widget.onSubmit?.call([clinicList[selectedIndex]]);
          finish(context);
        },
      ),
    );
  }
}
