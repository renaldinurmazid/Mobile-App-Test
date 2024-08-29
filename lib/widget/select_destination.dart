import 'package:apptest/widget/google_maps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelecDestination extends StatefulWidget {
  const SelecDestination({super.key});

  @override
  State<SelecDestination> createState() => _SelecDestinationState();
}

class _SelecDestinationState extends State<SelecDestination> {
  late GoogleMapController mapController;
  LatLng _selectedLocation = GlobalLocation.currentLocation!; 
  Marker? _destinationMarker;

  @override
  void initState() {
    super.initState();
    _destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: _selectedLocation,
      infoWindow: const InfoWindow(
        title: 'Tujuan',
        snippet: 'Lokasi tujuan Anda',
      ),
    );
  }

  void _updateMarker(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _destinationMarker = Marker(
        markerId: const MarkerId('destination'),
        position: _selectedLocation,
        icon: AssetMapBitmap('assets/images/pin.png',width: 30,height: 30),
        infoWindow: const InfoWindow(
          title: 'Tujuan anda',
        ),
      );
    });
  }

  Future<void> saveLocationToPreferences(LatLng location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('deslatitude', location.latitude);
    await prefs.setDouble('deslongitude', location.longitude);
    await prefs.setString('destinationlocation', '${location.latitude},${location.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onCameraMove: (CameraPosition position) {
              _updateMarker(position.target);
            },
            markers: {
              _destinationMarker!,
              Marker(
                infoWindow: const InfoWindow(
                  title: 'Lokasi anda',
                ),
                icon: AssetMapBitmap('assets/images/placeholder.png',width: 30,height: 30),
                markerId: const MarkerId('currentLocation'), 
                position: GlobalLocation.currentLocation!),
            },
          ),
          Positioned(
            bottom: 20,
            left: 60,
            right: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade800,
              ),
              onPressed: () async{
                await saveLocationToPreferences(_selectedLocation);
                Get.back();
              },
              child: const Text('Pilih Lokasi'),
            ),
          ),
        ],
      ),
    );
  }
}
