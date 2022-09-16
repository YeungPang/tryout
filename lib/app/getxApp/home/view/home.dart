import 'package:flutter/material.dart';
import 'package:tryout/app/getxApp/detail/view/detail.dart';
import 'package:tryout/app/getxApp/detail/view/paging.dart';
import 'package:tryout/builder/pattern.dart';
import 'package:tryout/model/locator.dart';
import 'package:maps_launcher/maps_launcher.dart';

getxAppInit() {
  Map<String, Function> pat = {
    "printX": printX,
    "printX3": printX3,
    "getxHome": getHomePattern,
    "getxDetails": getDetailsPattern,
    "getxPaging": getPagingPattern,
  };
  model.appActions.addPatterns(pat);
  Map<String, Function> func = {
    "printX": printX,
    "printX3": printX3,
  };
  model.appActions.addFunctions(func);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text(
                "This is home screen",
                style: TextStyle(fontSize: 24),
              ),
              ElevatedButton(
                style: style,
                onPressed: () {
                  //model.appActions.doFunction("route", "details", null);
                  //Get.toNamed("details");
                  MapsLauncher.launchQuery('Obere Vorstadt 40, 5001 Aarau');
                },
                child: const Text('Go to detail'),
              ),
              const Divider(),
              ElevatedButton(
                style: style,
                onPressed: () {
                  model.appActions.doFunction("route", "paging", null);
                  //Get.toNamed("details");
                },
                child: const Text('Go to paging'),
              ),
            ]),
      ),
    );
  }
}

class HomePattern extends ProcessPattern {
  HomePattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return const HomeScreen();
  }
}

ProcessPattern getHomePattern(Map<String, dynamic> pmap) {
  return HomePattern(pmap);
}

printX(String x) {
  debugPrint(x);
}

printX3(String x1, String x2, String x3) {
  debugPrint([x1, x2, x3].toString());
}
