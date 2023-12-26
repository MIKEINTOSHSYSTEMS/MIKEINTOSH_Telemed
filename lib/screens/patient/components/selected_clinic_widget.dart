import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectedClinicWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (appointmentAppStore.mClinicSelected != null)
        return Container(
          decoration: boxDecorationDefault(color: context.cardColor),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Clinic: ', style: secondaryTextStyle()),
              8.height,
              Marquee(
                child: Text("${appointmentAppStore.mClinicSelected?.clinic_name.validate()}", style: boldTextStyle(size: 18)),
              ),
            ],
          ),
        );

      return Offstage();
    });
  }
}
