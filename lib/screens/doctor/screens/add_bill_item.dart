import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/patient_bill_model.dart';
import 'package:momona_healthcare/model/service_model.dart';
import 'package:momona_healthcare/network/service_repository.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class AddBillItem extends StatefulWidget {
  List<BillItem>? billItem;
  final int? billId;
  final int? doctorId;

  AddBillItem({this.billItem, this.billId, this.doctorId});

  @override
  _AddBillItemState createState() => _AddBillItemState();
}

class _AddBillItemState extends State<AddBillItem> {
  AsyncMemoizer<ServiceListModel> _memorizer = AsyncMemoizer();

  GlobalKey<FormState> formKey = GlobalKey();

  ServiceData? serviceData;
  TextEditingController priceCont = TextEditingController();
  TextEditingController quantityCont = TextEditingController();
  TextEditingController totalCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(appPrimaryColor, statusBarIconBrightness: Brightness.light);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget body() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            FutureBuilder<ServiceListModel>(
              future: isDoctor() ? _memorizer.runOnce(() => getServiceResponse(id: getIntAsync(USER_ID), page: 1)) : _memorizer.runOnce(() => getServiceResponse(id: widget.doctorId, page: 1)),
              builder: (_, snap) {
                if (snap.hasData) {
                  return Column(
                    children: [
                      DropdownButtonFormField<ServiceData>(
                        dropdownColor: context.cardColor,
                        decoration: inputDecoration(
                          context: context,
                          labelText: locale.lblSelectServices,
                        ),
                        validator: (v) {
                          if (v == null) return locale.lblServiceIsRequired;
                          return null;
                        },
                        items: snap.data!.serviceData!.map((e) => DropdownMenuItem(child: Text('${e.name}', style: primaryTextStyle()), value: e)).toList(),
                        onChanged: (ServiceData? e) {
                          serviceData = e;
                          priceCont.text = e!.charges.validate();
                          quantityCont.text = locale.lblOne;
                          totalCont.text = "${e.charges.toInt() * quantityCont.text.toInt()}";
                        },
                      ),
                      16.height,
                      AppTextField(
                        controller: priceCont,
                        textFieldType: TextFieldType.PHONE,
                        decoration: inputDecoration(context: context, labelText: locale.lblPrice),
                        onChanged: (s) {
                          totalCont.text = "${s.toInt() * quantityCont.text.toInt()}";
                        },
                      ),
                      16.height,
                      AppTextField(
                        controller: quantityCont,
                        textFieldType: TextFieldType.PHONE,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration(context: context, labelText: locale.lblQuantity),
                        onChanged: (s) {
                          totalCont.text = "${priceCont.text.toInt() * s.toInt()}";
                        },
                      ),
                      16.height,
                      AppTextField(
                        controller: totalCont,
                        textFieldType: TextFieldType.PHONE,
                        decoration: inputDecoration(context: context, labelText: locale.lblTotal),
                        readOnly: true,
                      ),
                    ],
                  );
                }
                return snapWidgetHelper(snap);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblAddBillItem, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            widget.billItem!.add(
              BillItem(
                id: "",
                label: serviceData!.name.validate(),
                bill_id: "${widget.billId == null ? "" : widget.billId}",
                item_id: serviceData!.id,
                qty: quantityCont.text.validate(),
                price: priceCont.text.validate(),
              ),
            );
            finish(context, true);
          }
        },
      ),
    );
  }
}
