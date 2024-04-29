import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Texts extends StatelessWidget {
  final String text;
  final Color? colour;
  final double? fontsize;
  final FontWeight? fontweight;

  const Texts({super.key,
    required this.text,
    required this.colour,
    required this.fontsize,
    required this.fontweight
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: colour,
          fontSize: fontsize,
          fontWeight: fontweight,
          inherit: false,
        )
      ),
    );
  }
}
