import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:taskmanager/core/widgets/typography.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  final bool isOuterButton;
  final double borderRadius;
  final Color? outerBorderColor; // Use Material Design 3 color if null
  final Color? backgroundColor; // Use Material Design 3 color if null
  final Color? textColor; // Use Material Design 3 color if null
  final EdgeInsets padding;
  final Widget? child;
  final EdgeInsetsGeometry margin;
  final bool? disabled;
  final bool? isLoading;
  final double fontSize;

  const CustomButton({
    super.key,
    this.text = '',
    this.onPressed,
    this.isOuterButton = false,
    this.isLoading = false,
    this.disabled,
    this.borderRadius = 8.0,
    this.outerBorderColor,
    this.backgroundColor,
    this.margin = const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
    this.textColor,
    this.fontSize = 18,
    this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
  });
  static DateTime? _lastTapTime;
  static const Duration _debounceDuration =
      Duration(milliseconds: 500); 

  @override
  Widget build(BuildContext context) {
    // Use Material Design 3 colors as default values
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = backgroundColor ?? colorScheme.primary;
    final borderCol = outerBorderColor ?? colorScheme.primary;
    final txtColor =
        textColor ?? (isOuterButton ? borderCol : colorScheme.onPrimary);

    return Padding(
      padding: margin,
      child: onPressed == null || disabled == true || isLoading == true
          ? _content(context, bgColor, borderCol, txtColor)
          : Bounce(
              duration: Durations.short2,
              onPressed: () {
                final now = DateTime.now();
                if (_lastTapTime == null ||
                    now.difference(_lastTapTime!) > _debounceDuration) {
                  _lastTapTime = now;
                  onPressed?.call();
                }
              },
              child: _content(context, bgColor, borderCol, txtColor),
            ),
    );
  }

  Container _content(
      BuildContext context, Color bgColor, Color borderCol, Color txtColor) {
    return Container(
      decoration: BoxDecoration(
        color: disabled == true || isLoading == true || onPressed == null
            ? Theme.of(context).disabledColor.withValues(alpha: .5)
            : isOuterButton
                ? Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[850] // Dark mode background
                    : Colors.white // Light mode background
                : bgColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.8)
                : Colors.black.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 2),
          ),
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
        ],
        borderRadius: BorderRadius.circular(borderRadius),
        border: isOuterButton
            ? Border.all(
                color: borderCol,
                width: 1.0,
              )
            : null,
      ),
      padding: padding,
      child: Center(
        child: isLoading == true
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator.adaptive())
            : child ??
                AppTypography(
                  text: text,
                  color: txtColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
      ),
    );
  }
}
