import 'package:flutter/material.dart';

class ColorConstants {
  static const Color primaryColor = Colors.black;
  static const Color primaryColorDark = Colors.black;
  static const Color accentColor = Colors.amber;
  static const Color backgroundColor = Colors.grey;
  static const Color scaffoldBackgroundColor = Colors.white;
  static const Color dividerColor = Colors.black12;
  static const Color cAppColorsGreen = Color(0xFF39AB3F);
  static const Color cAppColorsBlue = Color(0xFF69A979);
  static const int _cAppColorsBlueValue = 0xFF69A979;

  static const MaterialColor cAppColors =
      MaterialColor(_cAppColorsBlueValue, <int, Color>{
        50: Color(0xFFD7FDE1),
        100: Color(0xFFC0F1CD),
        200: Color(0xFFABE3BA),
        300: Color(0xFF91CCA0),
        400: Color(0xFF7CBB8C),
        500: Color(_cAppColorsBlueValue),
        600: Color(0xFF61A271),
        700: Color(0xFF579B68),
        800: Color(0xFF4D915E),
        900: Color(0xFF468C58),
      });
  static const int _cAppColorsRedValue = 0xFFC23F38;

  static const MaterialColor cAppColorsRed =
      MaterialColor(_cAppColorsRedValue, <int, Color>{
        50: Color(0xFFFF958E),
        100: Color(0xFFFD7B73),
        200: Color(0xFFF1675F),
        300: Color(0xFFE15851),
        400: Color(0xFFD24B44),
        500: Color(_cAppColorsRedValue),
        600: Color(0xFFB63730),
        700: Color(0xFFAB2F29),
        800: Color(0xFFA12721),
        900: Color(0xFF96211B),
      });

  static const int _cAppColorsYellowValue = 0xFFFFCD00;

  static const MaterialColor cAppColorsYellow =
      MaterialColor(_cAppColorsYellowValue, <int, Color>{
        50: Color(0xFFFFDB85),
        100: Color(0xFFFFD963),
        200: Color(0xD7FFD43E),
        300: Color(0xFFFFD428),
        400: Color(0xFFFFD21A),
        500: Color(_cAppColorsYellowValue),
        600: Color(0xFFE0B300),
        700: Color(0xFFBD9700),
        800: Color(0xFF9D8000),
        900: Color(0xFF806400),
      });
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
