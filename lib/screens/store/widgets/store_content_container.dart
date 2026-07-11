import 'package:flutter/material.dart';

import '../../../utils/breakpoints.dart';

/// Max-width content wrapper used on store-related pages.
class StoreContentContainer extends StatelessWidget {
  const StoreContentContainer({
    super.key,
    required this.child,
    this.maxWidth = 1100,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return Padding(
      padding: EdgeInsets.only(
        top: isNarrow ? 40 : 56,
        bottom: isNarrow ? 48 : 64,
        left: isNarrow ? 16 : 24,
        right: isNarrow ? 16 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
