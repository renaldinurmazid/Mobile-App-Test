import 'dart:async';

import 'package:apptest/utils/font.dart';
import 'package:apptest/widget/card_rute.dart';
import 'package:apptest/widget/select_destination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:apptest/widget/google_maps.dart';

class RuteScreen extends StatefulWidget {
  const RuteScreen({super.key});

  @override
  State<RuteScreen> createState() => _RuteScreenState();
}

class _RuteScreenState extends State<RuteScreen> {
  String addressMe = 'Alamat...';
  String destination = 'Alamat...';
  String pick = 'Alamat...';
  LatLng? currentLocation = GlobalLocation.currentLocation;
  LatLng? destinationLocation;
  Timer? timer;
  
  Future<void> getAddress() async {
    if (currentLocation == null) return;
    
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation!.latitude, 
        currentLocation!.longitude
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          addressMe = '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}';
        });
      }
    } catch (e) {
      setState(() {
        addressMe = 'Failed to get address: $e';
      });
    }
  }

  Future<void> getDestination() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('deslatitude');
    double? longitude = prefs.getDouble('deslongitude');

    if (latitude != null && longitude != null) {
      destinationLocation = LatLng(latitude, longitude);

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          setState(() {
            destination = '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}';
          });
        }
      } catch (e) {
        setState(() {
          destination = 'Failed to get address: $e';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (currentLocation != null) {
      getAddress();
    }
    getDestination();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      getAddress();
      getDestination();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:Text('Rute Anda',style: pTitle),
      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child:Column(
          children: [
            TimelineTile(
              alignment: TimelineAlign.end,
              hasIndicator: true,
              indicatorStyle: IndicatorStyle(
                drawGap: true,
                width: 30,
                iconStyle:  IconStyle(
                  iconData: Icons.location_searching,
                  fontSize: 15,
                  color: Colors.white
                ),
                color: Colors.blue.shade400,
                padding: const EdgeInsets.only(left: 10, right: 10),
              ),
              afterLineStyle:LineStyle(
                color: Colors.blue.shade400,
                thickness: 3,
              ),
              isFirst: true,
              startChild: CardRuteWidget(title: 'Titik penjemputan',address: addressMe,onPressesposition: (){} ,onPressesremove: (){},)
            ),
          const SizedBox(height: 10),
            TimelineTile(
              alignment: TimelineAlign.end,
              hasIndicator: true,
              indicatorStyle: IndicatorStyle(
                drawGap: true,
                width: 30,
                iconStyle:  IconStyle(
                  iconData: Icons.location_pin,
                  fontSize: 15,
                  color: Colors.white
                ),
                color: Colors.cyan.shade200,
                padding: const EdgeInsets.only(left: 10, right: 10),
              ),
              afterLineStyle:LineStyle(
                color: Colors.cyan.shade200,
                thickness: 3,
              ),
              beforeLineStyle: LineStyle(
                color: Colors.blue.shade400,
                thickness: 3,
              ),
              startChild: CardRuteWidget(title: 'Titik berhenti',address: destination,onPressesposition: (){Get.to(() => const SelecDestination());},onPressesremove: ()async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('deslatitude');
                await prefs.remove('deslongitude');
                setState(() {
                  destination = 'Alamat...';
                });
              })
            ),
            const SizedBox(height: 10),
            TimelineTile(
              alignment: TimelineAlign.end,
              hasIndicator: true,
              isLast: true,
              indicatorStyle: IndicatorStyle(
                drawGap: true,
                width: 30,
                iconStyle:  IconStyle(
                  iconData: Icons.location_pin,
                  fontSize: 15,
                  color: Colors.white
                ),
                color: Colors.cyan.shade200,
                padding: const EdgeInsets.only(left: 10, right: 10),
              ),
              afterLineStyle:LineStyle(
                color: Colors.cyan.shade200,
                thickness: 3,
              ),
              beforeLineStyle: LineStyle(
                color: Colors.cyan.shade200,
                thickness: 3,
              ),
              startChild: CardRuteWidget(title: 'Daerah menurunkan barang atau penumpang.', address:pick,onPressesposition: (){},onPressesremove: (){},)
            ),
            const SizedBox(height: 280),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade800,
              ),
              onPressed: ()async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                // ignore: unnecessary_null_comparison
                if(destinationLocation != null){
                  await prefs.setString('status', 'afterOrder');
                  Get.back(result: true);
                }else{
                  Get.snackbar('Attention', 'Please isi titik berhenti anda.');
                }
              }, 
              child: Text('Mengonfirmasi', style: GoogleFonts.poppins(),)
            )
          ],
        )
      )
    );
  }
}