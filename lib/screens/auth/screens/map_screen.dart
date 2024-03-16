import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/services/location_service.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class MapScreen extends StatefulWidget {
  final double? latLong;
  final double? latitude;

  MapScreen({this.latLong, this.latitude});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  late GoogleMapController mapController;

  String _currentAddress = '';

  final destinationAddressController = TextEditingController();
  final destinationAddressFocusNode = FocusNode();

  String _destinationAddress = '';

  Set<Marker> markers = {};

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      _getCurrentLocation();
    });
  }

  // Method for retrieving the current location
  void _getCurrentLocation() async {
    appStore.setLoading(true);
    await getUserLocationPosition().then((position) async {
      setAddress();

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 18.0),
        ),
      );

      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(_currentAddress),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Start $_currentAddress', snippet: _destinationAddress),
        icon: BitmapDescriptor.defaultMarker,
      ));

      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  // Method for retrieving the address
  Future<void> setAddress() async {
    try {
      Position position = await getUserLocationPosition().catchError((e) {
        toast(e.toString());
        throw e.toString();
      });

      _currentAddress = await buildFullAddressFromLatLong(position.latitude, position.longitude).catchError((e) {
        log(e);
      });
      destinationAddressController.text = _currentAddress;
      _destinationAddress = _currentAddress;

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  _handleTap(LatLng point) async {
    appStore.setLoading(true);

    markers.clear();
    markers.add(Marker(
      markerId: MarkerId(point.toString()),
      position: point,
      infoWindow: InfoWindow(),
      icon: BitmapDescriptor.defaultMarker,
    ));

    destinationAddressController.text = await buildFullAddressFromLatLong(point.latitude, point.longitude).catchError((e) {
      log(e);
    });

    _destinationAddress = destinationAddressController.text;

    appStore.setLoading(false);
    setState(() {});
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget(
        locale.chooseFromMap,
        elevation: 0,
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set<Marker>.from(markers),
            initialCameraPosition: _initialLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onTap: _handleTap,
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.blue.shade100,
                    child: InkWell(
                      splashColor: context.primaryColor.withOpacity(0.8),
                      child: SizedBox(width: 50, height: 50, child: Icon(Icons.add)),
                      onTap: () {
                        mapController.animateCamera(CameraUpdate.zoomIn());
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ClipOval(
                  child: Material(
                    color: Colors.blue.shade100,
                    child: InkWell(
                      splashColor: context.primaryColor.withOpacity(0.8),
                      child: SizedBox(width: 50, height: 50, child: Icon(Icons.remove)),
                      onTap: () {
                        mapController.animateCamera(CameraUpdate.zoomOut());
                      },
                    ),
                  ),
                ),
              ],
            ).paddingLeft(10),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.orange.shade100, // button color
                    child: Icon(Icons.my_location, size: 25).paddingAll(10),
                  ),
                ).paddingRight(8).onTap(() async {
                  appStore.setLoading(true);

                  await getUserLocationPosition().then((value) {
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 18.0),
                      ),
                    );

                    _handleTap(LatLng(value.latitude, value.longitude));
                  }).catchError(onError);

                  appStore.setLoading(false);
                }),
                8.height,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppTextField(
                      textFieldType: TextFieldType.MULTILINE,
                      controller: destinationAddressController,
                      focus: destinationAddressFocusNode,
                      textStyle: primaryTextStyle(),
                      decoration: inputDecoration(context: context, labelText: locale.lblAddress).copyWith(fillColor: Colors.white70),
                    ),
                  ],
                ),
                8.height,
                AppButton(
                  width: context.width(),
                  height: 16,
                  color: primaryColor.withOpacity(0.8),
                  text: locale.lblSetAddress,
                  textStyle: boldTextStyle(color: white, size: 12),
                  onTap: () {
                    if (destinationAddressController.text.isNotEmpty) {
                      finish(context, destinationAddressController.text);
                    } else {
                      toast(locale.lblPickAddress);
                    }
                  },
                ),
                8.height,
              ],
            ).paddingAll(16),
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
