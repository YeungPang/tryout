import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tryout/agent/config_agent.dart';
import 'package:tryout/builder/pattern.dart';
import 'package:tryout/model/locator.dart';

const int plen = 10;

class PagingScreen extends StatelessWidget {
  final Map<String, dynamic> map;
  const PagingScreen(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController rc = map["_controller"];
    return Scaffold(
        appBar: AppBar(
          title: const Text("Paging Screen"),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Obx(
          () => SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () async {
                prevPage();
                rc.refreshCompleted();
              },
              onLoading: () async {
                nextPage(rc);
              },
              controller: rc,
              child: _getChild(resxController.getRxValue("pInx"))),
        ));
  }

  Widget _getChild(int inx) {
    if (inx < 0) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    List<dynamic> pList = resxController.getCache("pList");
    int len = pList.length - inx;
    int itemCount = (len > plen) ? plen : len;
    return ListView.separated(
        itemBuilder: (context, index) {
          Map<String, dynamic> pmap = pList[index + inx];
          return ListTile(
            title: Text(pmap["name"]),
            subtitle: Text(pmap["airline"][0]["country"]),
            trailing: Text(pmap["airline"][0]["name"]),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: itemCount);
  }
}

class PagingPattern extends ProcessPattern {
  PagingPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    RefreshController controller = RefreshController();
    map["_controller"] = controller;
    List<dynamic>? pList = resxController.getCache("pList");
    if (pList == null) {
      resxController.setRxValue("pInx", -1);
      pList = [];
      resxController.setCache("pList", pList);
      nextPage(controller);
    }
    return PagingScreen(map);
  }
}

ProcessPattern getPagingPattern(Map<String, dynamic> pmap) {
  return PagingPattern(pmap);
}

nextPage(RefreshController rc) {
  List<dynamic> pList = resxController.getCache("pList");
  if (pList.isEmpty) {
    loadString("assets/models/passenger.json").then((value) {
      Map<String, dynamic> pmap = json.decode(value);
      pList = pmap["data"];
      resxController.setCache("pList", pList);
      resxController.setRxValue("pInx", 0);
    });
  } else {
    int inx = resxController.getRxValue("pInx");
    int len = pList.length - inx;
    inx += (len > plen) ? plen : len;
    if (inx < pList.length) {
      resxController.setRxValue("pInx", inx);
      if (len > plen) {
        rc.loadComplete();
      } else {
        rc.loadNoData();
      }
    } else {
      rc.loadNoData();
    }
  }
}

prevPage() {
  int inx = resxController.getRxValue("pInx");
  int len = inx - plen;
  if (len >= 0) {
    resxController.setRxValue("pInx", len);
  }
}
