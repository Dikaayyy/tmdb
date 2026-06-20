import 'package:flutter/material.dart';

class MovieImageScrim extends StatelessWidget {
  const MovieImageScrim({
    super.key,
    this.padding,
    this.child,
  });

  final EdgeInsetsGeometry? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.20),
      ),
      child: child,
    );
  }
}
