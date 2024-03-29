import 'package:flutter/material.dart';
import '../model/locator.dart';
import './fonts.dart';

final size10 = model.size10;
final size20 = model.size20;
final sizeScale = model.sizeScale;
final sizeScaffold = model.screenHeight - kBottomNavigationBarHeight - 56.0;

const Map<String, Color> colorMap = {
  "almost": Color(0xFFFF9E50),
  "black": Colors.black,
  "blueGrey": Colors.blueGrey,
  "btnBlue": Color(0xFF1785C1),
  "btnBlueGradEnd": Color(0xFF3BAEED),
  "correct": Color(0xFF4DC591),
  "correctGradEnd": Color(0xFF82EFC0),
  "green": Colors.green,
  "grey": Colors.grey,
  "grey700": Color(0xFF616161),
  "greyText": Color(0xFFBDBDBD),
  "faint": Color.fromRGBO(125, 125, 125, 1.0),
  "incorrect": Color(0xFFF76F71),
  "incorrectGradEnd": Color(0xFFFF9DAC),
  "lightGreyText": Color.fromARGB(255, 220, 221, 223),
  "position": Color.fromARGB(255, 207, 15, 44),
  "red": Colors.red,
  "white": Colors.white,
  "white38": Colors.white38,
};

final List<dynamic> pinkColorList = [
  Colors.pink.shade50,
  Colors.pink.shade100,
  Colors.pink.shade200,
  Colors.pink.shade300,
  Colors.pink.shade400,
  Colors.pink.shade500,
  Colors.pink.shade600,
  Colors.pink.shade700,
  Colors.pink.shade800,
  Colors.pink.shade900
];

Map<String, dynamic> resources = {
  "textFieldBorder": textFieldBorder,
  "aboxPadding": aboxPadding,
  "boxPadding": boxPadding,
  "catBoxPadding": catBoxPadding,
  "catIconPadding": catIconPadding,
  "h20Padding": h20Padding,
  "clampingScrollPhysics": clampingScrollPhysics,
  "blueGradBD": blueGradBD,
  "diaDecoration": diaDecoration,
  "shadowDecoration": shadowDecoration,
  "bgDecoration": bgDecoration,
  "rCDecoration": rCDecoration,
  "sizeScaffold": sizeScaffold,
};

final textFieldBorder = OutlineInputBorder(
  borderSide: const BorderSide(
    color: Color(0xFF1785C1),
  ),
  borderRadius: BorderRadius.all(Radius.circular(size10)),
);

final Widget space10 = SizedBox(
  width: size10,
);

const Widget space2 = SizedBox(
  width: 2,
);

final Widget space5 = SizedBox(
  width: 5 * sizeScale,
);

const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1785C1), Color(0xFF3BAEED)]);

const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4DC591), Color(0xFF82EFC0)]);

const LinearGradient redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF76F71), Color(0xFFFF9DAC)]);

const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9E50), Color(0xFFFDBD88)]);

final BoxShadow bs = BoxShadow(
    color: const Color(0xFFE0E0E0),
    blurRadius: 5.0 * sizeScale,
    spreadRadius: 2.0);

final BoxDecoration RCDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(size10),
);

final BoxDecoration shadowRCDecoration = BoxDecoration(
  color: Colors.white,
  boxShadow: [bs],
  borderRadius: BorderRadius.circular(size10),
);

final BoxDecoration shadowDecoration = BoxDecoration(
  color: Colors.white,
  boxShadow: const [
    BoxShadow(color: Color(0xFFE0E0E0), blurRadius: 2.0, spreadRadius: 1.0)
  ],
  borderRadius: BorderRadius.circular(size10),
);

final BoxDecoration diaDecoration = BoxDecoration(
  color: Colors.white,
  boxShadow: [bs],
  borderRadius: BorderRadius.circular(size20),
);

final BoxDecoration rCDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: const Color(0xFF4DC591), width: 2),
  borderRadius: BorderRadius.circular(size10),
);

const BoxDecoration blueGradBD = BoxDecoration(gradient: blueGradient);

const BoxDecoration greenGradBD = BoxDecoration(gradient: greenGradient);
const BoxDecoration redGradBD = BoxDecoration(gradient: redGradient);

final BoxDecoration bgDecoration =
    BoxDecoration(color: Colors.white, boxShadow: [
  BoxShadow(
      color: const Color(0xFFE0E0E0),
      blurRadius: 5.0 * sizeScale,
      offset: Offset(0.0, size10))
]);

final BoxDecoration elemDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: const Color(0xFF1785C1), width: 2),
  borderRadius: BorderRadius.circular(size10),
);

final BoxDecoration dragDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: const Color(0xFF999FAE), width: 2),
  borderRadius: BorderRadius.circular(size10),
);

final BoxDecoration selDecoration = BoxDecoration(
  color: const Color(0xFF1785C1),
  borderRadius: BorderRadius.circular(model.size10),
);

final BoxDecoration imageDecoration = BoxDecoration(
  color: Colors.grey,
  borderRadius: BorderRadius.circular(model.size10),
);

final BoxDecoration btnDecoration = elemDecoration;

final catBoxPadding = EdgeInsets.symmetric(vertical: model.size10);
final catIconPadding = EdgeInsets.symmetric(horizontal: model.size10);
final h20Padding = EdgeInsets.symmetric(horizontal: model.size20);
final boxPadding = EdgeInsets.all(model.size20);
final aboxPadding =
    EdgeInsets.symmetric(vertical: model.size10, horizontal: model.size20);

const clampingScrollPhysics = ClampingScrollPhysics();

OutlineInputBorder _buildBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(size10)),
    borderSide: BorderSide(
      color: color,
      width: 1.0,
    ),
  );
}

InputDecorationTheme inputTheme() => InputDecorationTheme(
      //isDense: true,
      //floatingLabelBehavior: FloatingLabelBehavior.auto,
      // enabledBorder: _buildBorder(Colors.grey[600]!),
      // errorBorder: _buildBorder(Colors.red),
      // focusedErrorBorder: _buildBorder(Colors.red),
      // focusedBorder: _buildBorder(Colors.grey[600]!),
      // disabledBorder: _buildBorder(Colors.grey[400]!),
      // border: _buildBorder(Colors.grey[600]!),
      labelStyle: faintTxtStyle,
      floatingLabelStyle: dragButnTxtStyle,
      helperStyle: resTxtStyle,
      hintStyle: dragButnTxtStyle,
      errorStyle: errTxtStyle,
      suffixStyle: mediumNormalTextStyle,
      // fillColor: Colors.grey[300],
      // filled: true,
      focusColor: textColorFaint,
      hoverColor: textColorFaint,
      constraints: BoxConstraints(maxWidth: model.scaleWidth * 0.9),
    );

ThemeData getMainTheme() => ThemeData(
      primarySwatch: Colors.blue,
      inputDecorationTheme: inputTheme(),
    );

final RegExp pwre = RegExp(
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");

Color? getColor(dynamic c) {
  if (c != null) {
    if (c is Color) {
      return c;
    }
    if (c is String) {
      if (c.contains("0x")) {
        int? cc = int.tryParse(c);
        return (cc != null) ? Color(cc) : null;
      }
      return colorMap[c];
    }
  }
  return null;
}

final Map<int, int> staggerTileMap = {
  0: 1,
  1: 2,
  2: 1,
  3: 1,
  4: 1,
  5: 1,
  6: 1,
  7: 1,
  8: 1,
  9: 2,
  10: 1,
  11: 1,
  12: 1,
  13: 1,
  14: 1,
  15: 1,
  16: 1,
  17: 1
};
