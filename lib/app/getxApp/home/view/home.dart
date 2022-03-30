import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tryout/app/getxApp/detail/view/detail.dart';
import 'package:tryout/app/getxApp/detail/view/paging.dart';
import 'package:tryout/builder/pattern.dart';
import 'package:tryout/model/locator.dart';

getxAppInit() {
  Map<String, Function> pat = {
    "getxHome": getHomePattern,
    "getxDetails": getDetailsPattern,
    "getxPaging": getPagingPattern,
  };
  model.appActions.addPatterns(pat);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

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
                  model.appActions.doFunction("route", "details", null);
                  //Get.toNamed("details");
                },
                child: const Text('Go to detail'),
              ),
              Divider(),
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
  Widget getWidget({String name}) {
    return const HomeScreen();
  }
}

ProcessPattern getHomePattern(Map<String, dynamic> pmap) {
  return HomePattern(pmap);
}
