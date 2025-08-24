import 'package:flutter/material.dart';

class AppTypography extends StatelessWidget {
  final String text;
  final String? semanticsLabel;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final int? lines;
  final Icon? icon;

  const AppTypography({
    super.key,
    required this.text,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.clip,
    this.maxLines,
    this.lines,
    this.semanticsLabel,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive font size based on screen size
    double responsiveFontSize =
        fontSize * MediaQuery.of(context).textScaleFactor;

    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: icon!,
            ),
          Expanded(
            child: Text(
              (lines ?? 0) > 1 ? '$text\n' : text,
              style: TextStyle(
                fontSize: responsiveFontSize,
                fontWeight: fontWeight,
                color: color,
              ),
              textAlign: textAlign,
              overflow: overflow,
              maxLines: maxLines,
              semanticsLabel: semanticsLabel,
            ),
          ),
        ],
      ),
    );
  }
}
