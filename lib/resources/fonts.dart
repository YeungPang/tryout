import 'package:flutter/material.dart';
import 'package:tryout/model/locator.dart';

final fontScale = model.fontScale;

final fsize24 = 24.0 * fontScale;
final fsize22 = 22.0 * fontScale;
final fsize20 = 20.0 * fontScale;
final fsize18 = 18.0 * fontScale;
final fsize16 = 16.0 * fontScale;
final fsize14 = 14.0 * fontScale;
final fsize12 = 12.0 * fontScale;
final fsize10 = 10.0 * fontScale;
final fsize8 = 8.0 * fontScale;

final w300 = (fontScale <= 0.7) ? FontWeight.w200 : FontWeight.w300;
final w400 = (fontScale <= 0.75) ? FontWeight.w300 : FontWeight.w400;
final w500 = (fontScale <= 0.6)
    ? FontWeight.w300
    : ((fontScale <= 0.8) ? FontWeight.w400 : FontWeight.w500);
final w600 = (fontScale <= 0.6)
    ? FontWeight.w400
    : ((fontScale <= 0.8) ? FontWeight.w500 : FontWeight.w600);
final w700 = (fontScale <= 0.6)
    ? FontWeight.w500
    : ((fontScale <= 0.8) ? FontWeight.w600 : FontWeight.w700);
final w900 = (fontScale <= 0.6)
    ? FontWeight.w700
    : ((fontScale <= 0.8) ? FontWeight.w800 : FontWeight.w900);

const Color textColorDark = Colors.black;
const Color textColorLight = Colors.white;
const Color textColorAccent = Colors.red;
const Color textColorFaint = Color.fromRGBO(125, 125, 125, 1.0);
const Color blueGrey = Colors.blueGrey;

final defaultPaddingHorizontal = 12.0 * model.sizeScale;

const String fontNameAN = 'Lato';

final TextStyle appBarTextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w300,
  fontSize: fsize16,
  color: Colors.white,
);

final TextStyle titleTextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize22,
  color: textColorDark,
);

final TextStyle subTitleTextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w300,
  fontSize: fsize16,
  color: textColorAccent,
);

final TextStyle captionTextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w300,
  fontSize: fsize12,
  color: textColorDark,
);

final TextStyle normal16TextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize16,
  color: const Color(0xFF999FAE),
);

final TextStyle normal14TextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize14,
  color: const Color(0xFF999FAE),
);

final TextStyle smallBlueishTextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w300,
  fontSize: fsize12,
  color: const Color(0xFF1785C1),
);

final TextStyle mediumNormalTextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize16,
  color: textColorDark,
);

final TextStyle smallSemiTextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize12,
  color: const Color(0xFF00344F),
);

final TextStyle controlButtonTextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w600,
  fontSize: fsize16,
  color: Colors.white,
);

final TextStyle iconSmallTextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  letterSpacing: 0.25,
  fontSize: fsize8,
  color: const Color(0xFF00344F),
);

final TextStyle choiceButnTxtStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize16,
  color: const Color(0xFF1785C1),
);

final TextStyle dragButnTxtStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize16,
  color: const Color(0xFF00344F),
);

final TextStyle faintTxtStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize16,
  color: textColorFaint,
);

final TextStyle selButnTxtStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize16,
  color: Colors.white,
);

final TextStyle orangeTxtStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize16,
  color: const Color(0xFFF76F71),
);

final TextStyle resTxtStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize12,
  color: const Color(0xFF999FAE),
);

final TextStyle bannerTxtStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w700,
  fontSize: fsize24,
  color: Colors.white,
);

final TextStyle greenish16TxtStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w500,
  fontSize: fsize16,
  color: const Color(0xFF4DC591),
);

final TextStyle blueish20TextStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w900,
  fontSize: fsize20,
  color: const Color(0xFF1785C1),
);

final TextStyle greenish12TxtStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w700,
  fontSize: fsize12,
  color: const Color(0xFF4DC591),
);

final TextStyle topicTxtStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w700,
  fontSize: fsize22,
  color: Colors.white,
);

final TextStyle viewMoreStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w700,
  decoration: TextDecoration.underline,
  fontSize: fsize12,
  color: const Color(0xFF999FAE),
);

final TextStyle legendStyle = TextStyle(
  fontFamily: fontNameAN,
  fontWeight: w700,
  fontSize: fsize12,
  color: Colors.black,
);

final Map<String, TextStyle> textStyle = {
  "AppBar": appBarTextStyle,
  "Banner": bannerTxtStyle,
  "Blueish20": blueish20TextStyle,
  "Caption": captionTextStyle,
  "ChoiceButn": choiceButnTxtStyle,
  "ControlButton": controlButtonTextStyle,
  "DragButn": dragButnTxtStyle,
  "Faint": faintTxtStyle,
  "Greenish12": greenish12TxtStyle,
  "Greenish16": greenish16TxtStyle,
  "IconSmall": iconSmallTextStyle,
  "LegendStyle": legendStyle,
  "MediumNormal": mediumNormalTextStyle,
  "Normal14": normal14TextStyle,
  "Normal16": normal16TextStyle,
  "OrangeTxtStyle": orangeTxtStyle,
  "Result": resTxtStyle,
  "SelButn": selButnTxtStyle,
  "SmallSemi": smallSemiTextStyle,
  "SubTitle": subTitleTextStyle,
  "Topic": topicTxtStyle,
  "Title": titleTextStyle,
  "ViewMore": viewMoreStyle,
};
