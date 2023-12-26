import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/cached_image_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/price_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/service_model.dart';
import 'package:kivicare_flutter/network/get_service_response_repository.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceMultiSelectWidget extends StatefulWidget {
  const ServiceMultiSelectWidget({Key? key}) : super(key: key);

  @override
  State<ServiceMultiSelectWidget> createState() => _ServiceMultiSelectWidgetState();
}

class _ServiceMultiSelectWidgetState extends State<ServiceMultiSelectWidget> {
  TextEditingController searchCont = TextEditingController();
  Future<List<ServiceData>>? future;

  List<ServiceData> serviceList = [];

  int total = 0;
  int page = 1;
  bool isLastPage = false;

  int selected = -1;
  int? doctorId;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getServiceResponseNew(
      id: appointmentAppStore.mDoctorSelected != null ? appointmentAppStore.mDoctorSelected!.iD : appStore.userId.validate(),
      perPages: 15,
      page: page,
      serviceList: serviceList,
      getTotalService: (b) => total = b,
      lastPageCallback: (b) => isLastPage = b,
    );
  }

  void onSearchTextChanged(String? s) {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget buildBodyWidget() {
    return Stack(
      children: [
        AppTextField(
          decoration: inputDecoration(context: context, labelText: locale.lblSearch),
          controller: searchCont,
          onChanged: onSearchTextChanged,
          autoFocus: false,
          textInputAction: TextInputAction.go,
          textFieldType: TextFieldType.OTHER,
          suffix: Icon(Icons.search, size: 20),
        ).paddingAll(16),
        FutureBuilder<List<ServiceData>>(
          future: future,
          builder: (context, snap) {
            if (snap.hasData) {
              return AnimatedListView(
                itemCount: snap.data!.length,
                padding: EdgeInsets.all(16),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  ServiceData data = snap.data.validate()[index];
                  return CheckboxListTile(
                    shape: RoundedRectangleBorder(borderRadius: radius()),
                    value: data.isCheck,
                    tileColor: context.cardColor,
                    selectedTileColor: Colors.red,
                    secondary: CachedImageWidget(url: '', height: 46, circle: true),
                    checkboxShape: RoundedRectangleBorder(borderRadius: radius(6)),
                    title: Marquee(child: Text(data.name.capitalizeFirstLetter().validate(), style: boldTextStyle())),
                    subtitle: PriceWidget(price: data.charges.validate(), textSize: 16, textColor: primaryColor),
                    onChanged: (value) {
                      data.isCheck = !data.isCheck;
                      setState(() {});
                    },
                  ).cornerRadiusWithClipRRect(defaultRadius).paddingSymmetric(vertical: 8);
                },
              );
            } else {
              return snapWidgetHelper(snap, loadingWidget: LoaderWidget());
            }
          },
        ).paddingTop(60),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblServices, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context), textColor: Colors.white),
      body: buildBodyWidget(),
    );
  }
}
