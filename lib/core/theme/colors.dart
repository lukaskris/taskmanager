import 'dart:ui';

const colorPrimary = Color(0xFF2D628B); // Primary Color
const colorSecondary =
    Color(0xFFB2E0E0); // A lighter, complementary secondary color
const colorPrimaryContainer = Color(0xFFB2D9D9); // A softer container color
const colorAccent = Color(0xFFB25050); // A deeper accent color for contrast

const colorSchedule1 = Color(0xFFFFA801);
const colorSchedule2 = Color(0xFFEB3B5A);
const colorSchedule3 = Color(0xFF669DF6);
const colorSchedule4 = Color(0xFF575FCF);
const colorRed = Color(0xFFEB3B5A);
const colorWhite = Color(0xFFF2F8FC);
const colorGrey40 = Color.fromARGB(219, 189, 189, 189);
const colorBackground = Color(0xf7f7f7f7);
const colorBgGreen = Color(0xFF20BB34);
const colorTextBlack = Color(0xFF202124);
const colorOutline = Color(0xFF837377);
const colorOutlineVariant = Color(0xFFCAC4D0);

const colorPrimaryLight = Color(0xFFB69260);
const colorPrimaryContainerLight = Color(0xFFE2D3BF);
const colorOnsurfaceVariant = Color(0xFFB69260);
const colorSurfaceContainerHigh = Color(0xFFF8F4EF);

class ColorPair {
  final Color lightBg;
  final Color lightText;
  final Color darkBg;
  final Color darkText;

  const ColorPair(this.lightBg, this.lightText, this.darkBg, this.darkText);
}

const List<ColorPair> chipColors = [
  ColorPair(Color(0xFFE3F2FD), Color(0xFF0D47A1), Color(0xFF1565C0),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFF1F8E9), Color(0xFF33691E), Color(0xFF558B2F),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFFFEBEE), Color(0xFFB71C1C), Color(0xFFD32F2F),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFFFF3E0), Color(0xFFBF360C), Color(0xFFEF6C00),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFEDE7F6), Color(0xFF4A148C), Color(0xFF7E57C2),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFE0F2F1), Color(0xFF004D40), Color(0xFF26A69A),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFFFF9C4), Color(0xFFF57F17), Color(0xFFFFB300),
      Color(0xFF000000)),
  ColorPair(Color(0xFFF3E5F5), Color(0xFF6A1B9A), Color(0xFFBA68C8),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFD7CCC8), Color(0xFF3E2723), Color(0xFF8D6E63),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFC8E6C9), Color(0xFF1B5E20), Color(0xFF43A047),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFBBDEFB), Color(0xFF0D47A1), Color(0xFF42A5F5),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFFFCDD2), Color(0xFFC62828), Color(0xFFE57373),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFFFF8E1), Color(0xFFF57F17), Color(0xFFFFA726),
      Color(0xFF000000)),
  ColorPair(Color(0xFFE1F5FE), Color(0xFF01579B), Color(0xFF4FC3F7),
      Color(0xFFFFFFFF)),
  ColorPair(Color(0xFFFCE4EC), Color(0xFF880E4F), Color(0xFFF06292),
      Color(0xFFFFFFFF)),
];
