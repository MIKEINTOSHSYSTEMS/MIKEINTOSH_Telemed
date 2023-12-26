import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

class AppLoader extends StatelessWidget {
  final bool? visibleOn;
  final double? loaderSize;

  AppLoader({this.visibleOn, this.loaderSize});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) => LoaderWidget(size: loaderSize).visible(visibleOn ?? appStore.isLoading),
    );
  }
}
