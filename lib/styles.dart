import 'package:flutter/material.dart';

const blackPrimary = Color(0xff373737);
const blackHover = Color(0x33373737);
const disabledBg = Color(0xffD9D9D9);
const greyTxt = Color(0xffB3B3B3);

final stroke = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 0.5
  ..color = blackPrimary;

const fontStyle = TextStyle(
  color: blackPrimary,
  letterSpacing: 0.5,
  fontWeight: FontWeight.w700,
  fontSize: 24,
);
