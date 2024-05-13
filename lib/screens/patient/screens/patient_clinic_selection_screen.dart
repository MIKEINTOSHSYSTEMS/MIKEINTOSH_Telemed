import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/empty_error_state_component.dart';
import 'package:kivicare_flutter/components/internet_connectivity_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/screens/patient/components/clinic_component.dart';
import 'package:kivicare_flutter/screens/shimmer/screen/switch_clinic_shimmer_screen.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/clinic_list_model.dart';
import 'package:kivicare_flutter/network/clinic_repository.dart';
import 'package:kivicare_flutter/utils/app_common.dart';

class PatientClinicSelectionScreen extends StatefulWidget {
  final VoidCallback? callback;
  final bool? isForRegistration;
  final int? clinicId;

  PatientClinicSelectionScreen({this.callback, this.isForRegistration, this.clinicId});

  @override
  _PatientClinicSelectionScreenState createState() => _PatientClinicSelectionScreenState();
}

class _PatientClinicSelectionScreenState extends State<PatientClinicSelectionScreen> {
  Future<List<Clinic>>? future;

  List<Clinic> clinicList = [];

  Clinic? selectedClinic;

  int page = 1;

  int selectedIndex = -1;

  bool isLastPage = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getClinicListAPI(
      page: page,
      clinicList: clinicList,
      isAuthRequired: !widget.isForRegistration.validate(),
      lastPageCallback: (p0) => isLastPage = p0,
    ).then((value) {
      if (widget.clinicId != null) {
        selectedIndex = value.indexWhere((element) => element.id.validate().toInt() == widget.clinicId);
      } else {
        if (userStore.userClinicId.validate().isNotEmpty) selectedIndex = value.indexWhere((element) => element.id.validate() == userStore.userClinicId);
      }
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  Future<void> switchFavouriteClinic(int selectedClinicId, int newIndex) async {
    int originalIndex = selectedIndex;
    selectedIndex = newIndex;
    setState(() {});

    showConfirmDialogCustom(
      context,
      dialogType: DialogType.CONFIRMATION,
      title: locale.lblDoYouWantToSwitchYourClinicTo,
      onCancel: (p0) {
        selectedIndex = originalIndex;
        setState(() {});
      },
      onAccept: (_) async {
        appStore.setLoading(true);
        Map<String, dynamic> req = {'clinic_id': selectedClinicId};

        try {
          var value = await switchClinicApi(req: req);
          toast(value['message']);
          appStore.setLoading(false);
          if (value['status'] == true) {
            widget.callback?.call();
            userStore.setClinicId(selectedClinicId.toString());
            getSelectedClinicAPI(clinicId: userStore.userClinicId.validate()).then((value) {
              userStore.setUserClinicImage(value.profileImage.validate(), initialize: true);
              userStore.setUserClinicName(value.name.validate(), initialize: true);
              userStore.setUserClinicStatus(value.status.validate(), initialize: true);
              String clinicAddress = '';

              if (value.city.validate().isNotEmpty) {
                clinicAddress = value.city.validate();
              }
              if (value.country.validate().isNotEmpty) {
                clinicAddress += ' ,' + value.country.validate();
              }
              userStore.setUserClinicAddress(clinicAddress, initialize: true);
            });
          } else {
            selectedIndex = originalIndex;
          }
          setState(() {});
        } catch (e) {
          selectedIndex = originalIndex;
          setState(() {});
          toast(e.toString());
        } finally {
          appStore.setLoading(false);
        }
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        widget.isForRegistration ?? false ? locale.lblSelectOneClinic.capitalizeEachWord() : locale.lblMyClinic,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        elevation: 0,
        color: appPrimaryColor,
      ),
      body: InternetConnectivityWidget(
        retryCallback: () => setState(() {}),
        child: Stack(
          children: [
            SnapHelperWidget<List<Clinic>>(
              future: future,
              errorBuilder: (error) {
                return NoDataWidget(
                  imageWidget: Image.asset(ic_somethingWentWrong, height: 180, width: 180),
                  title: error.toString(),
                );
              },
              errorWidget: ErrorStateWidget(),
              loadingWidget: SwitchClinicShimmerScreen(),
              onSuccess: (snap) {
                return AnimatedScrollView(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
                  listAnimationType: ListAnimationType.None,
                  children: [
                    AnimatedWrap(
                      spacing: 16,
                      runSpacing: 16,
                      itemCount: snap.length,
                      itemBuilder: (p0, index) {
                        return ClinicComponent(
                          clinicData: snap[index],
                          isCheck: selectedIndex == index,
                          onTap: (isCheck) async {
                            if (widget.isForRegistration ?? false) {
                              setState(() {
                                selectedIndex = index;
                                selectedClinic = snap[selectedIndex];
                              });
                            } else
                              await switchFavouriteClinic(snap[index].id.validate().toInt(), index);
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)).center()
          ],
        ),
      ),
      floatingActionButton: widget.isForRegistration.validate()
          ? FloatingActionButton(
              child: Icon(Icons.done),
              onPressed: () {
                finish(context, selectedClinic);
              },
            )
          : Offstage(),
    );
  }
}
