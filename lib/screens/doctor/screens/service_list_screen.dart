import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/components/price_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/service_model.dart';
import 'package:kivicare_flutter/network/doctor_list_repository.dart';
import 'package:kivicare_flutter/network/get_service_response_repository.dart';
import 'package:kivicare_flutter/screens/doctor/screens/add_service_screen.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceListScreen extends StatefulWidget {
  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  Future<List<ServiceData>>? future;

  List<ServiceData> serviceList = [];

  int total = 0;
  int page = 1;
  bool isLastPage = false;

  int? doctorId;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getDoctor();
    future = getServiceResponseNew(id: doctorId != null ? getIntAsync(USER_ID) : doctorId, perPages: 15, page: page, serviceList: serviceList, getTotalService: (b) => total = b, lastPageCallback: (b) => isLastPage = b);
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
  void didUpdateWidget(covariant ServiceListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Widget body() {
    return SnapHelperWidget<List<ServiceData>>(
      future: future,
      loadingWidget: LoaderWidget(),
      onSuccess: (snap) {
        if (snap.isEmpty) {
          return NoDataFoundWidget(text: locale.lblNoDataFound);
        }

        return AnimatedScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
          disposeScrollController: true,
          listAnimationType: ListAnimationType.FadeIn,
          physics: AlwaysScrollableScrollPhysics(),
          slideConfiguration: SlideConfiguration(verticalOffset: 400),
          onSwipeRefresh: () async {
            page = 1;
            init();
            return await 2.seconds.delay;
          },
          onNextPage: () {
            if (!isLastPage) {
              page++;
              init();
              setState(() {});
            }
          },
          children: [
            Text(locale.lblServices + ' ($total)', style: boldTextStyle(size: titleTextSize)),
            16.height,
            AnimatedWrap(
              spacing: 16,
              runSpacing: 16,
              itemCount: snap.length,
              listAnimationType: ListAnimationType.Scale,
              itemBuilder: (context, index) {
                ServiceData data = snap[index];
                return Container(
                  width: context.width() / 2 - 24,
                  decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PriceWidget(price: data.charges.validate(), textSize: 24, textColor: primaryColor),
                          8.height,
                          Text(data.name.validate().capitalizeFirstLetter(), style: secondaryTextStyle()),
                          4.height,
                          Text(
                            '${listAppStore.doctorList.firstWhereOrNull((element) => element!.iD == data.doctor_id.toInt())?.display_name.validate()}',
                            style: boldTextStyle(),
                          ).visible(isReceptionist() && listAppStore.doctorList.isNotEmpty),
                        ],
                      ).paddingLeft(20).paddingTop(8).paddingBottom(8).paddingRight(8),
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 6,
                          decoration: boxDecorationDefault(
                            color: getServiceStatusColor(data.status.validate().toInt())!.withOpacity(0.5),
                            borderRadius: radiusOnly(topLeft: defaultRadius, bottomLeft: defaultRadius),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).onTap(
                  () async {
                    await AddServiceScreen(serviceData: data).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                    setState(() {});
                    init();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblServices, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Body(
        child: body(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await AddServiceScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide).then((value) {
            if (value) {
              setState(() {});
              init();
            }
          });
        },
      ),
    );
  }
}
