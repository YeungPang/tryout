import 'package:flutter/material.dart';
import '../model/locator.dart';

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
  "faint": Color.fromRGBO(125, 125, 125, 1.0),
  "incorrect": Color(0xFFF76F71),
  "incorrectGradEnd": Color(0xFFFF9DAC),
  "lightGreyText": Color.fromARGB(255, 220, 221, 223),
  "green": Colors.green,
  "grey": Colors.grey,
  "grey700": Color(0xFF616161),
  "greyText": Color(0xFFBDBDBD),
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
  "catBoxPadding": catBoxPadding,
  "catIconPadding": catIconPadding,
  "clampingScrollPhysics": clampingScrollPhysics,
  "blueGradBD": blueGradBD,
  "diaDecoration": diaDecoration,
  "shadowDecoration": shadowDecoration,
  "bgDecoration": bgDecoration,
  "rCDecoration": rCDecoration,
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

const clampingScrollPhysics = ClampingScrollPhysics();
