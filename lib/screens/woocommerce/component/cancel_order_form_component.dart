import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

class CancelOrderFormComponent extends StatefulWidget {
  final int orderId;
  final Function(String)? callback;

  const CancelOrderFormComponent({required this.orderId, this.callback});

  @override
  State<CancelOrderFormComponent> createState() => _CancelOrderFormState();
}

class _CancelOrderFormState extends State<CancelOrderFormComponent> {
  List<String> cancelOrderList = [
    locale.lblCancelOrderMessageOne,
    locale.lblCancelOrderMessageTwo,
    locale.lblCancelOrderMessageThree,
    locale.lblCancelOrderMessageFour,
    locale.lblCancelOrderMessageFive,
    locale.lblCancelOrderMessageSix,
  ];

  String cancelOrderReason = "";
  int cancelOrderIndex = 0;

  @override
  void initState() {
    super.initState();
    cancelOrderReason = cancelOrderList.first;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height() * 0.65,
      width: context.width(),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: AnimatedScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(locale.lblReasonForCancellation, style: boldTextStyle()).expand(),
              Icon(Icons.close).onTap(() {
                finish(context);
              })
            ],
          ),
          24.height,
          ...List.generate(cancelOrderList.length, (index) {
            return GestureDetector(
              onTap: () {
                cancelOrderReason = cancelOrderList[index];
                print(cancelOrderReason);
                cancelOrderIndex = index;
                setState(() {});
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(4),
                      border: Border.all(color: context.primaryColor),
                      backgroundColor: cancelOrderIndex == index ? context.primaryColor : context.cardColor,
                    ),
                    width: 16,
                    height: 16,
                    child: Icon(Icons.done, size: 12, color: context.cardColor),
                    margin: EdgeInsets.only(top: 4),
                  ),
                  4.width,
                  Text(cancelOrderList[index], style: primaryTextStyle()).paddingLeft(8).expand(),
                ],
              ).paddingSymmetric(vertical: 8),
            );
          }),
          24.height,
          AppButton(
            width: context.width(),
            textStyle: primaryTextStyle(color: white),
            text: locale.lblCancelOrder,
            color: context.primaryColor,
            onTap: () {
              finish(context);

              widget.callback?.call(cancelOrderReason);
            },
          ),
        ],
      ),
    );
  }
}
