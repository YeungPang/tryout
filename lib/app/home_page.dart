import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:tryout/agent/control_agent.dart';
import 'package:tryout/app/xeminoApp/xemino_app.dart';
import 'package:tryout/builder/pattern.dart';
import 'package:tryout/model/locator.dart';
import 'package:tryout/model/main_model.dart';
import 'package:tryout/agent/resx_controller.dart';

import 'getxApp/home/view/home.dart';

const String mainApp = "xemino";
final Map<String, dynamic> appMap = {
  "getX": ["assets/models/getx.json", getxAppInit],
  "xemino": ["assets/models/xemino.json", xeminoAppInit]
};

class HomePage extends StatelessWidget {
  final ResxController resxController = ResxController();
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double sr = screenWidth / screenHeight;
    double scaleHeight = 683.42857;
    double scaleWidth = 411.42857;
    double scr = scaleWidth / scaleHeight;
    double r = ((sr - scr) / scr).abs();
    if ((sr < scr) && (scaleHeight < screenHeight)) {
      //model.sizeScale = 1.0;
      model.sizeScale = screenWidth / scaleWidth;
      scaleHeight = screenHeight;
      scaleWidth = screenWidth;
    } else if (r <= 0.1) {
      //r = ((scaleWidth - screenWidth) / screenWidth).abs();
      // if (r <= 0.1) {
      //   model.sizeScale = 1.0;
      // } else {
      model.sizeScale = screenHeight / scaleHeight;
      scaleHeight = screenHeight;
      scaleWidth = screenHeight * scr;
      // }
    } else {
      if (screenWidth >= scaleWidth) {
        if (screenHeight > scaleHeight) {
          model.sizeScale = screenHeight / scaleHeight;
          scaleWidth = screenHeight * scr;
          scaleHeight = screenHeight;
        } else {
          double sh = scaleHeight * 2.0 / 3.0;
          if (screenHeight >= sh) {
            model.sizeScale = 1.0;
          } else {
            model.sizeScale = screenHeight / scaleHeight;
            scaleHeight = screenHeight * 3.0 / 2.0;
            scaleWidth = scaleHeight * scr;
          }
        }
      } else {
        model.sizeScale = screenWidth / scaleWidth;
        scaleWidth = screenWidth;
        scaleHeight = scaleWidth / scr;
      }
    }
    model.fontScale = model.sizeScale;
    model.scaleHeight = scaleHeight;
    model.scaleWidth = scaleWidth;
    model.screenHeight = screenHeight;
    model.screenWidth = screenWidth;
    model.appBarHeight = scaleHeight * 0.9 / 10.6;
    debugPrint("Screen width: " + screenWidth.toString());
    debugPrint("Screen height: " + screenHeight.toString());
    debugPrint("Scale width: " + scaleWidth.toString());
    debugPrint("Scale height: " + scaleHeight.toString());
/*     return BaseView<MainModel>(
        builder: (context, child, model) => BusyOverlay(
            show: model.state == ViewState.busy,
            child: _getWidget(context, model))); */
    return _getWidget(context);
  }

  Widget _getWidget(BuildContext context) {
    if (model.stateData["mainWidget"] == null) {
      String mainJson = appMap[mainApp][0];
      return FutureBuilder<String>(
          future: model.getJson(context, mainJson),
          builder: (context, snapshot) {
            if (snapshot.hasError) debugPrint(snapshot.error);

            return snapshot.hasData
                ? _getBodyUi(model, snapshot.data)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          });
    }
    model.addCount();
    debugPrint("Non-future call count: " + model.count.toString());
    return model.stateData["mainWidget"];
  }

  Widget _getBodyUi(MainModel model, String jsonStr) {
    debugPrint("Decoding jsonStr!!");
    var map = json.decode(jsonStr);
    model.stateData["map"] = map;
    model.addCount();
    model.init();
    model.appActions = AgentActions();
    List<dynamic> mainList = appMap[mainApp];
    if (mainList.length > 1) {
      Function initApp = mainList[1];
      initApp();
    }
    Agent a = model.appActions.getAgent("pattern");

    ProcessEvent event = ProcessEvent("mainView");
    var p = a.process(event);

    debugPrint("Future call count: " + model.count.toString());
    Widget w = (p is ProcessPattern) ? p.getWidget() : p;
    model.stateData["mainWidget"] = w;
    return w;
  }
}
