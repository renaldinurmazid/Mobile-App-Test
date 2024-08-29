import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomSheetOrdered extends StatelessWidget {
  const BottomSheetOrdered({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.car_repair, color: Colors.blue.shade900),
          const SizedBox(height: 10),
          Text(
            'Perjalanan diminta',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )
            )
          ),
          const SizedBox(height: 10),
          Text(
            'Mencari driver online...',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              )
            )
          ),
          const SizedBox(height: 5),
          const Image(
            image: AssetImage('assets/images/find_taxi.png'),
            width: 200,
          ),
          const SizedBox(height: 5),
          TextButton(onPressed: (){
            Get.dialog(
              AlertDialog(
              title: Text(
                'Batalkan perjalanan',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Apakah Anda yakin ingin membatalkan perjalanan ini?',
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Tidak',
                    style: GoogleFonts.poppins(color: Colors.blue),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.clear(); 
                    Get.back();
                    Get.snackbar('Perjalanan Dibatalkan', 'Perjalanan Anda telah berhasil dibatalkan.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue.shade900,
                        colorText: Colors.white);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                  ),
                  child: Text(
                    'Ya',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
            );
          }, child:Text('Batalkan perjalanan',style:GoogleFonts.poppins(
            textStyle:TextStyle(
              color: Colors.blue.shade900,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            )
          )))
        ],
      ),
    );
  }
}