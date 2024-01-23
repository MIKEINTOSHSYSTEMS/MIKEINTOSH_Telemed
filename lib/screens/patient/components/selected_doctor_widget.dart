import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/main.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectedDoctorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (appointmentAppStore.mDoctorSelected != null)
        return Container(
          decoration: boxDecorationDefault(color: context.cardColor),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Doctor: ', style: secondaryTextStyle()),
              8.height,
              Marquee(
                child: Text("${appointmentAppStore.mDoctorSelected?.display_name.validate()}", style: boldTextStyle(size: 18)),
              ),
            ],
          ),
        );

      return Offstage();
    });
    return Container(
      decoration: boxDecorationDefault(color: context.cardColor),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Doctor: ', style: secondaryTextStyle()),
          8.height,
          Marquee(
            child: Observer(builder: (context) {
              return Text("Dr. ${appointmentAppStore.mDoctorSelected!.display_name.validate()}", style: boldTextStyle(size: 18));
            }),
          ),
        ],
      ),
    );
  }
}
