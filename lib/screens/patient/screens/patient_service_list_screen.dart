import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/screens/patient/screens/view_service_detail_screen.dart';
import 'package:momona_healthcare/screens/shimmer/screen/patient_service_list_shimmer_screen.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:momona_healthcare/utils/extensions/widget_extentions.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/network/service_repository.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/screens/patient/components/category_widget.dart';

class PatientServiceListScreen extends StatefulWidget {
  const PatientServiceListScreen({Key? key}) : super(key: key);

  @override
  State<PatientServiceListScreen> createState() => _PatientServiceListScreenState();
}

class _PatientServiceListScreenState extends State<PatientServiceListScreen> {
  Future<List<ServiceData>>? future;

  TextEditingController searchCont = TextEditingController();

  List<ServiceData> serviceList = [];

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
    future = getServiceListWithPaginationAPI(
      page: page,
      serviceList: serviceList,
      searchString: searchCont.text,
      lastPageCallback: (b) => isLastPage = b,
    ).then((value) {
      appStore.setLoading(false);
      if (searchCont.text.isNotEmpty) {
        showClear = true;
      } else {
        showClear = false;
      }
      setState(() {});
      return value;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblServices, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Observer(builder: (context) {
        return Stack(
          fit: StackFit.expand,
          children: [
            AppTextField(
              controller: searchCont,
              textFieldType: TextFieldType.NAME,
              decoration: inputDecoration(
                context: context,
                hintText: locale.lblSearchServices,
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
              onFieldSubmitted: (searchString) async {
                hideKeyboard(context);
                init(showLoader: true);
              },
            ).paddingOnly(left: 16, right: 16, top: 24, bottom: 32),
            SnapHelperWidget<List<ServiceData>>(
              future: future,
              loadingWidget: PatientServiceListShimmerScreen(),
              errorBuilder: (error) {
                return NoDataWidget(
                  imageWidget: Image.asset(ic_somethingWentWrong, height: 180, width: 180),
                  title: error.toString(),
                ).center();
              },
              errorWidget: ErrorStateWidget(),
              onSuccess: (snap) {
                return AnimatedScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  disposeScrollController: true,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 80),
                  listAnimationType: ListAnimationType.None,
                  slideConfiguration: SlideConfiguration(verticalOffset: 400),
                  onSwipeRefresh: () async {
                    setState(() {
                      page = 1;
                    });
                    init(showLoader: false);
                    return await 1.seconds.delay;
                  },
                  onNextPage: () {
                    if (!isLastPage) {
                      setState(() {
                        page++;
                      });
                      init(showLoader: false);
                    }
                  },
                  children: List.generate(groupServicesByCategory(snap).keys.length, (index) {
                    String title = groupServicesByCategory(snap).keys.toList()[index].toString();
                    return SettingSection(
                      title: Text(title.removeAllWhiteSpace().replaceAll('_', ' ').capitalizeEachWord(), style: boldTextStyle()),
                      headingDecoration: BoxDecoration(),
                      headerPadding: EdgeInsets.all(4),
                      divider: 16.height,
                      items: [
                        AnimatedWrap(
                          itemCount: groupServicesByCategory(snap).values.toList()[index].length,
                          spacing: 16,
                          runSpacing: 16,
                          itemBuilder: (context, i) {
                            ServiceData serviceData = groupServicesByCategory(snap).values.toList()[index][i];

                            return GestureDetector(
                              onTap: () {
                                ViewServiceDetailScreen(serviceData: serviceData).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration);
                              },
                              child: CategoryWidget(data: serviceData, hideMoreButton: false),
                            );
                          },
                        ).paddingBottom(24),
                      ],
                    );
                  }),
                ).visible(snap.isNotEmpty,
                    defaultWidget: SingleChildScrollView(
                      child: NoDataFoundWidget(text: searchCont.text.isEmpty ? locale.lblNoServicesFound : locale.lblCantFindServiceYouSearchedFor),
                    ).center().visible(snap.isEmpty && !appStore.isLoading));
              },
            ).paddingTop(90),
            LoaderWidget().visible(appStore.isLoading).center()
          ],
        );
      }),
    );
  }
}

List<ServiceData> getRemovedDuplicateServiceList(List<ServiceData> serviceList) {
  Map<int, bool> uniqueIds = {};
  List<ServiceData> filteredList = [];

  for (ServiceData data in serviceList) {
    int dataId = int.parse(data.id.validate());
    if (!uniqueIds.containsKey(dataId)) {
      uniqueIds[dataId] = true;
      filteredList.add(data);
    }
  }

  return filteredList;
}

Map<String, List<ServiceData>> groupServicesByCategory(List<ServiceData> services) {
  return groupBy(services, (ServiceData e) => e.type.validate());
}
