import 'dart:ui';

import 'package:amekopro/utils/hex_color.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassyButton extends StatefulWidget {
  const GlassyButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.showIcon});

  final VoidCallback onTap;
  final String text;
  final bool showIcon;

  @override
  State<GlassyButton> createState() => _GlassyButtonState();
}

class _GlassyButtonState extends State<GlassyButton> {
  double turns = 0.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          setState(() {
            turns += 0.5;
          });
          widget.onTap();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 8,
              sigmaY: 8,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: GoogleFonts.sora(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: HexColor("D9E0A4"),
                      ),
                    ),
                    if (widget.showIcon)
                      const SizedBox(
                        width: 8,
                      ),
                    if (widget.showIcon)
                      AnimatedRotation(
                        turns: turns,
                        duration: const Duration(milliseconds: 200),
                        child: SvgPicture.asset("assets/arrow-up.svg"),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
