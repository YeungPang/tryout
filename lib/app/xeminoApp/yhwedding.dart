import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webxene_core/auth_manager.dart';
import 'package:webxene_core/instance_manager.dart';
import 'package:webxene_core/group_manager.dart';
import 'package:webxene_core/mote_manager.dart';
import 'package:webxene_core/motes/attachment.dart';
import 'package:webxene_core/motes/filter.dart';
import 'package:webxene_core/motes/mote.dart';
import 'package:webxene_core/motes/mote_column.dart';
import 'package:webxene_core/motes/mote_relation.dart';
import 'package:webxene_core/motes/sort_method.dart';

import '../../builder/pattern.dart';
import '../../model/locator.dart';
import '../../util/map_util.dart';
import '../../util/test.dart';

const int targetGroupId = 1;

weddingAppInit() {
  Map<String, Function> func = {
    "addrToMap": MapUtil.addrToMap,
    "toTel": MapUtil.toTel,
    "toUrl": MapUtil.toUrl,
    "login": login,
    "getGroupList": getGroupList,
    "getSubview": getSubview,
    "getRelation": getRelation,
    "sort": sort,
    "filter": setFilter,
    "refresh": refresh,
    "setTimer": setTimer,
    "initTimer": initTimer,
    "scanQRCode": scanQRCode,
    "getText": getText,
    "getTest": getTest,
    "imagePicker": imagePicker,
    "xFileToUint8List": xFileToUint8List,
    "addAttachment": addAttachmentToMote,
    "remapData": remapData,
    "updateMote": updateMote,
    "mapList": mapList,
  };
  model.appActions.addFunctions(func);
}

login(Map<String, dynamic> m) {
  //InstanceManager().setupInstance(m["_url"], {
  InstanceManager().setupInstance("crm.sevconcept.ch", {
    'instance': {'DEBUG_HTTP': false}
  });
  AuthManager()
      //.runSingleStageLogin(m["_email"], m["_pw"]).then((_) {
      .runSingleStageLogin("demo-user@sevconcept.ch", "demouser123")
      .then((_) {
    if (AuthManager().state == AuthState.complete) {
      ProcessEvent pe = m["_processEvent"];
      Agent a = model.appActions.getAgent("pattern");
      a.process(pe);
      //Get.toNamed("/sample");
    }
  });
}

Future<List<Mote>> _getGroup(Map<String, dynamic> m) async {
  try {
    int targetPageId = m["_pageId"];
    int targetColumnId = m["_columnId"];
    final myGroups = await AuthManager().loggedInUser.getSelfGroupsList();
    final myGroupsSelection = myGroups.firstWhere((g) => g.id == targetGroupId);
    final targetGroup = await GroupManager().fetchGroup(myGroupsSelection.id);
    final targetPage =
        targetGroup.orderedMenu.firstWhere((p) => p.id == targetPageId);
    final fullPage = await GroupManager()
        .fetchPageAndMotes(targetPage.id, forceRefresh: true);
    final targetColumn = fullPage.columns.values.first;
    targetColumn.filters.clear();
    targetColumn.calculateMoteView();
    m["col"] = targetColumn;
    final motes = targetColumn.getMoteViewPage(unpaginated: true);
    return motes;
  } catch (ex) {
    return [];
  }
}

getGroupList(Map<String, dynamic> m) {
  if (m["_pageId"] < 0) {
    m["_test"] = "load";
    dynamic value = getTest(m);
    _updateList(m, value);
  } else {
    _getGroup(m).then((List<Mote> value) {
      String? cacheName = m["_cacheName"];
      if (cacheName != null) {
        resxController.setCache(cacheName, value);
      }
      _updateList(m, value);
    });
  }
}

_addIdTimestamp(Mote e, Map<String, dynamic> p) {
  p['id'] = e.id;
  int dtime = e.timestamp * 1000;
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(dtime);
  String d = date.day.toString() +
      '.' +
      date.month.toString() +
      '.' +
      date.year.toString();
  dtime = (DateTime.now().millisecondsSinceEpoch - dtime) ~/ 60000;
  Map<String, dynamic> mt = model.map["text"];
  if (dtime < 60) {
    d += mt["minAgo"].toString().replaceFirst("#n#", dtime.toString());
  } else {
    dtime = dtime ~/ 60;
    if (dtime < 60) {
      d += mt["hourAgo"].toString().replaceFirst("#n#", dtime.toString());
    } else {
      dtime = dtime ~/ 24;
      d += mt["dayAgo"].toString().replaceFirst("#n#", dtime.toString());
    }
  }
  p['entryDate'] = d;
}

// Expecting list of list of map
Future<List<List<Mote>>> _getSubview(
    int pageId, int pageSubmote, List<dynamic> cols) async {
  final sPage = await GroupManager()
      .fetchPageAndMotes(pageId, forceRefresh: true, subviewMote: pageSubmote);
  List<Mote> rList = [];
  List<List<Mote>> mList = [];
  for (int i in cols) {
    final col = sPage.columns[i];
    col?.calculateMoteView();
    List<Mote> cList = col?.getMoteViewPage(unpaginated: true) ?? [];
    mList.add(cList);
    rList.addAll(cList);
  }
  await Mote.retrieveReferences(rList, targetGroupId);
  return mList;
}

getSubview(Map<String, dynamic> m) {
  List<List<dynamic>> pList = [];
  int pageId = m['_pageId'];
  int id = m["_pageSubmote"];
  if (pageId >= 0) {
    _getSubview(pageId, id, m["_cols"]).then((mList) {
      List<dynamic>? refs = m["_refs"];
      int i = 0;
      for (List<Mote> ml in mList) {
        List<dynamic> pl = [];
        List<dynamic> rl = (refs != null) ? refs[i] : [];
        if (ml.isNotEmpty) {
          for (Mote m in ml) {
            Map<String, dynamic> mp = {};
            mp.addAll(m.payload);
            _addIdTimestamp(m, mp);
            if (rl.isNotEmpty) {
              for (String r in rl) {
                dynamic dr = mp[r];
                if (dr != null) {
                  dynamic ref = MoteRelation.asMoteList(dr, m.id);
                  mp[r] = ref.map((c) => c.payload['title']).toList();
                }
              }
            }
            pl.add(mp);
          }
        }
        pList.add(pl);
        i++;
      }
      ProcessEvent pe = m["_processEvent"];
      Agent a = model.appActions.getAgent("pattern");
      if (pe.map == null) {
        pe.map = {"_value": pList};
      } else {
        pe.map!["_value"] = pList;
      }
      a.process(pe);
    });
  } else {}
}

dynamic getRelation(Map<String, dynamic> m) {
  int rid = m["relId"];
  var ref = m["ref"];
  if (ref != null) {
    dynamic ret = MoteRelation.asMoteList(ref, rid);
    return ret.map((c) => c.payload['title']).toList();
  }
  return null;
}

setFilter(Map<String, dynamic> m) {
  String? name = m["_groupName"];
  TextEditingController? tc = m["_textController"];
  String? filter = (tc != null) ? tc.text : m["_filter"];
  if (name != null) {
    Map<String, dynamic> dmap = resxController.getCache(name + "Cache");
    MoteColumn? targetColumn = dmap["col"];
    if (targetColumn != null) {
      targetColumn.filters.clear();
      if (filter != null) {
        targetColumn.filters.add(Filter.andFilter("title", filter));
      }
      targetColumn.calculateMoteView();
      final value = targetColumn.getMoteViewPage(unpaginated: true);
      _updateList(m, value);
    }
  }
}

sort(Map<String, dynamic> m) {
  String? name = m["_groupName"];
  bool ascending = m["_ascending"] ?? true;
  if (name != null) {
    Map<String, dynamic> dmap = resxController.getCache(name + "Cache");
    MoteColumn? targetColumn = dmap["col"];
    if (targetColumn != null) {
      targetColumn.sortMethods.clear();
      bool s = m["_sort"] ?? true;
      if (s) {
        targetColumn.sortMethods.add(SortMethod.normalSort("title", ascending));
        m["_sort"] = false;
      } else {
        m["_sort"] = true;
      }
      targetColumn.calculateMoteView();
      final value = targetColumn.getMoteViewPage(unpaginated: true);
      _updateList(m, value);
    }
  }
}

addAttachmentToMote(Map<String, dynamic> m) async {
  String cacheName = m["_cacheName"];
  List<Mote> lm = resxController.getCache(cacheName);
  int inx = m["_index"];
  Mote mote = lm[inx];
  final value = m["_value"];
  Attachment newAttachment =
      Attachment.newFromByteArray("samplefile.txt", "text/plain", value);
  await newAttachment.saveAttachmentRemotely();
  mote.attachments.add(newAttachment);
  mote.attachments.removeWhere((attach) =>
      attach.filename == 'samplefile.txt' && attach.id != newAttachment.id);
  MoteManager().saveMote(mote);
}

updateMote(Map<String, dynamic> m) {
  String cacheName = m["_cacheName"];
  List<Mote> lm = resxController.getCache(cacheName);
  int inx = m["_index"];
  Mote mote = lm[inx];
  Map<String, dynamic> p = mote.payload;
  Map<String, dynamic> updates = m["_updates"];
  updates.forEach((key, value) {
    p[key] = value;
  });
  MoteManager().saveMote(mote);
}

_updateList(Map<String, dynamic> m, dynamic value) async {
  String name = m["_groupName"];
  ProcessEvent pe = resxController.getCache(name + "Event");
  Agent a = model.appActions.getAgent("pattern");
  int i = 0;
  List<dynamic> ld = (value is List<Mote>)
      ? value.map((e) {
          Map<String, dynamic> p = {};
          p.addAll(e.payload);
          p["inx"] = i++;
          _addIdTimestamp(e, p);
          return p;
        }).toList()
      : value;
  List<dynamic>? at = m["_attachment"];
  if (at != null) {
    if (value is List<Mote>) {
      int i = 0;
      for (var e in value) {
        if (e.attachments.isNotEmpty) {
          int l = e.attachments.length;
          for (int j = 0; j < l; j++) {
            await e.attachments[j].loadAttachment();
            Uint8List? data = e.attachments[j].byteArray;
            int k = (j >= at.length) ? (at.length - 1) : j;
            ld[i][at[k]] = data;
          }
        }
        i++;
      }
    }
  }
  if (pe.map == null) {
    pe.map = {"_value": ld};
  } else {
    pe.map!["_value"] = ld;
  }
  a.process(pe);
}

refresh(Map<String, dynamic> m) {
  _refresh(m["_groupName"]).then((List<Mote> value) {
    _updateList(m, value);
  });
}

Future<List<Mote>> _refresh(String name) async {
  try {
    Map<String, dynamic> dmap = resxController.getCache(name + "Cache");
    MoteColumn tCol = dmap["col"];
    int pageId = dmap["_pageId"];
    final fullPage =
        await GroupManager().fetchPageAndMotes(pageId, forceRefresh: true);
    final targetColumn = fullPage.columns[tCol.id]!;
    targetColumn.filters.clear();
    targetColumn.calculateMoteView();
    dmap["col"] = targetColumn;
    final motes = targetColumn.getMoteViewPage(unpaginated: true);
    return motes;
  } catch (ex) {
    return [];
  }
}
