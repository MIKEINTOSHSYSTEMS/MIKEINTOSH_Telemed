import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class WebViewPaymentScreen extends StatefulWidget {
  String? checkoutUrl;

  WebViewPaymentScreen({this.checkoutUrl});

  @override
  WebViewPaymentScreenState createState() => WebViewPaymentScreenState();
}

class WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  var mIsError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    getDisposeStatusBarColor();
  }

  void goBack() {
    if (appStore.isBookedFromDashboard) {
      finish(context);
      finish(context);
      finish(context, true);
    } else {
      finish(context, true);
      LiveStream().emit(APP_UPDATE, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: appBarWidget(
          locale.lblPayment,
          backWidget: Icon(Icons.arrow_back, color: Colors.white, size: 28).onTap(() {
            goBack();
          }),
          systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
        ),
        body: Body(
          child: WebView(
            initialUrl: widget.checkoutUrl,
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            onPageFinished: (String url) async {
              if (mIsError) return;
              if (url.contains('checkout/order-received')) {
                appStore.setLoading(true);
                toast(locale.lblAppointmentBookedSuccessfully);
                goBack();
              } else {
                appStore.setLoading(false);
              }
            },
            onWebResourceError: (s) {
              mIsError = true;
            },
          ),
        ),
      ),
    );
  }
}
