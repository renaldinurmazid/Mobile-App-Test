import 'dart:async';

import 'package:apptest/widget/bottom_ordered.dart';
import 'package:apptest/widget/bottom_sheet_first.dart';
import 'package:apptest/widget/bottom_sheet_select_type.dart';
import 'package:apptest/widget/google_maps.dart';
import 'package:flutter/material.dart';
import 'package:interactive_bottom_sheet/interactive_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _status = 'beforeOrder';
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadBookingStatus();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _loadBookingStatus();
    });
  }

  Future<void> _loadBookingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _status = prefs.getString('status') ?? 'beforeOrder';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MapSample(),
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
          child: _getBottomSheetContent(_status!),
        ),
      ),
    );
  }
    Widget _getBottomSheetContent(String status) {
    switch (status) {
      case 'beforeOrder':
        return const BottomSheetFirst();
      case 'afterOrder':
        return const Package();
      case 'ordered':
        return const BottomSheetOrdered();
      default:
        return const BottomSheetFirst();
    }
  }
}