import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kivicare_flutter/screens/patient/screens/web_view_payment_screen.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

class SuccessFullPaymentComponent extends StatefulWidget {
  final bool? paymentStatus;

  SuccessFullPaymentComponent({this.paymentStatus});

  @override
  State<SuccessFullPaymentComponent> createState() => _SuccessFullPaymentComponentState();
}

class _SuccessFullPaymentComponentState extends State<SuccessFullPaymentComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    Timer(
      Duration(seconds: 3),
      () {
        if (widget.paymentStatus ?? false)
          redirectionCase(context);
        else
          finish(context);
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        24.height,
        SizedBox(
          child: Lottie.asset(
            widget.paymentStatus.validate() ? ic_successFullPayment : ic_failedPayment,
            fit: BoxFit.cover,
          ),
        ).center(),
      ],
    );
  }
}
