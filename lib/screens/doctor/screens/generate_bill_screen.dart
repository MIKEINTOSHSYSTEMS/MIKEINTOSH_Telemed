import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/encounter_dashboard_model.dart';
import 'package:kivicare_flutter/model/patient_bill_model.dart';
import 'package:kivicare_flutter/network/bill_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/add_bill_item.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class GenerateBillScreen extends StatefulWidget {
  EncounterDashboardModel? data;

  GenerateBillScreen({this.data});

  @override
  _GenerateBillScreenState createState() => _GenerateBillScreenState();
}

class _GenerateBillScreenState extends State<GenerateBillScreen> {
  AsyncMemoizer<PatientBillModule> _memorizer = AsyncMemoizer();
  EncounterDashboardModel? patientData;

  TextEditingController totalCont = TextEditingController();
  TextEditingController discountCont = TextEditingController(text: '0');
  TextEditingController payableCont = TextEditingController();

  bool isPaid = false;

  String? paymentStatus;

  int payableText = 0;

  List<BillItem> billItemData = [];

  List<String> dataList = ["Paid", "Unpaid"];

  int? _groupValue;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(appStore.isDarkModeOn ? scaffoldDarkColor : appPrimaryColor, statusBarIconBrightness: Brightness.light);
    patientData = widget.data;
    if (patientData!.payment_status != null) {
      paymentStatus = patientData!.payment_status.toString().toLowerCase();
    }
  }

  void saveFrom() {
    if (billItemData.isNotEmpty) {
      appStore.setLoading(true);

      Map<String, dynamic> request = {
        "id": "${patientData!.bill_id == null ? "" : patientData!.bill_id}",
        "encounter_id": "${patientData!.id == null ? "" : patientData!.id}",
        "appointment_id": "${patientData!.appointment_id == null ? "" : patientData!.appointment_id}",
        "total_amount": "${totalCont.text.validate()}",
        "discount": "${discountCont.text.validate()}",
        "actual_amount": "${payableCont.text.validate()}",
        "payment_status": isPaid ? "paid" : "unpaid",
        "billItems": billItemData,
      };

      log("----------------------------$request--------------------------------------------");

      addPatientBill(request).then((value) {
        finish(context);
        toast(locale.lblBillAddedSuccessfully);
        LiveStream().emit(UPDATE, true);
        LiveStream().emit(APP_UPDATE, true);
      }).catchError((e) {
        toast(e.toString());
      });

      appStore.setLoading(false);
    } else {
      toast(locale.lblAtLeastSelectOneBillItem);
    }
  }

  void getTotal() {
    payableText = 0;

    billItemData.forEach((element) {
      payableText += (element.price.validate().toInt() * element.qty.validate().toInt());
    });

    totalCont.text = payableText.toString();
    payableCont.text = payableText.toString();

    setTotalPayable(discountCont.text);
  }

  void setTotalPayable(String v) {
    if (v.isDigit()) {
      payableCont.text = "${payableText - v.toInt()}";
    }
    if (v.trim().isEmpty) {
      payableCont.text = payableText.toString();
    }
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
    return Body(
      child: FutureBuilder<PatientBillModule>(
        future: _memorizer.runOnce(() => getBillDetails(encounterId: patientData!.id.toInt())),
        builder: (_, snap) {
          if (snap.hasData) {
            if (billItemData.isEmpty) {
              billItemData.addAll(snap.data!.billItems!);
            }
            getTotal();
            return Container(
              child: Stack(
                children: [
                  Column(
                    children: [
                      8.height,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        decoration: boxDecorationDefault(
                          color: appStore.isDarkModeOn ? cardDarkColor : black,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                        ),
                        child: Row(
                          children: [
                            Text(locale.lblSRNo, style: boldTextStyle(size: 12, color: white), textAlign: TextAlign.center).expand(),
                            Text("   ${locale.lblSERVICES}", style: boldTextStyle(size: 12, color: white), textAlign: TextAlign.start).expand(flex: 2),
                            Text(locale.lblPRICE, style: boldTextStyle(size: 12, color: white), textAlign: TextAlign.center).expand(),
                            Text(locale.lblQUANTITY, style: boldTextStyle(size: 12, color: white), textAlign: TextAlign.center).expand(),
                            Text(locale.lblTOTAL, style: boldTextStyle(size: 12, color: white), textAlign: TextAlign.center).expand(flex: 1),
                          ],
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxHeight: context.height() * 0.39),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: boxDecorationDefault(
                          color: context.cardColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: billItemData.length,
                          itemBuilder: (context, index) {
                            BillItem data = billItemData[index];
                            int total = data.price.validate().toInt() * data.qty.validate().toInt();
                            return Row(
                              children: [
                                Text('${index + 1}', style: primaryTextStyle(size: 12), textAlign: TextAlign.center).expand(),
                                Text('      ${data.label.validate()}', style: primaryTextStyle(size: 12), textAlign: TextAlign.left).expand(flex: 2),
                                Text('${appStore.currency}${data.price.validate()}', style: primaryTextStyle(size: 12), textAlign: TextAlign.center).expand(),
                                Text('${data.qty.validate()}', style: primaryTextStyle(size: 12), textAlign: TextAlign.center).expand(),
                                Text('${appStore.currency}$total', style: primaryTextStyle(size: 12), textAlign: TextAlign.center).expand(flex: 1),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(color: viewLineColor);
                          },
                        ),
                      ),
                      24.height,
                    ],
                  ).paddingAll(16),
                  Positioned(
                    bottom: 230,
                    right: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: context.width(),
                      decoration: boxDecorationDefault(
                        borderRadius: radius(),
                        color: context.cardColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DETAILS', style: boldTextStyle()),
                          4.height,
                          Divider(color: gray.withOpacity(0.2)),
                          4.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(locale.lblTotal, style: secondaryTextStyle()),
                              Text("${appStore.currency}${totalCont.text.toString()}", style: boldTextStyle(), textAlign: TextAlign.right).expand(),
                            ],
                          ),
                          8.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(locale.lblDiscount, style: secondaryTextStyle()),
                              Spacer(),
                              Container(
                                width: 60,
                                constraints: BoxConstraints(maxWidth: 90),
                                height: 30,
                                child: AppTextField(
                                  controller: discountCont,
                                  textFieldType: TextFieldType.PHONE,
                                  keyboardType: TextInputType.number,
                                  decoration: inputDecoration(context: context, labelText: '').copyWith(
                                    contentPadding: EdgeInsets.only(left: 8),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.0),
                                      borderRadius: radius(),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.0, color: Colors.red),
                                      borderRadius: radius(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                                      borderRadius: radius(),
                                    ),
                                  ),
                                  onChanged: setTotalPayable,
                                  onFieldSubmitted: setTotalPayable,
                                ),
                              ),
                            ],
                          ),
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(locale.lblPayableAmount, style: secondaryTextStyle()),
                              Text("${appStore.currency}${payableCont.text.toString()}", style: boldTextStyle(), textAlign: TextAlign.right).expand(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: context.width(),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      decoration: boxDecorationDefault(
                        borderRadius: radius(),
                        color: context.cardColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.lblStatus.toUpperCase(), style: boldTextStyle()),
                          4.height,
                          Divider(color: gray.withOpacity(0.2)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RadioListTile(
                                value: 0,
                                contentPadding: EdgeInsets.zero,
                                groupValue: _groupValue,
                                selectedTileColor: Colors.red,
                                title: Text("Paid"),
                                onChanged: (int? newValue) {
                                  _groupValue = newValue.validate();
                                  setState(() {});
                                  isPaid = true;
                                },
                                activeColor: primaryColor,
                                selected: true,
                              ).expand(),
                              RadioListTile(
                                value: 1,
                                contentPadding: EdgeInsets.zero,
                                groupValue: _groupValue,
                                selectedTileColor: Colors.red,
                                title: Text("Unpaid"),
                                onChanged: (int? newValue) {
                                  _groupValue = newValue.validate();
                                  isPaid = false;

                                  setState(() {});
                                },
                                activeColor: primaryColor,
                                selected: true,
                              ).expand(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: context.width(),
                      decoration: boxDecorationWithShadow(
                        border: Border(top: BorderSide(color: viewLineColor)),
                        blurRadius: 0,
                        spreadRadius: 0,
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              finish(context);
                            },
                            child: Text(locale.lblCancel.toUpperCase(), style: boldTextStyle(color: appStore.isDarkModeOn ? white : secondaryTxtColor)),
                          ).expand(),
                          16.width,
                          AppButton(
                            color: appStore.isDarkModeOn ? cardDarkColor : appSecondaryColor,
                            child: Text('${isPaid ? locale.lblSaveAndCloseEncounter : locale.lblSave.toUpperCase()}', style: boldTextStyle(color: Colors.white)),
                            onTap: () {
                              saveFrom();
                            },
                          ).expand(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return snapWidgetHelper(snap, loadingWidget: LoaderWidget());
        },
      ),
    );
  }

  Widget body1() {
    return Body(
      child: Stack(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: boxDecorationDefault(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(defaultRadius)),
                  padding: EdgeInsets.all(4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: primaryColor, size: 20),
                      4.width,
                      Text(locale.lblAddBillItem, style: boldTextStyle(color: primaryColor)),
                      4.width,
                    ],
                  ),
                ).onTap(() async {
                  bool? res = await AddBillItem(billId: patientData!.bill_id.toInt(), billItem: billItemData).launch(context);
                  if (res ?? false) {
                    getTotal();
                    setState(() {});
                  }
                }),
              ),
              32.height,
              Row(
                children: [
                  Text(locale.lblSRNo, style: boldTextStyle(size: 12), textAlign: TextAlign.center).expand(),
                  Text(locale.lblSERVICES, style: boldTextStyle(size: 12), textAlign: TextAlign.center).expand(flex: 2),
                  Text(locale.lblPRICE, style: boldTextStyle(size: 12), textAlign: TextAlign.center).expand(),
                  Text(locale.lblQUANTITY, style: boldTextStyle(size: 12), textAlign: TextAlign.center).expand(),
                  Text(locale.lblTOTAL, style: boldTextStyle(size: 12), textAlign: TextAlign.center).expand(flex: 1),
                ],
              ),
              16.height,
              ListView.separated(
                shrinkWrap: true,
                itemCount: billItemData.length,
                itemBuilder: (context, index) {
                  BillItem data = billItemData[index];
                  int total = data.price.validate().toInt() * data.qty.validate().toInt();
                  return Row(
                    children: [
                      Text('${index + 1}', style: primaryTextStyle(size: 12), textAlign: TextAlign.center).expand(),
                      Text('${data.label.validate()}', style: primaryTextStyle(size: 12), textAlign: TextAlign.center).expand(flex: 2),
                      Text('${data.price.validate()}', style: primaryTextStyle(size: 12), textAlign: TextAlign.center).expand(),
                      Text('${data.qty.validate()}', style: primaryTextStyle(size: 12), textAlign: TextAlign.center).expand(),
                      Text('$total', style: primaryTextStyle(size: 12), textAlign: TextAlign.center).expand(flex: 1),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(color: viewLineColor);
                },
              )
            ],
          ).paddingAll(16),
          Positioned(
            bottom: 80,
            child: Container(
              padding: EdgeInsets.all(16),
              width: context.width(),
              decoration: boxDecorationDefault(
                border: Border(top: BorderSide(color: viewLineColor)),
                color: context.scaffoldBackgroundColor,
              ),
              child: Row(
                children: [
                  AppTextField(
                    controller: totalCont,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(context: context, labelText: locale.lblTotal),
                    readOnly: true,
                  ).expand(),
                  16.width,
                  AppTextField(
                    controller: discountCont,
                    textFieldType: TextFieldType.NAME,
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration(context: context, labelText: locale.lblDiscount),
                    onChanged: setTotalPayable,
                    onFieldSubmitted: setTotalPayable,
                  ).expand(),
                  16.width,
                  AppTextField(
                    controller: payableCont,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(context: context, labelText: locale.lblPayableAmount),
                    readOnly: true,
                  ).expand(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              width: context.width(),
              decoration: boxDecorationDefault(
                border: Border(top: BorderSide(color: viewLineColor)),
                color: context.scaffoldBackgroundColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    shapeBorder: Border.all(color: primaryColor),
                    color: Colors.transparent,
                    elevation: 0,
                    child: Text(locale.lblCancel, style: boldTextStyle(color: primaryColor)),
                    onTap: () {
                      //
                    },
                  ).cornerRadiusWithClipRRect(defaultRadius).expand(),
                  16.width,
                  AppButton(
                    color: primaryColor,
                    child: Text('${isPaid ? locale.lblSaveAndCloseEncounter : locale.lblSave}', style: boldTextStyle(color: Colors.white)),
                    onTap: () {
                      showConfirmDialogCustom(
                        context,
                        title: 'Are you sure you want to save?',
                        dialogType: DialogType.CONFIRMATION,
                        onAccept: (p0) {
                          saveFrom();
                        },
                      );
                    },
                  ).expand(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        locale.lblGenerateInvoice,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(1),
                decoration: boxDecorationDefault(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(defaultRadius),
                  border: Border.all(color: white, width: 1),
                ),
                child: Icon(Icons.add, color: white, size: 14),
              ),
              6.width,
              Text(locale.lblAddBillItem.toUpperCase(), style: boldTextStyle(color: white, size: 16)),
              4.width,
            ],
          ).paddingOnly(right: 16, left: 8).onTap(() async {
            bool? res = await AddBillItem(billId: patientData!.bill_id.toInt(), billItem: billItemData, doctorId: patientData!.doctor_id.toInt()).launch(context);
            if (res ?? false) {
              getTotal();
              setState(() {});
            }
          }),
        ],
      ),
      body: patientData!.bill_id == null ? body1() : body(),
    );
  }
}
