import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/patient_bill_model.dart';
import 'package:kivicare_flutter/model/service_model.dart';
import 'package:kivicare_flutter/network/service_repository.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class AddBillItemScreen extends StatefulWidget {
  List<BillItem>? billItem;

  BillItem? data;
  final int? billId;
  final int? doctorId;
  final String? clinicId;
  final VoidCallback? callBack;

  AddBillItemScreen({this.billItem, this.billId, this.doctorId, this.data, this.clinicId, this.callBack});

  @override
  _AddBillItemScreenState createState() => _AddBillItemScreenState();
}

class _AddBillItemScreenState extends State<AddBillItemScreen> {
  Future<ServiceListModel>? future;
  AsyncMemoizer<ServiceListModel> _memorizer = AsyncMemoizer();

  GlobalKey<FormState> formKey = GlobalKey();

  ServiceData? serviceData;
  TextEditingController priceCont = TextEditingController();
  TextEditingController quantityCont = TextEditingController();
  TextEditingController totalCont = TextEditingController();

  bool isFirstTime = true;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.data != null;

    setStatusBarColor(appPrimaryColor, statusBarIconBrightness: Brightness.light);
    appStore.setLoading(true);
    future = getServiceResponseAPI(doctorId: widget.doctorId, clinicId: widget.clinicId).then((value) {
      _memorizer.runOnce(() => value);
      if (isUpdate) {
        serviceData = value.serviceData.validate().firstWhere((element) => element.id == widget.data?.itemId);

        if (serviceData != null) {
          priceCont.text = serviceData!.charges.validate();
          quantityCont.text = widget.data!.qty.validate();
          totalCont.text = "${serviceData!.charges.toInt() * quantityCont.text.toInt()}";
        }
      }
      value.serviceData.validate().removeWhere((element) => element.name.isEmptyOrNull);
      setState(() {});
      appStore.setLoading(false);
      return value;
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
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
      appBar: appBarWidget(locale.lblAddBillItem, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Stack(
        children: [
          SnapHelperWidget(
            future: future,
            onSuccess: (data) {
              return Form(
                key: formKey,
                child: AnimatedScrollView(
                  padding: EdgeInsets.all(16),
                  listAnimationType: listAnimationType,
                  children: [
                    DropdownButtonFormField<ServiceData>(
                      dropdownColor: context.cardColor,
                      borderRadius: radius(),
                      value: serviceData,
                      decoration: inputDecoration(
                        context: context,
                        labelText: locale.lblSelectServices,
                      ),
                      validator: (v) {
                        if (v == null) return locale.lblServiceIsRequired;
                        return null;
                      },
                      items: data.serviceData!.map((e) => DropdownMenuItem(child: Text(e.name.validate(), style: primaryTextStyle()), value: e)).toList(),
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
                ),
              );
            },
          ),
          //LoaderWidget().visible(appStore.isLoading).center()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();

            bool isAlreadyExist = widget.billItem.validate().any((element) => element.itemId.validate() == serviceData!.id.validate());

            if (isAlreadyExist) {
              int alreadyExistId = widget.billItem.validate().indexWhere((element) => element.itemId.validate() == serviceData!.id.validate());

              if (quantityCont.text.validate().toInt() == 0) {
                widget.billItem.validate().remove(widget.billItem.validate()[alreadyExistId]);
              } else {
                widget.billItem.validate()[alreadyExistId].qty = quantityCont.text.validate();
              }
              //widget.billItem.validate()[alreadyExistId].qty = (widget.billItem.validate()[alreadyExistId].qty.toInt() + quantityCont.text.validate().toInt()).toString();
            } else {
              widget.billItem.validate().add(
                    BillItem(
                      id: "",
                      label: serviceData!.name.validate(),
                      billId: widget.billId.validate().toString(),
                      itemId: serviceData!.id.validate(),
                      qty: quantityCont.text.validate(),
                      price: priceCont.text.validate(),
                    ),
                  );
            }

            widget.callBack?.call();
            finish(context, true);
          } else {
            isFirstTime = !isFirstTime;
            setState(() {});
          }
        },
      ),
    );
  }
}
