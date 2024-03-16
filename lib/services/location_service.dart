import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

Future<bool> handlePermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  final GeolocatorPlatform geoLocator = GeolocatorPlatform.instance;
  serviceEnabled = await geoLocator.isLocationServiceEnabled();
  permission = await geoLocator.checkPermission();

  if (!serviceEnabled) {
    appStore.setLocationPermission(false);
    return false;
  }
  if (permission == LocationPermission.denied) {
    permission = await geoLocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
    appStore.setLocationPermission(false);
    return false;
  } else {
    appStore.setLocationPermission(true);
    return true;
  }
}

Future<Position> getUserLocationPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  LocationPermission permission = await Geolocator.checkPermission();
  if (!serviceEnabled) {
    //
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.openAppSettings();
      throw locale.lblPermissionDenied;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw 'Location Permission Denied Permanently';
  }

  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) {
    return value;
  }).catchError((e) async {
    return await Geolocator.getLastKnownPosition().then((value) async {
      if (value != null) {
        return value;
      } else {
        throw 'Enable Location';
      }
    }).catchError((e) {
      toast(e.toString());
    });
  });
}

Future<String> getUserLocation() async {
  Position position = await getUserLocationPosition().catchError((e) {
    throw e.toString();
  });

  return await buildFullAddressFromLatLong(position.latitude, position.longitude);
}

Future<String> buildFullAddressFromLatLong(double latitude, double longitude) async {
  List<Placemark> placeMark = await placemarkFromCoordinates(latitude, longitude).catchError((e) async {
    log(e);
    throw errorSomethingWentWrong;
  });

  setValue(SharedPreferenceKey.latitudeKey, latitude);
  setValue(SharedPreferenceKey.longitudeKey, longitude);

  Placemark place = placeMark[0];

  log(place.toJson());

  String address = '';

  if (!place.name.isEmptyOrNull && !place.street.isEmptyOrNull && place.name != place.street) address = '${place.name.validate()}, ';
  if (!place.street.isEmptyOrNull) address = '$address${place.street.validate()}';
  if (!place.locality.isEmptyOrNull) address = '$address, ${place.locality.validate()}';
  if (!place.administrativeArea.isEmptyOrNull) address = '$address, ${place.administrativeArea.validate()}';
  if (!place.postalCode.isEmptyOrNull) address = '$address, ${place.postalCode.validate()}';
  if (!place.country.isEmptyOrNull) address = '$address, ${place.country.validate()}';

  setValue(SharedPreferenceKey.currentAddressKey, address);

  return address;
}
