import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:get/get.dart';
import 'package:tryout/util/map_util.dart';
import '../model/locator.dart';
import './pattern.dart';

final double iSize = 36.0 * model.sizeScale;

class SignaturePad extends StatefulWidget {
  final Map<String, dynamic> map;
  const SignaturePad(this.map, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  late SignatureController _controller;
  late Map<String, dynamic> map;
  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    map = widget.map;
    return Column(children: [
      Signature(
        controller: _controller,
      ),
      const Divider(
        thickness: 2,
      ),
      SizedBox(
        child: Row(
          children: [
            IconButton(
                onPressed: _onPressed(),
                icon: const Icon(
                  Icons.check,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  _controller.clear();
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.red,
                ))
          ],
        ),
        height: 50.0 * model.sizeScale,
      ),
    ]);
  }

  _onPressed() {
    if (_controller.isNotEmpty) {
      exportSignature().then((value) {
        processValue(map, value);
      });
    }
  }

  Future<Uint8List> exportSignature() async {
    final SignatureController exportController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points: _controller.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();
    return signature!;
  }
}
