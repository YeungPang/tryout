import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:tryout/app/xeminoApp/login_screen.dart';
import './agent/resx_controller.dart';
import './builder/pattern.dart';
import './model/main_model.dart';
import './app/home_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MainModel model = Get.put(MainModel());
    Get.put(ResxController());
    if (calendar) {
      return CalendarControllerProvider(
        controller: model.eventController,
        child: GetMaterialApp(
          title: 'Flutter Calendar Page Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          scrollBehavior: const ScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.trackpad,
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
            },
          ),
/*           home: const ResponsiveWidget(
            mobileWidget: MobileHomePage(),
            webWidget: WebHomePage(),
          ), */
          getPages: [
            GetPage(name: "/home", page: () => HomePage()),
            GetPage(name: "/page", page: () => _getPage(model)),
            GetPage(name: "/login", page: () => const LoginScreen()),
            GetPage(name: "/sample", page: () => HomePage()),
            //GetPage(name: "/sample", page: () => const SampleGroup()),
          ],
          initialRoute: (mainApp.contains("crm")) ? "/login" : "/home",
        ),
      );
    }
    return _getApp(model);
  }

  Widget _getApp(MainModel model) {
    return GetMaterialApp(
      //title: model.map["title"],
      //locale: const Locale('fr'),
      getPages: [
        GetPage(name: "/home", page: () => HomePage()),
        GetPage(name: "/page", page: () => _getPage(model)),
        GetPage(name: "/login", page: () => const LoginScreen()),
        GetPage(name: "/sample", page: () => HomePage()),
        //GetPage(name: "/sample", page: () => const SampleGroup()),
      ],
      initialRoute: (mainApp.contains("crm")) ? "/login" : "/home",
      //initialRoute: "/login",
    );
  }

  Widget _getPage(MainModel model) {
    Widget screen;
    Map<String, dynamic> map = Get.arguments;
    Agent a = model.appActions.getAgent("pattern");

    ProcessEvent event = ProcessEvent(Get.parameters["screen"]!, map: map);
    var p = a.process(event);

    if (p is ProcessPattern) {
      screen = p.getWidget();
    } else {
      screen = p as Widget;
    }
    return screen;
  }
}
