import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tryout/builder/pattern.dart';
import 'package:tryout/util/map_util.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Screen"),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        alignment: Alignment.center,
        child: TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            //MapUtil.openMap(47.628293260721, -122.34263420105);
            MapUtil.openMapFromAddr("Alte Aescherstrasse 36, Fahrwangen");
          },
          child: const Text(
            "Open Google Map",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class DetailsPattern extends ProcessPattern {
  DetailsPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String name}) {
    return const DetailScreen();
  }
}

ProcessPattern getDetailsPattern(Map<String, dynamic> pmap) {
  return DetailsPattern(pmap);
}
