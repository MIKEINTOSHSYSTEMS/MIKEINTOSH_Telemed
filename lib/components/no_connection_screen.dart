import 'package:flutter/material.dart';
import 'package:momona_healthcare/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);

  @override
  _NoConnectionScreenState createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {
  @override
  void initState() {
    setStatusBarColor(Color(0xFFEFF1F3));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(ic_no_internet_screen, fit: BoxFit.cover, height: context.height()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(locale.lblNoConnection, style: boldTextStyle(size: 30)),
                32.height,
                Text(
                  '${locale.lblYourInternetConnectionWasInterrupted}, ${locale.lblPlease} ${locale.lblRetry}.',
                  style: primaryTextStyle(color: Colors.blueGrey, size: 18),
                ),
                48.height,
                AppButton(
                  child: Text(locale.lblRetry.toUpperCase(), style: boldTextStyle(color: white)),
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(30)),
                  elevation: 10,
                  color: Color(0xFF40588B),
                  onTap: () {
                    toast(locale.lblRetry.toUpperCase());
                  },
                ),
                20.height,
              ],
            ).paddingAll(32),
          ],
        ),
      ),
    );
  }
}
