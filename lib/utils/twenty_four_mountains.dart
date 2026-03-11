/// 24 Mountains (二十四山) - Feng Shui compass directions.
/// Each mountain spans 15°; used to convert degrees to traditional direction names.
const List<String> k24Mountains = [
  'Zi (子)',    // 0°   N
  'Gui (癸)',   // 15°
  'Chou (丑)',  // 30°  NE
  'Gen (艮)',   // 45°
  'Yin (寅)',   // 60°
  'Jia (甲)',   // 75°  E
  'Mao (卯)',   // 90°
  'Yi (乙)',    // 105°
  'Chen (辰)',  // 120° SE
  'Xun (巽)',   // 135°
  'Si (巳)',    // 150°
  'Bing (丙)',  // 165° S
  'Wu (午)',    // 180°
  'Ding (丁)',  // 195°
  'Wei (未)',   // 210° SW
  'Kun (坤)',   // 225°
  'Shen (申)',  // 240°
  'Geng (庚)',  // 255° W
  'You (酉)',   // 270°
  'Xin (辛)',   // 285°
  'Xu (戌)',    // 300° NW
  'Qian (乾)',  // 315°
  'Hai (亥)',   // 330°
  'Ren (壬)',   // 345°
];

/// Converts compass degrees (0–360) to 24 Mountains name.
/// Returns null if degrees cannot be parsed.
String? degreesTo24Mountains(String? degreesStr) {
  if (degreesStr == null || degreesStr.trim().isEmpty) return null;
  final d = double.tryParse(degreesStr.replaceAll('°', '').trim());
  if (d == null) return null;
  final normalized = d % 360;
  if (normalized < 0) return null;
  final index = (normalized / 15).round() % 24;
  return k24Mountains[index];
}

/// Converts compass degrees (0–360) to 24 Mountains name.
String? degreesTo24MountainsFromNum(double? degrees) {
  if (degrees == null) return null;
  final normalized = degrees % 360;
  if (normalized < 0) return null;
  final index = (normalized / 15).round() % 24;
  return k24Mountains[index];
}
