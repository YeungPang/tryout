import 'package:flutter/cupertino.dart';
import 'package:tryout/agent/config_agent.dart';
import 'package:tryout/model/locator.dart';
import 'package:tryout/util/map_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const int plen = 5;

xeminoAppInit() {
  Map<String, Function> func = {
    "addrToMap": MapUtil.addrToMap,
    "toTel": MapUtil.toTel,
    "nextContactPage": nextContactPage,
    "prevContactPage": prevContactPage,
  };
  model.appActions.addFunctions(func);
}

nextContactPage() {
  bool noMore = resxController.getCache("contactCompleted") ?? false;
  if (noMore) {
    return;
  }
  String main = model.map["main"];
  Map<String, dynamic> itemRefMap = facts[main];
  List<dynamic> pList = itemRefMap["elemList"];
  int inx = resxController.getCache("pInx");
  int len = pList.length - plen;
  if (inx != null) {
    inx += plen;
    if (inx >= len) {
      inx = len;
    }
    len = plen;
  } else {
    inx = 0;
    len = (pList.length > plen) ? plen : pList.length;
  }
  resxController.setCache("pInx", inx);
  List<dynamic> itemRef = [];
  for (int i = 0; i < len; i++) {
    itemRef.add(pList[i + inx]);
  }
  resxController.setRxValue(main, itemRef);
  if (pList.length <= (inx + plen)) {
    resxController.setCache("contactCompleted", true);
  }
}

prevContactPage() {
  int inx = resxController.getCache("pInx");
  if (inx == 0) {
    return;
  }
  String main = model.map["main"];
  Map<String, dynamic> itemRefMap = facts[main];
  List<dynamic> pList = itemRefMap["elemList"];
  inx = (plen > inx) ? 0 : (inx - plen);
  int len = (pList.length > plen) ? plen : pList.length;
  List<dynamic> itemRef = [];
  for (int i = 0; i < len; i++) {
    itemRef.add(pList[i + inx]);
  }
  resxController.setRxValue(main, itemRef);
  resxController.setCache("pInx", inx);
  if (pList.length > plen) {
    resxController.setCache("contactCompleted", false);
  }
}
