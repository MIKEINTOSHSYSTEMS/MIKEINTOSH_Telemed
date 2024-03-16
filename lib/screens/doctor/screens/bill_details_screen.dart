import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/components/price_widget.dart';
import 'package:momona_healthcare/components/status_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/patient_bill_model.dart';
import 'package:momona_healthcare/model/tax_model.dart';
import 'package:momona_healthcare/network/bill_repository.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/constants.dart';

import 'package:nb_utils/nb_utils.dart';

class BillDetailsScreen extends StatefulWidget {
  final int? encounterId;
  final int? billId;

  final VoidCallback? callBack;

  BillDetailsScreen({this.encounterId, this.billId, this.callBack});

  @override
  _BillDetailsScreenState createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {
  Future<PatientBillModule?>? future;
  PatientBillModule? billDetail;

  TaxModel? taxData;

  List<String> list = [locale.lblTotal, locale.lblDiscount, locale.lblAmountDue];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    future = getBillDetailsAPI(encounterId: widget.encounterId).then((value) {
      appStore.setLoading(false);
      billDetail = value;
      getTaxDataApi();
      setState(() {});
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  void getTaxDataApi() {
    Map<String, dynamic> request = {
      ConstantKeys.doctorIdKey: billDetail?.patientEncounter?.doctorId,
      ConstantKeys.clinicIdKey: billDetail?.patientEncounter?.clinicId,
    };

    List<ServiceRequestModel> selectedServiceRequest = [];

    request.putIfAbsent(ConstantKeys.visitTypeKey, () => selectedServiceRequest);
    billDetail?.billItems.validate().validate().forEachIndexed((element, index) {
      selectedServiceRequest.add(ServiceRequestModel(serviceId: element.mappingTableId, quantity: element.qty.validate().toInt()));
    });

    request.putIfAbsent(ConstantKeys.visitTypeKey, () => selectedServiceRequest);
    appStore.setLoading(true);
    getTaxData(request).then((data) {
      taxData = data;
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  Future<void> deleteBill() async {
    appStore.setLoading(true);
    deleteBillApi(widget.billId.toString()).then((value) {
      toast(value.message);
      widget.callBack?.call();
      appStore.setLoading(false);
      finish(context);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        locale.lblInvoiceDetail,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: SafeArea(child: body()),
    );
  }

  Widget body() {
    return FutureBuilder<PatientBillModule?>(
      future: future,
      builder: (_, snap) {
        if (snap.hasData) {
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScrollView(
                padding: EdgeInsets.all(16),
                listAnimationType: ListAnimationType.None,
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Text(locale.lblClinicDetails.toUpperCase(), style: boldTextStyle(size: 16)),
                  Divider(color: viewLineColor, height: 24),
                  clinicDetails(patientBillData: snap.data!),
                  Divider(color: viewLineColor, height: 24),
                  16.height,
                  Text(locale.lblPatientDetails.toUpperCase(), style: boldTextStyle(size: 16)),
                  Divider(color: viewLineColor, height: 24),
                  if (snap.data != null) patientDetails(patientBillData: snap.data!),
                  Divider(color: viewLineColor, height: 24),
                  16.height,
                  Text(locale.lblServices.toUpperCase(), style: boldTextStyle(size: 16)),
                  Divider(color: viewLineColor, height: 24),
                  servicesDetails(patientBillData: snap.data!),
                  16.height,
                ],
              ),
              Positioned(
                child: DottedBorderWidget(
                  color: appPrimaryColor,
                  gap: 3,
                  radius: 8,
                  strokeWidth: 1,
                  child: Container(
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: context.scaffoldBackgroundColor),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(locale.lblPrice + ' : ', style: secondaryTextStyle(size: 12), textAlign: TextAlign.start).paddingSymmetric(vertical: 4).expand(),
                            FittedBox(
                              child: Text(
                                '${appStore.currencyPrefix.validate(value: appStore.currency.validate())}${snap.data!.totalAmount.validate().toDouble().toStringAsFixed(2)}${appStore.currencyPostfix.validate(value: '')}',
                                textAlign: TextAlign.end,
                                style: primaryTextStyle(size: 12),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(locale.lblDiscount + ' :  ', style: secondaryTextStyle(size: 12), textAlign: TextAlign.start).paddingSymmetric(vertical: 4).expand(),
                            FittedBox(
                              child: Text(
                                ' ${appStore.currencyPrefix.validate(value: appStore.currency.validate())}${snap.data!.discount.validate().toDouble().toStringAsFixed(2)}${appStore.currencyPostfix.validate(value: '')}',
                                textAlign: TextAlign.end,
                                style: primaryTextStyle(size: 12),
                              ),
                            )
                          ],
                        ),
                        if (taxData != null) Divider(height: 8, color: context.dividerColor),
                        if (taxData != null)
                          Row(
                            children: [
                              Text(locale.lblSubTotal + " : ", style: secondaryTextStyle(size: 12), textAlign: TextAlign.start).paddingSymmetric(vertical: 4).expand(),
                              FittedBox(
                                child: PriceWidget(
                                  price: '${(snap.data!.totalAmount.validate().toDouble() - snap.data!.discount.validate().toDouble()).toStringAsFixed(2)}',
                                  textStyle: primaryTextStyle(size: 12),
                                ),
                              )
                            ],
                          ),
                        if (taxData != null && taxData!.taxList.validate().isNotEmpty) Divider(height: 8, color: context.dividerColor),
                        if (taxData != null && taxData!.taxList.validate().isNotEmpty)
                          Row(
                            children: [
                              Text(locale.lblTax, style: boldTextStyle(size: 12)).expand(),
                              16.width,
                              Text(
                                locale.lblTaxRate,
                                style: boldTextStyle(size: 12),
                                textAlign: TextAlign.center,
                              ).expand(flex: 2),
                              16.width,
                              Text(
                                locale.lblCharges,
                                style: boldTextStyle(size: 12),
                                textAlign: TextAlign.end,
                              ).expand(),
                            ],
                          ),
                        if (taxData != null && taxData!.taxList.validate().isNotEmpty) 6.height,
                        if (taxData != null && taxData!.taxList.validate().isNotEmpty)
                          ...taxData!.taxList.validate().map<Widget>((e) {
                            return Row(
                              children: [
                                Text(e.taxName.validate().replaceAll(RegExp(r'[^a-zA-Z]'), ''), maxLines: 1, overflow: TextOverflow.ellipsis, style: secondaryTextStyle(size: 12)).expand(),
                                if (e.taxName.validate().contains('%'))
                                  Text(
                                    e.taxRate.validate().toString().suffixText(value: '%'),
                                    style: primaryTextStyle(size: 12),
                                    textAlign: TextAlign.center,
                                  ).expand(flex: 2)
                                else
                                  PriceWidget(
                                    price: e.taxRate.validate().toStringAsFixed(2),
                                    textStyle: primaryTextStyle(size: 12),
                                    textAlign: TextAlign.center,
                                  ).paddingLeft(4).expand(flex: 2),
                                PriceWidget(
                                  price: e.charges.validate().toStringAsFixed(2),
                                  textStyle: primaryTextStyle(size: 12),
                                  textAlign: TextAlign.end,
                                ).paddingLeft(4).expand(),
                              ],
                            );
                          }).toList(),
                        Divider(height: 8, color: context.dividerColor),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(locale.lblTotal + ' : ', style: secondaryTextStyle(size: 12), textAlign: TextAlign.end).paddingSymmetric(vertical: 4).expand(flex: 5),
                            FittedBox(
                              child: Text(
                                '${appStore.currencyPrefix.validate(value: appStore.currency.validate())}${snap.data!.actualAmount.validate().toDouble().toStringAsFixed(2)}${appStore.currencyPostfix.validate(value: '')}',
                                textAlign: TextAlign.end,
                                style: boldTextStyle(size: 12),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                bottom: 16,
                right: 16,
                left: 16,
              )
            ],
          );
        }
        return snapWidgetHelper(snap, loadingWidget: LoaderWidget());
      },
    );
  }

  Widget clinicDetails({required PatientBillModule patientBillData}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(child: Text('${patientBillData.clinic!.name.validate()}', style: boldTextStyle())),
                4.height,
                RichTextWidget(
                  list: [
                    TextSpan(text: locale.lblInvoiceId + ': ', style: boldTextStyle(size: 12)),
                    TextSpan(text: '#${patientBillData.id.validate()} ', style: primaryTextStyle(size: 12)),
                  ],
                ),
                4.height,
                RichTextWidget(
                  list: [
                    TextSpan(text: locale.lblCreatedAt + ': ', style: boldTextStyle(size: 12)),
                    TextSpan(
                      text: '${patientBillData.createdAt.validate()} ',
                      style: primaryTextStyle(size: 12),
                    ),
                  ],
                ),
              ],
            ).expand(),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${patientBillData.clinic!.city.validate()}', style: primaryTextStyle(size: 14)),
                2.height,
                Text('${patientBillData.clinic!.country.validate()}', style: primaryTextStyle(size: 14)),
                2.height,
                FittedBox(child: Text('${patientBillData.clinic!.email.validate()} ', style: primaryTextStyle(size: 14))),
                2.height,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(locale.lblPaymentStatus + ': ', style: primaryTextStyle(size: 14)).expand(),
                    StatusWidget(status: patientBillData.paymentStatus == 'paid' ? '1' : '0', isPaymentStatus: true),
                  ],
                ),
              ],
            ).expand(),
          ],
        ),
      ],
    );
  }

  Widget patientDetails({required PatientBillModule patientBillData}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextWidget(
          list: [
            TextSpan(text: locale.lblPatientName + ': ', style: boldTextStyle(size: 12)),
            TextSpan(text: '${patientBillData.patient!.displayName.validate()}', style: primaryTextStyle(size: 12)),
          ],
        ),
        6.height,
        RichTextWidget(
          list: [
            TextSpan(text: locale.lblGender2 + ': ', style: boldTextStyle(size: 12)),
            TextSpan(text: '${patientBillData.patient!.gender.validate().capitalizeFirstLetter()}', style: primaryTextStyle(size: 12)),
          ],
        ),
        6.height,
        RichTextWidget(
          list: [
            TextSpan(text: locale.lblDOB + ': ', style: boldTextStyle(size: 12)),
            TextSpan(text: '${patientBillData.patient?.dob.validate()}', style: primaryTextStyle(size: 12)),
          ],
        ),
      ],
    );
  }

  Widget servicesDetails({required PatientBillModule patientBillData}) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 120),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 8, bottom: 10, right: 8),
            decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                Text(locale.lblSRNo, style: boldTextStyle(size: 12), textAlign: TextAlign.center).fit(fit: BoxFit.none).expand(),
                Text(locale.lblItemName, style: boldTextStyle(size: 12), textAlign: TextAlign.start).fit(fit: BoxFit.none).expand(flex: 2),
                Text(locale.lblPRICE, style: boldTextStyle(size: 12), textAlign: TextAlign.center).fit(fit: BoxFit.none).expand(),
                Text(locale.lblQUANTITY, style: boldTextStyle(size: 12), textAlign: TextAlign.start).fit(fit: BoxFit.none).expand(),
                Text(locale.lblTOTAL, style: boldTextStyle(size: 12), textAlign: TextAlign.end).fit(fit: BoxFit.none).expand(flex: 1),
              ],
            ),
          ),
          16.height,
          if (patientBillData.billItems.validate().isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              itemCount: patientBillData.billItems!.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                BillItem data = patientBillData.billItems![index];
                int total = data.price.validate().toInt() * data.qty.validate().toInt();
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Row(children: [
                    Text('${index + 1}', style: primaryTextStyle(size: 12), textAlign: TextAlign.center).expand(),
                    Text('${data.label.validate()}', style: primaryTextStyle(size: 12), textAlign: TextAlign.start).expand(flex: 1),
                    Text('${appStore.currencyPrefix.validate(value: '')}${data.price.validate()}${appStore.currencyPostfix.validate(value: '')}',
                            style: primaryTextStyle(size: 12), textAlign: TextAlign.center)
                        .expand(),
                    Text('${data.qty.validate()}', style: primaryTextStyle(size: 12), textAlign: TextAlign.center),
                    Text('${appStore.currencyPrefix.validate(value: '')}$total${appStore.currencyPostfix.validate(value: '')}', style: primaryTextStyle(size: 12), textAlign: TextAlign.end)
                        .expand(flex: 1),
                  ]),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(color: viewLineColor);
              },
            )
          else
            NoDataWidget(titleTextStyle: secondaryTextStyle(color: Colors.red), title: locale.lblNoRecordsFound),
        ],
      ),
    );
  }
}
