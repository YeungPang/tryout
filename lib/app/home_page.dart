import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import '../agent/control_agent.dart';
import '../app/xeminoApp/xemino_app.dart';
import '../builder/pattern.dart';
import '../model/locator.dart';
import '../model/main_model.dart';
import '../agent/resx_controller.dart';
import 'crmApp/crm_app.dart';
import 'getxApp/home/view/home.dart';

const String mainApp = "crmlogin";
final Map<String, dynamic> appMap = {
  "getX": ["assets/models/getx.json", getxAppInit],
  "xemino": ["assets/models/xemino.json", xeminoAppInit],
  "crm": ["assets/models/crm.json", crmAppInit],
  "crmlogin": ["assets/models/crmlogin.json", crmAppInit],
};

class HomePage extends StatelessWidget {
  final ResxController resxController = ResxController();
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    model.init(context);
    return _getWidget(context);
  }

  Widget _getWidget(BuildContext context) {
    if (model.stateData["mainWidget"] == null) {
      String mainJson = appMap[mainApp][0];
      return FutureBuilder<String>(
          future: model.getJson(context, mainJson),
          builder: (context, snapshot) {
            if (snapshot.hasError) debugPrint(snapshot.error.toString());

            return snapshot.hasData
                ? _getBodyUi(model, snapshot.data!)
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
