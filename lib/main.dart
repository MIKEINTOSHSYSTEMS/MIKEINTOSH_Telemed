import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kivicare_flutter/app_theme.dart';
import 'package:kivicare_flutter/config.dart';
import 'package:kivicare_flutter/locale/app_localizations.dart';
import 'package:kivicare_flutter/locale/base_language_key.dart';
import 'package:kivicare_flutter/locale/language_en.dart';
import 'package:kivicare_flutter/model/language_model.dart';
import 'package:kivicare_flutter/model/user_permission.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/network/google_repository.dart';
import 'package:kivicare_flutter/network/services/default_firebase_config.dart';
import 'package:kivicare_flutter/screens/patient/store/patient_store.dart';
import 'package:kivicare_flutter/screens/splash_screen.dart';
import 'package:kivicare_flutter/store/AppStore.dart';
import 'package:kivicare_flutter/store/AppointmentAppStore.dart';
import 'package:kivicare_flutter/screens/doctor/store/DoctorAppStore.dart';
import 'package:kivicare_flutter/store/ListAppStore.dart';
import 'package:kivicare_flutter/store/MultiSelectStore.dart';
import 'package:kivicare_flutter/screens/receptionist/store/ReceptionistAppStore.dart';
import 'package:kivicare_flutter/store/PermissionStore.dart';
import 'package:kivicare_flutter/store/ShopStore.dart';
import 'package:kivicare_flutter/store/UserStore.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'utils/app_common.dart';

late PackageInfoData packageInfo;

late StreamSubscription<ConnectivityResult> _connectivitySubscription;

AppStore appStore = AppStore();
PatientStore patientStore = PatientStore();
ListAppStore listAppStore = ListAppStore();
AppointmentAppStore appointmentAppStore = AppointmentAppStore();
MultiSelectStore multiSelectStore = MultiSelectStore();
DoctorAppStore doctorAppStore = DoctorAppStore();
ReceptionistAppStore receptionistAppStore = ReceptionistAppStore();
PermissionStore permissionStore = PermissionStore();
ShopStore shopStore = ShopStore();

UserStore userStore = UserStore();
ListAnimationType listAnimationType = ListAnimationType.FadeIn;
PageRouteAnimation pageAnimation = PageRouteAnimation.Fade;

Duration pageAnimationDuration = Duration(milliseconds: 500);

List<String> paymentMethodList = [];
List<String> paymentMethodImages = [];
List<String> paymentModeList = [];

BaseLanguage locale = LanguageEn();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  defaultBlurRadius = 0;
  defaultSpreadRadius = 0.0;

  defaultAppBarElevation = 2;
  appBarBackgroundColorGlobal = primaryColor;
  appButtonBackgroundColorGlobal = primaryColor;

  defaultAppButtonTextColorGlobal = Colors.white;
  defaultAppButtonElevation = 0.0;
  passwordLengthGlobal = 5;
  defaultRadius = 12;
  defaultLoaderAccentColorGlobal = primaryColor;

  await initialize(aLocaleLanguageList: languageList());

  Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions).then((value) {
    setupRemoteConfig();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  });

  appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE));
  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));

  await defaultValue();

  HttpOverrides.global = HttpOverridesSkipCertificate();

  packageInfo = await getPackageInfo();

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == THEME_MODE_LIGHT) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == THEME_MODE_DARK) {
    appStore.setDarkMode(true);
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((event) {
      appStore.setInternetStatus(event == ConnectivityResult.mobile || event == ConnectivityResult.wifi);
    });
    OneSignal.initialize(ONESIGNAL_APP_ID);
    OneSignal.Notifications.requestPermission(true);

    OneSignal.Notifications.addClickListener((event) {
      if (isPatient()) patientStore.setBottomNavIndex(1);
      if (isDoctor()) doctorAppStore.setBottomNavIndex(1);
      if (isReceptionist()) receptionistAppStore.setBottomNavIndex(1);
    });
    removePermission();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        title: APP_NAME,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        navigatorKey: navigatorKey,
        supportedLocales: Language.languagesLocale(),
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode),
        localizationsDelegates: [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
