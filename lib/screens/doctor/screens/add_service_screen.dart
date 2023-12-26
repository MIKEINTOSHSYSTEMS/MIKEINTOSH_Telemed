import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/components/role_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/model/service_model.dart';
import 'package:kivicare_flutter/model/static_data_model.dart';
import 'package:kivicare_flutter/network/dashboard_repository.dart';
import 'package:kivicare_flutter/network/service_repository.dart';
import 'package:kivicare_flutter/screens/receptionist/components/multi_select_doctor_drop_down.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class AddServiceScreen extends StatefulWidget {
  final ServiceData? serviceData;

  AddServiceScreen({this.serviceData});

  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  AsyncMemoizer<StaticDataModel> _memorizer = AsyncMemoizer();

  ServiceData? serviceData;

  StaticData? category;

  bool isUpdate = false;

  int? serviceStatus = 1;

  List<int> status = [0, 1];
  List<int?> selectedDoctorId = [];

  List<DoctorList?> selectedDoctorList = [];

  TextEditingController serviceNameCont = TextEditingController();
  TextEditingController serviceChargesCont = TextEditingController();
  TextEditingController doctorCont = TextEditingController();

  FocusNode serviceCategoryFocus = FocusNode();
  FocusNode serviceNameFocus = FocusNode();
  FocusNode serviceChargesFocus = FocusNode();
  FocusNode serviceStatusFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.serviceData != null;
    if (isUpdate) {
      serviceData = widget.serviceData;
      serviceNameCont.text = serviceData!.name!;
      serviceChargesCont.text = serviceData!.charges!;
      serviceStatus = serviceData!.status.toInt();

      listAppStore.doctorList.forEach(
        (element) {
          if (element!.iD!.toInt() == serviceData!.doctor_id.toInt()) {
            selectedDoctorId.add(element.iD);
            selectedDoctorList.add(element);
          }
        },
      );
    }
  }

  void deleteServices() async {
    appStore.setLoading(true);

    Map<String, dynamic> request = {};

    request = {
      "id": serviceData!.id,
      "doctor_id": serviceData!.doctor_id,
    };

    request.putIfAbsent("service_mapping_id", () => widget.serviceData!.mapping_table_id);

    await deleteServiceData(request).then((value) {
      toast(value.message);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  void addServices() async {
    appStore.setLoading(true);

    Map request = {};

    if (isReceptionist()) {
      request = {
        "type": category!.value,
        "charges": serviceChargesCont.text,
        "name": serviceNameCont.text,
        "clinic_id": getIntAsync(USER_CLINIC),
        "doctor_id": appointmentAppStore.selectedDoctor,
        "status": serviceStatus,
      };
    } else {
      request = {
        "type": category!.value,
        "charges": serviceChargesCont.text,
        "name": serviceNameCont.text,
        "clinic_id": getIntAsync(USER_CLINIC),
        "status": serviceStatus,
        "doctor_id": [getIntAsync(USER_ID)],
      };
    }

    await addServiceData(request).then((value) {
      toast(value.message);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  void updateServices() async {
    appStore.setLoading(true);

    Map<String, dynamic> request = {};

    if (isReceptionist()) {
      request = {
        "id": serviceData!.id,
        "type": category!.value,
        "charges": serviceChargesCont.text,
        "name": serviceNameCont.text,
        "clinic_id": getIntAsync(USER_CLINIC),
        "doctor_id": [serviceData!.doctor_id],
        "status": serviceStatus,
      };
    } else {
      request = {
        "id": serviceData!.id,
        "type": category!.value,
        "charges": serviceChargesCont.text,
        "name": serviceNameCont.text,
        "clinic_id": getIntAsync(USER_CLINIC),
        "status": serviceStatus,
        "doctor_id": [getIntAsync(USER_ID)],
      };
    }

    request.putIfAbsent("service_mapping_id", () => widget.serviceData!.mapping_table_id);

    await addServiceData(request).then((value) {
      toast(value.message);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (BuildContext context) {
        List<String> ids = [];
        if (selectedDoctorList.validate().isNotEmpty) {
          selectedDoctorList.forEach((element) {
            ids.add(element!.iD.toString());
          });
        }

        return MultiSelectDoctorDropDown(selectedServicesId: ids);
      },
    ).then((value) {
      if (selectedDoctorList.isNotEmpty) {
        selectedDoctorList.clear();
        selectedDoctorList.addAll(value);
        List<int> temp = [];
        selectedDoctorList.forEach((element) {
          temp.add(element!.iD!.toInt());
        });
        appointmentAppStore.addSelectedDoctor(temp);
        return;
      } else {
        selectedDoctorList.addAll(value);
        List<int?> temp = [];
        selectedDoctorList.forEach((element) {
          temp.add(element!.iD);
        });
        appointmentAppStore.addSelectedDoctor(temp);
        return;
      }
    });
    setState(() {});
  }

  Widget buildBodyWidget() {
    return FutureBuilder<StaticDataModel?>(
      future: _memorizer.runOnce(() => getStaticDataResponse(SERVICE_TYPE)),
      builder: (context, snap) {
        if (snap.hasData) {
          if (isUpdate) {
            category = snap.data!.staticData!.firstWhereOrNull((element) => element!.value == serviceData!.type);
          }

          return Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: AnimatedScrollView(
              padding: EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<StaticData>(
                  focusNode: serviceCategoryFocus,
                  icon: SizedBox.shrink(),
                  isExpanded: true,
                  dropdownColor: context.cardColor,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: category,
                  items: snap.data!.staticData!.map<DropdownMenuItem<StaticData>>((value) {
                    return DropdownMenuItem<StaticData>(
                      value: value,
                      child: Text(value!.label!, style: primaryTextStyle()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (!isUpdate) {
                      category = value;
                      setState(() {});
                    }
                  },
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblCategory,
                  ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                  validator: (s) {
                    if (s == null) return locale.lblServiceCategoryIsRequired;
                    return null;
                  },
                ),
                16.height,
                AppTextField(
                  focus: serviceNameFocus,
                  nextFocus: serviceChargesFocus,
                  controller: serviceNameCont,
                  errorThisFieldRequired: locale.lblServiceNameIsRequired,
                  textFieldType: TextFieldType.NAME,
                  textAlign: TextAlign.justify,
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblName,
                  ).copyWith(suffixIcon: ic_user.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                ),
                16.height,
                AppTextField(
                  focus: serviceChargesFocus,
                  nextFocus: serviceStatusFocus,
                  controller: serviceChargesCont,
                  errorThisFieldRequired: locale.lblServiceChargesIsRequired,
                  textFieldType: TextFieldType.NAME,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.justify,
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblCharges,
                  ).copyWith(suffixIcon: ic_dollar_icon.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                ),
                16.height,
                RoleWidget(
                  isShowPatient: true,
                  isShowReceptionist: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: doctorCont,
                        textFieldType: TextFieldType.OTHER,
                        readOnly: true,
                        onTap: showBottomSheet,
                        decoration: inputDecoration(
                          context: context,
                          labelText: locale.lblSelectDoctor,
                        ).copyWith(
                          alignLabelWithHint: true,
                        ),
                      ),
                      16.height,
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          selectedDoctorList.length.toString().isEmpty ? 0 : selectedDoctorList.length,
                          (index) {
                            DoctorList data = selectedDoctorList[index]!;
                            return Chip(
                              backgroundColor: context.cardColor,
                              shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
                              label: Text('${data.display_name}', style: primaryTextStyle(color: context.iconColor)),
                              avatar: Icon(CupertinoIcons.person, size: 16, color: context.iconColor),
                            );
                          },
                        ),
                      ),
                      16.height,
                    ],
                  ),
                ),
                DropdownButtonFormField<int>(
                  isExpanded: true,
                  value: serviceStatus,
                  focusNode: serviceStatusFocus,
                  icon: SizedBox.shrink(),
                  dropdownColor: context.cardColor,
                  items: List.generate(
                    status.length,
                    (index) => DropdownMenuItem<int>(child: Text(status[index] == 0 ? locale.lblInActive : locale.lblActive, style: primaryTextStyle()), value: status[index]),
                  ),
                  onChanged: (value) {
                    serviceStatus = value;
                  },
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblStatus,
                  ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
                  validator: (s) {
                    if (s == null) return locale.lblStatusIsRequired;
                    return null;
                  },
                ),
              ],
            ),
          );
        }
        return snapWidgetHelper(snap, errorWidget: NoDataFoundWidget(text: errorMessage), loadingWidget: LoaderWidget());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? locale.lblEditService : locale.lblAddService,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        actions: [
          if (isUpdate)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                showConfirmDialogCustom(
                  context,
                  dialogType: DialogType.DELETE,
                  title: locale.lblAreYouSureToDelete,
                  onAccept: (p0) {
                    deleteServices();
                  },
                );
              },
            ),
        ],
      ),
      body: Body(child: buildBodyWidget()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            showConfirmDialogCustom(
              context,
              dialogType: isUpdate ? DialogType.UPDATE : DialogType.CONFIRMATION,
              primaryColor: context.primaryColor,
              title: "Are you sure you want to submit the service form?",
              onAccept: (p0) {
                isUpdate ? updateServices() : addServices();
              },
            );
          }
        },
      ),
    );
  }
}
