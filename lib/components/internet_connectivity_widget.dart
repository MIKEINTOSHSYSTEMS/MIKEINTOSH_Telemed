import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/empty_error_state_component.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

class InternetConnectivityWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? retryCallback;
  InternetConnectivityWidget({required this.child, this.retryCallback});

  @override
  Widget build(BuildContext context) {
    if (appStore.isConnectedToInternet)
      return child;
    else
      return NoDataWidget(
        title: locale.lblNoInternetMsg,
        imageWidget: ErrorStateWidget(),
        onRetry: () {
          if (!appStore.isConnectedToInternet) toast(locale.lblNoInternetMsg);
          if (appStore.isConnectedToInternet) toast(locale.lblConnectedToInternet);

          if (appStore.isConnectedToInternet) retryCallback?.call();
        },
      );
  }
}
