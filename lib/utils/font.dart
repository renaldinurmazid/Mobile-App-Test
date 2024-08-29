import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle get pHeading => GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    )
);
TextStyle get pTitle => GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    )
);
TextStyle get pAddress => GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    )
);
TextStyle get pSubtitle => GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w200,
    )
);
TextStyle get pCardTitle => GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    )
);
TextStyle get pCardDesc => GoogleFonts.poppins(
    textStyle: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    )
);