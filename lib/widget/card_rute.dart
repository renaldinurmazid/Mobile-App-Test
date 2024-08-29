import 'package:apptest/utils/font.dart';
import 'package:flutter/material.dart';

class CardRuteWidget extends StatefulWidget {
  const CardRuteWidget({super.key, required this.title, required this.address, required this.onPressesremove, required this.onPressesposition,});
  final String title;
  final String address;
  final Function() onPressesremove;
  final Function() onPressesposition;

  @override
  State<CardRuteWidget> createState() => _CardRuteWidgetState();
}

class _CardRuteWidgetState extends State<CardRuteWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: pCardTitle,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.address,
                  style: pAddress,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    iconSize: 15,
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20, 
                    ),
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      foregroundColor: Colors.grey.shade200,
                    ),
                    onPressed: widget.onPressesremove,
                    icon: const Icon(Icons.close)),
                  const SizedBox(
                    width: 1,
                    height: 25, 
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onPressesposition, child: Text('Peta',style: pCardTitle,))
                ],
              ) 
            ],
          )
        ],
      ),
    );
  }
}