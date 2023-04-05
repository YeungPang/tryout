import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:tryout/app/xeminoApp/yhwedding.dart';
import '../agent/control_agent.dart';
import '../app/xeminoApp/xemino_app.dart';
import '../builder/pattern.dart';
import '../model/locator.dart';
import '../model/main_model.dart';
import '../agent/resx_controller.dart';
import 'crmApp/crm_app.dart';
import 'getxApp/home/view/home.dart';

const String mainApp = "crmwedding";
const bool calendar = true;
final Map<String, dynamic> appMap = {
  "getX": ["assets/models/getx.json", getxAppInit],
  "xemino": ["assets/models/xemino.json", xeminoAppInit],
  "crm": ["assets/models/crm.json", crmAppInit],
  "wedding": ["assets/models/wedding.json", crmAppInit],
  "crmwedding": ["assets/models/wedding.json", weddingAppInit],
  "crmlogin": ["assets/models/crmlogin.json", crmAppInit],
};

class HomePage extends StatelessWidget {
  final ResxController resxController = ResxController();
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (model.stateData["mainWidget"] == null) {
      model.init(context);
      //String mainJson = appMap[mainApp][0];
      //String mainJson = resxController.getCache("mainjson");
      return FutureBuilder<String>(
          //future: model.getJson(context, mainJson),
          future: model.getJson(context),
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
    //return model.stateData["mainWidget"];
    return _getMainWidget();
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

  Widget _getMainWidget() {
    Agent a = model.appActions.getAgent("pattern");

    ProcessEvent event = ProcessEvent("mainView");
    var p = a.process(event);

    debugPrint("Future call count: " + model.count.toString());
    Widget w = (p is ProcessPattern) ? p.getWidget() : p;
    //model.stateData["mainWidget"] = w;
    return w;
  }
}
