import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class FloatingBottomNavBar extends StatelessWidget {
  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final List<FloatingBottomNavBarItem> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFEEEEEE)),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(items.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : 12),
                  child: _FloatingBottomNavItem(
                    item: items[index],
                    isSelected: currentIndex == index,
                    onTap: () => onItemSelected(index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class FloatingBottomNavBarItem {
  const FloatingBottomNavBarItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class _FloatingBottomNavItem extends StatefulWidget {
  const _FloatingBottomNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final FloatingBottomNavBarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_FloatingBottomNavItem> createState() => _FloatingBottomNavItemState();
}

class _FloatingBottomNavItemState extends State<_FloatingBottomNavItem>
    with SingleTickerProviderStateMixin {
  static const _collapsedWidth = 40.0;
  static const _iconSize = 16.0;
  static const _labelGap = 6.0;
  static const _horizontalPadding = 30.0;

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: widget.isSelected ? 1 : 0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void didUpdateWidget(covariant _FloatingBottomNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isSelected == widget.isSelected) return;

    if (widget.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final labelWidth = _measureLabelWidth(context);
        final expandedWidth =
            _iconSize + _labelGap + labelWidth + _horizontalPadding;
        final width = _lerp(_collapsedWidth, expandedWidth, _animation.value);
        final backgroundColor = Color.lerp(
          Colors.transparent,
          AppColors.primary,
          _animation.value,
        );
        final iconColor = Color.lerp(
          AppColors.textSecondary,
          const Color(0xFFFAFAFA),
          _animation.value,
        );

        return Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(999),
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            child: SizedBox(
              width: width,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.item.icon, size: _iconSize, color: iconColor),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: _animation.value,
                      child: Opacity(
                        opacity: _animation.value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: _labelGap),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Text(
        widget.item.label,
        maxLines: 1,
        overflow: TextOverflow.clip,
        softWrap: false,
        style: const TextStyle(
          color: Color(0xFFFAFAFA),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  double _measureLabelWidth(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final painter = TextPainter(
      text: TextSpan(
        text: widget.item.label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: textScaler,
    )..layout();

    return painter.width;
  }

  double _lerp(double start, double end, double value) {
    return start + (end - start) * value;
  }
}
