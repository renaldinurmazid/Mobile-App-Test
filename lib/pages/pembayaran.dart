import 'package:apptest/utils/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interactive_bottom_sheet/interactive_bottom_sheet.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
  
}

class _PaymentScreenState extends State<PaymentScreen> {

  String? _selectedPaymentMethod;
  bool _selected = false;

  String? assets;
  String? title;
  bool _isSelectPayment = false;


  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final price = args['price'] as double;
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
        title:Text('Pembayaran',style: pTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: DashedBorder.fromBorderSide(
                dashLength: 5, side: BorderSide(color: Colors.blue.shade700, width: 2)),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  rowText('Biaya jasa',price.toString()),
                  const SizedBox(height: 10),
                  rowText('Biaya opsi layanan','0,0'),
                  const SizedBox(height: 10),
                  rowText('Diskon kupon','0,0'),
                  Divider(
                    color: Colors.grey.shade500,
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
                  rowText('Kredit Dompet','0,0'),
                ],
              ),
            ),
            Positioned(
              bottom: -25, 
              left: 80, 
              right: 80,
              child: Container(
                decoration: const BoxDecoration(
                  gradient:LinearGradient(
                    colors: [Colors.blue, Colors.cyan],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius:BorderRadius.all(Radius.circular(10)),
                ),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total harga',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )
                    )),
                    const SizedBox(width: 10),
                    Text(
                      '\$${price.toString()}',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        )
                    )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: InteractiveBottomSheet(
        draggableAreaOptions:const DraggableAreaOptions(
          topBorderRadius: 30,
          height: 35,
          indicatorColor: Colors.grey
        ),
        options:const InteractiveBottomSheetOptions(
          maxSize: 0.5,
          initialSize: 0.3,
          minimumSize: 0.3
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pilih metode pembayaran:',
                  style: pHeading
                ),
              ),
              const SizedBox(height: 10),
              SelectionArea(
                child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Image(
                            image: AssetImage('assets/images/binance.png'),
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Binance',
                            style: pCardDesc,
                          ),
                        ],
                      ),
                      Radio(
                        value: 'binance',
                        activeColor: Colors.blue,
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            assets = 'assets/images/binance.png';
                            title = 'Binance';
                            _selected = true;
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Image(
                            image: AssetImage('assets/images/dollar.png'),
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Bayar tunai',
                            style: pCardDesc,
                          ),
                        ],
                      ),
                      Radio(
                        value: 'tunai',
                        activeColor: Colors.blue,
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            assets = 'assets/images/dollar.png';
                            title = 'Bayar tunai';
                            _selected = true;
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height:20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      foregroundColor: Colors.white,
                      backgroundColor: _selected ? Colors.blue.shade900 : Colors.grey.shade200,
                    ),
                    onPressed: _selectedPaymentMethod != null
                          ? () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              if (assets != null && title != null) {
                                await prefs.setString('assets', assets!);
                                await prefs.setString('title', title!);
                                await prefs.setBool('isSelectPayment', true);
                                Get.back(result: _selectedPaymentMethod);
                              } else {
                                Get.snackbar('Attention', 'Please pilih metode pembayaran anda.');
                              }
                            }
                          : null,
                    child: Text('Mengonfirmasi', style: GoogleFonts.poppins(),)
                  )
                ]
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget rowText(String title,String price){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: pCardDesc
        ),
        Text(
          '\$$price',
          style: pCardDesc
        ),
      ],
    );
  }
}