import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/price_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/service_model.dart';
import 'package:kivicare_flutter/network/service_repository.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class MultiSelectWidget extends StatefulWidget {
  final int? id;
  List<String?>? selectedServicesId;

  MultiSelectWidget({this.id, this.selectedServicesId});

  @override
  _MultiSelectWidgetState createState() => _MultiSelectWidgetState();
}

class _MultiSelectWidgetState extends State<MultiSelectWidget> {
  TextEditingController search = TextEditingController();

  List<ServiceData> searchServicesList = [];

  List<ServiceData> servicesList = [];
  List<ServiceData> selectedServicesList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getData();
  }

  @override
  void dispose() {
    2.milliseconds.delay;

    super.dispose();
  }

  void getData() async {
    appStore.setLoading(true);
    await getServiceResponse(
      id: appointmentAppStore.mDoctorSelected != null ? appointmentAppStore.mDoctorSelected!.iD : getIntAsync(USER_ID),
      page: 1,
    ).then((value) {
      servicesList.addAll(value.serviceData!);
      searchServicesList.addAll(value.serviceData!);
      setState(() {});
      multiSelectStore.clearList();
      servicesList.forEach((element) {
        if (widget.selectedServicesId!.contains(element.id)) {
          multiSelectStore.addSingleItem(element, isClear: false);
          element.isCheck = true;
        }
      });
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  List<ServiceData> getSelectedData() {
    List<ServiceData> selected = [];

    servicesList.forEach((value) {
      if (value.isCheck == true) {
        selected.add(value);
      }
    });
    setState(() {});
    return selected;
  }

  onSearchTextChanged(String text) async {
    servicesList.clear();

    if (text.isEmpty) {
      servicesList.addAll(searchServicesList);
      setState(() {});
      return;
    }
    searchServicesList.forEach((element) {
      if (element.name!.toLowerCase().contains(text)) servicesList.add(element);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblServices, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Body(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(locale.lblSelectServices, style: boldTextStyle(size: 18)),
              Divider(),
              8.height,
              AppTextField(
                decoration: inputDecoration(context: context, labelText: locale.lblSearch),
                controller: search,
                onChanged: onSearchTextChanged,
                autoFocus: false,
                textInputAction: TextInputAction.go,
                textFieldType: TextFieldType.OTHER,
                suffix: Icon(Icons.search, size: 20),
              ),
              8.height,
              AnimatedListView(
                itemCount: servicesList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  ServiceData data = servicesList[index];
                  return Theme(
                    data: ThemeData(
                      unselectedWidgetColor: primaryColor,
                    ),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.all(0),
                      value: data.isCheck,
                      onChanged: (v) {
                        data.isCheck = !data.isCheck;
                        if (v!) {
                          multiSelectStore.addSingleItem(data, isClear: false);
                          widget.selectedServicesId!.add(data.id);
                        } else {
                          multiSelectStore.removeItem(data);
                          widget.selectedServicesId!.remove(data.id);
                        }
                        setState(() {});
                      },
                      title: Text(
                        data.name.capitalizeFirstLetter().validate(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: primaryTextStyle(),
                      ),
                      secondary: PriceWidget(price: data.charges.validate(), textStyle: boldTextStyle()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          finish(context, selectedServicesList.isEmpty);
        },
      ),
    );
  }
}
