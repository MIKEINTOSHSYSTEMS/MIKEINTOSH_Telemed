import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/screens/auth/sign_in_screen.dart';
import 'package:kivicare_flutter/screens/walkThrough/model/walk_through_model.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  var selectedIndex = 0;

  PageController pageController = PageController();

  List<WalkThroughModel> walkthroughList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    walkthroughList.add(WalkThroughModel(image: walk_through_1, title: locale.lblWalkThroughTitle1, subTitle: locale.lblWalkThroughSubTitle1));
    walkthroughList.add(WalkThroughModel(image: walk_through_2, title: locale.lblWalkThroughTitle2, subTitle: locale.lblWalkThroughSubTitle2));
    walkthroughList.add(WalkThroughModel(image: walk_through_3, title: locale.lblWalkThroughTitle3, subTitle: locale.lblWalkThroughSubTitle3));
    walkthroughList.add(WalkThroughModel(image: walk_through_4, title: locale.lblWalkThroughTitle4, subTitle: locale.lblWalkThroughSubTitle4));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget buildPageViewWidget({required WalkThroughModel data}) {
    return Column(
      children: [
        Image.asset(data.image.validate(), height: context.height() * 0.55),
        Text(data.title.validate(), style: boldTextStyle(size: 25)),
        Text(data.subTitle.validate(), textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(32),
      ],
    );
  }

  Widget buildWidget() {
    return GestureDetector(
      onTap: () {
        if (selectedIndex == (walkthroughList.length - 1)) {
          setValue(IS_WALKTHROUGH_FIRST, true);
          SignInScreen().launch(context);
        } else {
          pageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
        }
      },
      child: Container(
        width: 150,
        padding: EdgeInsets.all(16),
        decoration: boxDecorationWithRoundedCorners(backgroundColor: appPrimaryColor, borderRadius: BorderRadius.circular(defaultRadius)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedCrossFade(
              sizeCurve: Curves.fastLinearToSlowEaseIn,
              firstChild: Text(locale.lblWalkThroughGetStartedButton, style: boldTextStyle(color: white)),
              secondChild: Text(locale.lblWalkThroughNextButton, style: boldTextStyle(color: Colors.white)),
              duration: Duration(milliseconds: 300),
              crossFadeState: selectedIndex == (walkthroughList.length - 1) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            ).center().expand(),
            Icon(Icons.arrow_forward_outlined, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: walkthroughList.map((e) => buildPageViewWidget(data: e)).toList(),
            onPageChanged: (index) {
              selectedIndex = index;
              setState(() {});
            },
          ),
          Positioned(
            bottom: 180,
            left: -10,
            right: 0,
            child: DotIndicator(pageController: pageController, pages: walkthroughList, indicatorColor: primaryColor),
          ),
          Positioned(right: 16, bottom: 35, child: buildWidget()),
          Positioned(
            left: 40,
            bottom: 40,
            child: TextButton(
              onPressed: () {
                setValue(IS_WALKTHROUGH_FIRST, true);
                SignInScreen().launch(context);
              },
              child: Text(locale.lblWalkThroughSkipButton, style: boldTextStyle()),
            ),
          ),
        ],
      ),
    );
  }
}
