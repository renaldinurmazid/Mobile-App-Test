import 'dart:async';

import 'package:apptest/model/package.dart';
import 'package:apptest/pages/pembayaran.dart';
import 'package:apptest/utils/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selectable_container/selectable_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Package extends StatefulWidget {
  const Package({super.key});

  @override
  State<Package> createState() => _PackageState();
}

class _PackageState extends State<Package> {
  List<CarType> packages = [
    CarType(name: "Economy", capacity: 3, price: 100.35, desc: "Most economical choice", id: 0),
    CarType(name: "Plus", capacity: 4, price: 143.53, desc: "Additional space & comfort", id: 1),
    CarType(name: "Premium", capacity: 5, price: 186.70, desc: "Luxury experience", id: 2),
  ];

  int? selectedPackageId;
  CarType? selectedPackage;
  String? _assets;
  String? _title;

  bool _isSelectPayment = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadPaymentStatus();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _loadPaymentStatus();
    });
  }

  Future<void> _loadPaymentStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _assets = prefs.getString('assets');
      _title = prefs.getString('title');
      _isSelectPayment = prefs.getBool('isSelectPayment') ?? false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: packages.length,
          itemBuilder:(context, index) {
            return card(packages[index]);
          }, 
        ),
        const SizedBox(height:10),
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isSelectPayment ? Colors.grey.shade200 : Colors.orange.shade800
            ),
            color: _isSelectPayment ? Colors.white : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Row(
                children: [
                  const SizedBox(width: 30),
                  Image(
                    image: AssetImage(_assets ?? 'assets/images/wallet.png'),
                    width: 20,
                  ),
                  const SizedBox(width: 20),
                  Text(_title ?? 'Select payment method', style: GoogleFonts.poppins(textStyle: TextStyle(color: _isSelectPayment ? Colors.black : Colors.orange.shade800, fontSize: 15,fontWeight: FontWeight.w500))),
                ],
              ),
              IconButton(
                onPressed: selectedPackage == null
                ? null
                : () {
                    Get.to(
                      const PaymentScreen(),
                      arguments: {'price': selectedPackage!.price},
                    );
                  },
                icon: Icon(Icons.arrow_forward_ios_rounded, color: _isSelectPayment ? Colors.grey.shade400 : Colors.orange.shade800),
              )
            ]
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.grey.shade200,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.article_outlined, color: Colors.blue.shade900,size: 20),
                TextButton(
                  onPressed: (){},
                  child:Text('Preferensi berkendara', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.blue.shade900,fontSize: 12))) ,
                )
              ],
            ),
            Row(
              children: [
                Icon(Icons.card_membership, color: Colors.blue.shade900,size: 20),
                TextButton(
                  onPressed: (){},
                  child:Text('Kode Kupon', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.blue.shade900,fontSize: 12))) ,
                )
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                shape:  WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                iconColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.all(_isSelectPayment ? Colors.blue.shade900 : Colors.grey.shade200),
              ),
              onPressed: _isSelectPayment ? (){} : null, 
              label: const Icon(Icons.calendar_month_outlined),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  shape:  WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                  iconColor: WidgetStateProperty.all(Colors.grey.shade200),
                  backgroundColor: WidgetStateProperty.all(_isSelectPayment ? Colors.blue.shade900 : Colors.grey.shade200),
                ),
                onPressed: _isSelectPayment ? ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('status', 'ordered');
                } : null, 
                label: Text('Pesan sekarang',style:GoogleFonts.poppins(
                  textStyle:const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)
                )),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget card(CarType package){
    return SelectableContainer(
      selectedBackgroundColor: Colors.white,
      unselectedBackgroundColor: Colors.white,
      marginColor: Colors.transparent,
      unselectedBorderColor: Colors.transparent,
      selectedBorderColor: Colors.blue.shade900,
      selectedBackgroundColorIcon: Colors.blue.shade900,
      padding: 5,
      unselectedOpacity: 0.5,
      selected: selectedPackageId == package.id,
      onValueChanged: (newValue) {
        setState(() {
          if (newValue) {
            selectedPackageId = package.id;
            selectedPackage = package;
          } else {
            selectedPackageId = null;
            selectedPackage = null;
          }
        });
      },
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Image(
                image: AssetImage('assets/images/car.png'),
                width: 50,
              ),
              const SizedBox(width: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        package.name,
                        style:GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.grey.shade900,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          )
                        )
                      ),
                      Badge(
                        backgroundColor: Colors.transparent,
                        label:  Text(package.capacity.toString(), style: pCardTitle),
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(Icons.person, color: Colors.grey.shade500,size:20),
                      )
                    ],
                  ),
                  Text(
                    package.desc,
                    style:pCardTitle
                  )
                ],
              ),
            ],
          ),
          
          Text(
            '\$${package.price}',
            style:GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              )
            )
          ),
        ]
      ),
    );
  }
}