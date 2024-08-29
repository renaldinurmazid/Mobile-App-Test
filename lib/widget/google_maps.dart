import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  final locationController = Location();
  LatLng? currentPosition;
  late Timer _gpsCheckTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await initializeMap());
    startGpsCheckTimer(); 
  }

  @override
  void dispose() {
    _gpsCheckTimer.cancel(); 
    super.dispose();
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
  }

  Future<void> fetchLocationUpdates() async {
    await checkAndRequestGPS();

    locationController.onLocationChanged.listen((currentLocation) async {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        LatLng newLocation = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );

        setState(() {
          currentPosition = newLocation;
        });

        await saveLocationToPreferences(newLocation);

        GlobalLocation.currentLocation = newLocation;
      }
    });
  }

  Future<void> saveLocationToPreferences(LatLng location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', location.latitude);
    await prefs.setDouble('longitude', location.longitude);
    await prefs.setString('currentlocation', '${location.latitude},${location.longitude}');
  }

  Future<void> checkAndRequestGPS() async {
    bool serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void startGpsCheckTimer() {
    _gpsCheckTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      bool serviceEnabled = await locationController.serviceEnabled();
      if (!serviceEnabled) {
        await locationController.requestService();
      } else {
        await fetchLocationUpdates();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentPosition!,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    icon: AssetMapBitmap('assets/images/placeholder.png',width: 20,height: 20),
                    position: currentPosition!,
                  ),
                },
              ),
      );
}

class GlobalLocation {
  static LatLng? currentLocation;
}
