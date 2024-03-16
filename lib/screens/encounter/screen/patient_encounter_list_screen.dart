import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/empty_error_state_component.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/no_data_found_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/encounter_model.dart';
import 'package:momona_healthcare/model/user_model.dart';
import 'package:momona_healthcare/network/encounter_repository.dart';
import 'package:momona_healthcare/screens/shimmer/screen/encounter_shimmer_screen.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:momona_healthcare/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:momona_healthcare/screens/encounter/screen/add_encounter_screen.dart';
import 'package:momona_healthcare/screens/encounter/component/encounter_list_component.dart';

class PatientEncounterListScreen extends StatefulWidget {
  final UserModel? patientData;

  PatientEncounterListScreen({this.patientData});

  @override
  _PatientEncounterListScreenState createState() => _PatientEncounterListScreenState();
}

class _PatientEncounterListScreenState extends State<PatientEncounterListScreen> {
  Future<List<EncounterModel>>? future;

  List<EncounterModel> patientEncounterList = [];

  int total = 0;
  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init({bool showLoader = false}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }

    future = getPatientEncounterList(
      id: widget.patientData!.iD,
      page: page,
      encounterList: patientEncounterList,
      getTotalPatient: (b) => total = b,
      lastPageCallback: (b) => isLastPage = b,
    ).whenComplete(() {
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      throw e;
    });
  }

  bool get isEdit {
    return isVisible(SharedPreferenceKey.kiviCarePatientEncounterEditKey);
  }

  bool get isDelete {
    return isVisible(SharedPreferenceKey.kiviCarePatientEncounterDeleteKey);
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
      appBar: appBarWidget(
        widget.patientData!.displayName.validate().capitalizeEachWord() + " " + locale.lblEncounters,
        textColor: Colors.white,
        elevation: 0,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Stack(
        children: [
          SnapHelperWidget<List<EncounterModel>>(
            future: future,
            loadingWidget: EncounterShimmerScreen(),
            errorBuilder: (error) {
              return ErrorStateWidget(
                error: error.toString(),
              );
            },
            onSuccess: (snap) {
              if (snap.isEmpty) return NoDataFoundWidget(text: locale.lblNoEncounterFoundAtYourClinic);
              return AnimatedScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                disposeScrollController: true,
                listAnimationType: listAnimationType,
                slideConfiguration: SlideConfiguration(verticalOffset: 400),
                onSwipeRefresh: () async {
                  setState(() {
                    page = 1;
                  });
                  init();
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
                children: [
                  16.height,
                  if (isEdit || isDelete) Text(locale.lblNote.suffixText(value: ' : ') + locale.lblSwipeMassage, style: secondaryTextStyle(size: 10, color: appSecondaryColor)).paddingOnly(left: 20),
                  8.height,
                  AnimatedListView(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snap.length,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 80),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      EncounterModel data = snap[index];
                      return GestureDetector(
                        onTap: () {
                          if (isEdit)
                            AddEncounterScreen(patientEncounterData: data, patientId: data.patientId.toInt())
                                .launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration)
                                .then((value) {
                              if (value ?? false) {
                                init();
                              }
                            });
                        },
                        child: EncounterListComponent(
                          data: data,
                          patientData: widget.patientData,
                          refreshCall: () {
                            init(showLoader: true);
                          },
                        ).paddingSymmetric(vertical: 8),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading).center())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await AddEncounterScreen(patientId: widget.patientData!.iD).launch(context, pageRouteAnimation: pageAnimation, duration: pageAnimationDuration).then((value) {
            if (value ?? false) {
              init(showLoader: true);
            }
          });
        },
      ),
    );
  }
}
