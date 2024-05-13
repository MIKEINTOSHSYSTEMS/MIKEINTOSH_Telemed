import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/model/woo_commerce/common_models.dart';
import 'package:kivicare_flutter/utils/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class SortFilterBottomSheet extends StatelessWidget {
  final Function(FilterModel? filter)? onTapCall;
  SortFilterBottomSheet({this.onTapCall});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getProductFilters()
            .map(
              (e) => TextIcon(
                onTap: () {
                  afterBuildCreated(() {
                    onTapCall?.call(e);
                  });
                },
                text: e.title.validate(),
              ).paddingSymmetric(vertical: 8),
            )
            .toList(),
      ),
    );
  }
}
