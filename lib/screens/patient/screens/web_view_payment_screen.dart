import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/network/network_utils.dart';
import 'package:kivicare_flutter/screens/doctor/fragments/appointment_fragment.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPaymentScreen extends StatefulWidget {
  final String? checkoutUrl;

  final bool isProductDetail;

  WebViewPaymentScreen({this.checkoutUrl, this.isProductDetail = false});

  @override
  WebViewPaymentScreenState createState() => WebViewPaymentScreenState();
}

class WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  var mIsError = false;

  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    if (widget.isProductDetail) {
      setStatusBarColor(
        Colors.black87,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      );
    }
    init();
  }

  void init() async {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress < 100)
              appStore.setLoading(true);
            else {
              appStore.setLoading(false);
            }
            setState(() {});
          },
          onPageStarted: (String url) {
            appStore.setLoading(false);
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            mIsError = true;
          },
          onNavigationRequest: (NavigationRequest request) {
            if (mIsError) return NavigationDecision.prevent;
            if (request.url.contains('checkout/order-received')) {
              redirectionCase(context, message: locale.lblAppointmentBookedSuccessfully, finishCount: 5);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.checkoutUrl.validate()),
        headers: buildHeaderTokens(),
      );
    appStore.setLoading(false);
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isProductDetail) {
      setStatusBarColor(
        wordpressWebStoreAppbarColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: widget.isProductDetail
          ? null
          : appBarWidget(
              widget.isProductDetail ? locale.lblShopFromWordpress : locale.lblPayment,
              textColor: Colors.white,
              showBack: widget.isProductDetail,
              systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
            ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller!).paddingTop(context.statusBarHeight),
          Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}

Future<void> redirectionCase(BuildContext context, {String? message, int finishCount = 4}) async {
  for (int i = 0; i < finishCount; i++) {
    finish(context, true);
  }
  toast(message);
  appointmentStreamController.add(true);
  appointmentAppStore.setDescription(null);
  appointmentAppStore.setSelectedPatient(null);
  appointmentAppStore.setSelectedClinic(null);
  appointmentAppStore.setSelectedAppointmentDate(DateTime.now());
  appointmentAppStore.setSelectedTime(null);
  appointmentAppStore.setSelectedPatientId(null);
  appointmentAppStore.setSelectedDoctor(null);
  appointmentAppStore.setPaymentMethod(null);
  appointmentAppStore.clearAll();
  multiSelectStore.setTaxData(null);
}
