import 'package:flutter/material.dart';

class AppErrorToast extends StatelessWidget {
  const AppErrorToast({required this.message, super.key});

  final String message;

  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: 24,
        right: 24,
        top: MediaQuery.paddingOf(context).top + 16,
        child: IgnorePointer(
          child: Center(child: AppErrorToast(message: message)),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(duration, entry.remove);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 342),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: ShapeDecoration(
            color: const Color(0xFFFEF2F2),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0x19DC2626)),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFA0A0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 12,
                  color: Color(0xFFB91C1C),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFFB91C1C),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
