import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void initializeOneSignal() async {
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.User.pushSubscription.optIn();
  OneSignal.login(userStore.userEmail.validate());
  OneSignal.User.setLanguage(appStore.selectedLanguageCode.validate());

  OneSignal.User.addTags(userStore.oneSignalTag);

  appStore.setPlayerId(OneSignal.User.pushSubscription.id.validate());
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    OneSignal.Notifications.displayNotification(event.notification.notificationId);
    return event.notification.display();
  });
  OneSignal.User.pushSubscription.addObserver((stateChanges) async {
    if (stateChanges.current.id.validate().isNotEmpty) {
      appStore.setPlayerId(stateChanges.current.id.validate());
    }
  });

  OneSignal.Notifications.addClickListener((event) {
    if (isPatient()) patientStore.setBottomNavIndex(1);
    if (isDoctor()) doctorAppStore.setBottomNavIndex(1);
  });
}
