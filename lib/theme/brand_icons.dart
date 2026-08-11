import 'package:flutter/material.dart';

/// Social brand glyphs.
///
/// Official Lucide no longer ships brand icons; these Material stand-ins keep
/// [Icon]/IconData] call sites compiling on Flutter 3.44+.
abstract final class BrandIcons {
  static const IconData facebook = Icons.facebook;
  static const IconData instagram = Icons.camera_alt_rounded;
}
