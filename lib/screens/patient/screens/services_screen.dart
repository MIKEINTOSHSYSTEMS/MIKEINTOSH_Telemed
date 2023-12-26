import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/patient_dashboard_model.dart';
import 'package:kivicare_flutter/screens/patient/components/category_widget.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';

class ServicesScreen extends StatelessWidget {
  final List<Service> servicesList;

  ServicesScreen({Key? key, required this.servicesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        locale.lblService,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: AnimatedWrap(
          direction: Axis.horizontal,
          spacing: 16,
          runSpacing: 16,
          listAnimationType: ListAnimationType.Scale,
          itemCount: servicesList.length,
          itemBuilder: (context, index) {
            return CategoryWidget(data: servicesList[index], width: context.width() / 4 - 22, index: index);
          },
        ),
      ),
    );
  }
}
