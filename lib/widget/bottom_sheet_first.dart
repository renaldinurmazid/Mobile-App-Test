import 'package:apptest/pages/rute.dart';
import 'package:apptest/utils/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetFirst extends StatelessWidget {
  const BottomSheetFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Kemana Kamu Pergi?',
            style: pHeading
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal:10,vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Image(
                    image: AssetImage('assets/images/taxi.png'),
                    width: 50,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Dimana tujuanmu?',
                    style: pSubtitle,
                  ),
                ],
              ),
              
              IconButton(
                iconSize: 20,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue[800]),
                ),
                onPressed: (){
                  Get.to(const RuteScreen());
                }, 
                icon: const Icon(Icons.arrow_forward_rounded,color: Colors.white))
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12,width: 1),
              ),
              child: const Icon(Icons.access_time_filled_sharp,color: Colors.black54),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Jl. Ade Irma Suryani Nasution No.2, Karanganyar, Cigadung, Kec. Subang, Kabupaten Subang, Jawa Barat 41211',
                style: pAddress,
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ],
    );
  }
}