import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class BouncerTapWidget extends StatelessWidget {
  const BouncerTapWidget({super.key, required this.child, this.onPressed});
  final Widget child;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Bounce(
        duration: Durations.short3,
        onPressed: onPressed ?? () {},
        child: child);
  }
}
