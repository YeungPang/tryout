import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './config_agent.dart';
import './logic_processor.dart';
import '../builder/pattern.dart';
import '../builder/get_pattern.dart';
import 'package:json_theme/json_theme.dart';
import '../resources/basic_resources.dart';
import '../resources/fonts.dart';
import '../resources/icons.dart';
import '../model/locator.dart';
import '../builder/item_search.dart';

class AgentActions extends AppActions {
  final ControlAgent controlAgent = ControlAgent();
  Map<String, Function> appFunc = {};
  Map<String, Function> appPatterns = {};
  //final MvcAgent mvcAgent = MvcAgent();
  String patName = "";
  bool themeChanged = false;
  Timer? timer;

  @override
  Function? getFunction(String name) {
    switch (name) {
      default:
        return appFunc[name];
    }
  }

  @override
  dynamic doFunction(String name, dynamic input, Map<String, dynamic>? vars) {
    switch (name) {
      case "patMap":
        Map<String, dynamic> imap = {};
        controlAgent.mapPat(input, imap);
        return imap;
      case "mapPat":
        return controlAgent.mapPat(input, vars!);
      case "fsmEvent":
        ProcessEvent pe = (input is List<dynamic>)
            ? ((input.length == 2)
                ? ProcessEvent(input[0], map: input[1])
                : ProcessEvent(input[0]))
            : ProcessEvent(input, map: vars);
        Agent a = getAgent("pattern");
        return a.process(pe);
      case "decode":
        return controlAgent.decode(input, vars!);
      case "getLangText":
        String str = input;
        if (model.lang != model.deflang) {
          str = model.lang + str;
        }
        return model.map["text"][str];
      case "dataList":
        if ((input is List<dynamic>) && (input.length == 2)) {
          return getDataList(input[0], input[1]);
        }
        return null;
      case "route":
        String screen = (input is List<dynamic>) ? input[0] : input;
        Map<String, dynamic>? m =
            ((input is List<dynamic>) && (input.length > 1)) ? input[1] : vars;
        Get.toNamed("/page?screen=" + screen, arguments: m);
        //Navigator.pushNamed(model.context, input, arguments: {"map": vars});
        return true;
      case "popRoute":
        bool mode = (vars != null) ? vars["mode"] ?? false : false;
        //Navigator.of(model.context).pop(mode);
        Get.back();
        if (mode) {
          Get.back();
        }
        return true;
      case "setResxValue":
        if (input is List<dynamic>) {
          resxController.setRxValue(input[0], input[1]);
          return true;
        }
        return null;
      case "getResxValue":
        return resxController.getRxValue(input);
      case "home":
        Get.offAllNamed("/home");
        return true;

      case "createEvent":
        if (input is List<dynamic>) {
          if (input.length == 2) {
            return ProcessEvent(input[0], map: input[1]);
          } else if (input.length == 1) {
            return ProcessEvent(input[0]);
          }
        }
        if (input is String) {
          return ProcessEvent(input);
        }
        return null;
      case "getState":
        Map<String, dynamic> m = model.map["stateData"];
        dynamic res;
        List<dynamic> ls =
            (input is List<dynamic>) ? input : (input as String).split("/");
        for (int i = 0; i < ls.length; i++) {
          res = m[ls[i]];
          if (res == null) {
            return nil;
          }
          if (res is Map<String, dynamic>) {
            m = res;
          } else if ((i + 1) < ls.length) {
            return nil;
          }
        }
        return res;
      case "setState":
        Map<String, dynamic> m = model.map["stateData"];
        dynamic res;
        if ((input is List<dynamic>) && (input.length == 2)) {
          List<dynamic> ls = (input[0] as String).split("/");
          for (String s in ls) {
            res = m[s];
            if (res == null) {
              if (s == ls.last) {
                m[s] = input[1];
              } else {
                m[s] = {};
              }
            } else if (res is Map<String, dynamic>) {
              m = res;
            }
          }
          return true;
        }
        return false;
      case "search":
        Map<String, dynamic> m = vars ?? {};
        onSearch(Get.context!, m);
        return true;
      case "menu":
        String sel;
        //ValueNotifier<bool> noti;
        if (input is List<dynamic>) {
          sel = input[0];
          Get.back();
          // noti = input[1];
          // noti.value = false;
        } else {
          sel = input;
        }
        switch (sel) {
          case "Search":
            onSearch(Get.context!, {});
            return true;
          default:
            return true;
        }
      case "setBlueprint":
        Map<String, dynamic>? blueprint = model.map['blueprint'];
        if (blueprint == null) {
          return false;
        }
        Map<String, dynamic>? bmap = blueprint["facts"];
        if (bmap != null) {
          facts.addAll(bmap);
        }
        bmap = blueprint["clauses"];
        if (bmap != null) {
          clauses.addAll(bmap);
        }
        bmap = blueprint["objects"];
        if ((bmap != null) && (bmap.isNotEmpty)) {
          bmap.forEach((key, value) {
            Map<String, dynamic> _map = value;
            dynamic exmap = _map["extending"];
            if (exmap != null) {
              if (exmap is String) {
                Map<String, dynamic>? _m = bmap![exmap];
                if (_m != null) {
                  _m.addAll(_map);
                  _map = _m;
                }
              } else if (exmap is List<dynamic>) {
                for (String s in exmap) {
                  Map<String, dynamic>? _m = bmap![s];
                  if (_m != null) {
                    _m.addAll(_map);
                    _map = _m;
                  }
                }
              }
            }
            Map<String, dynamic> _m = {};
            _map.forEach((k, v) {
              if (k != "extending") {
                String? s = (v is String) ? v : null;
                _m[k] = v;
                String _k = key + '.' + k;
                if ((s == null) && (v is List<dynamic>) && (v.isNotEmpty)) {
                  for (var sl in v) {
                    int l = v.length - 1;
                    s = (sl is String) ? sl : null;
                    if ((s != null) &&
                        (s.contains('↲') ||
                            s.contains('⋀') ||
                            s.contains('≔') ||
                            s.contains('⋁'))) {
                      clauses[_k] = v;
                      _m[k] = _k;
                      break;
                    }
                  }
                } else {
                  if ((s != null) &&
                      (s.contains('↲') ||
                          s.contains('⋀') ||
                          s.contains('≔') ||
                          s.contains('⋁'))) {
                    clauses[_k] = v;
                    _m[k] = _k;
                  }
                }
              }
            });
            facts[key] = _m;
          });
        }
        return true;
      case "setConfig":
        if (input is List<dynamic>) {
          String cName = input[0];
          Map<String, dynamic>? config = model.map['cName'];
          if (config == null) {
            return false;
          }
          config = splitLines(config);
          cName = input[1];
          Map<String, dynamic>? facts = model.map[cName];
          facts = (facts != null) ? facts["facts"] : null;
          if (facts == null) {
            return false;
          }
          facts.addAll(config);
          return true;
        }
        return false;
      case "getHeight":
        if (input is double) {
          return input * model.scaleHeight;
        }
        return null;
      case "getWidth":
        if (input is double) {
          return input * model.scaleWidth;
        }
        return null;
      case "getCache":
        return resxController.getCache(input);
      case "setCache":
        if (input is List<dynamic>) {
          resxController.setCache(input[0], input[1]);
          return true;
        }
        return null;
      case "removeCache":
        return resxController.setCache(input, null);
      case "setFact":
        if (input is List<dynamic>) {
          facts[input[0]] = input[1];
          return true;
        }
        return null;

      case "checkNull":
        String name = input[0];
        var data = vars![name] ?? input[1];
        vars[name] = data;
        return true;
      case "isNull":
      case "Ø":
        return (input == null) || (input == nil);
      case "buildDialog":
        if (input == null) {
          return false;
        }
        //Agent a = getAgent("pattern");
        ProcessEvent event = (input is List<dynamic>)
            ? ProcessEvent(input[0])
            : ProcessEvent(input);
        event.map = (input is List<dynamic>) ? input[1] : vars;
        _getDialog(event);
        return true;
      case "showDialog":
        Get.dialog(
          getPatternWidget(input)!,
          useSafeArea: true,
        );
        return true;
      case "showContextDialog":
        showDialog(
            context: model.context!,
            builder: (BuildContext c) {
              return getPatternWidget(input)!;
            });
        return true;
      case "key":
        return GlobalKey();
      case "changeNoti":
        if ((input is! List<dynamic>) || (input.length != 2)) {
          return false;
        }
        ValueNotifier noti = input[0];
        List<dynamic> ld = input[1];
        if (ld.length != 2) {
          return false;
        }
        noti.value = (noti.value == ld[0]) ? ld[1] : ld[0];
        return true;
      case "pushStack":
        model.stack.add(input);
        return true;
      case "popStack":
        List<dynamic> sl = model.stack.last;
        model.stack.removeLast();
        return sl;
/*       case "createNotifier":
        return createNotifier(input);
      case "setNotiValue":
        return setNotiValue(input);
      case "updateListNoti":
        if (input is List<dynamic>) {
          ValueNotifier<List<dynamic>> noti = input[0];
          List<dynamic> value = [];
          List<dynamic> inList = [];
          inList.add(noti.value);
          for (int i = 1; i < input.length; i++) {
            inList.add(input[i]);
          }
          Map<String, dynamic> lmap = {"_outputList": value};
          bool ok = handleList(inList, lmap);
          if (ok) {
            noti.value = value;
            return true;
          }
        }
        return false; */
      case "handleList":
        return handleList(input, vars!);
      case "changeTheme":
        if (themeChanged) {
          return true;
        }
        Get.changeTheme(getMainTheme());
        themeChanged = true;
        return true;
      case "pickDate":
        if (input == null) {
          return null;
        }
        Map<String, dynamic> m = input;
        int py = m["_pYear"] ?? 1;
        int my = m["_mYear"] ?? 1;
        DateTime dateTime = DateTime.now();
        showDatePicker(
                context: model.context ?? GlobalKey().currentContext!,
                initialDate: dateTime,
                firstDate: DateTime(dateTime.year - my),
                lastDate: DateTime(dateTime.year + py))
            .then((d) => _setTimer(m, d));
        return true;
      case "pickTime":
        if (input == null) {
          return null;
        }
        TimeOfDay timeOfDay = TimeOfDay.now();
        showTimePicker(
                context: model.context ?? GlobalKey().currentContext!,
                initialTime: timeOfDay)
            .then((t) => _setTimer(input, t));
        return true;
      case "startTimer":
        Map<String, dynamic> m = input;
        int duration = m["_duration"];
        ProcessEvent pe = ProcessEvent(m["_startName"], map: m);
        Agent a = getAgent("pattern");
        a.process(pe);
        pe = ProcessEvent(m["_name"], map: m);
        timer = Timer.periodic(Duration(seconds: duration), (timer) {
          a.process(pe);
        });
        return true;
      case "stopTimer":
        if (timer != null) {
          timer!.cancel();
          timer = null;
        }
        if (input != null) {
          Map<String, dynamic> m = input;
          ProcessEvent pe = ProcessEvent(m["_name"], map: m);
          Agent a = getAgent("pattern");
          return a.process(pe);
        } else {
          return true;
        }
      case "processNewClause":
        late String cname;
        if (input is List<dynamic>) {
          cname = input[0];
          if (input.length > 1) {
            clauses[input[0]] = input[1];
          }
        } else {
          cname = input;
        }
        ProcessEvent pe = ProcessEvent(cname, map: vars);
        Agent a = getAgent("pattern");
        return a.process(pe);
      default:
        List<dynamic>? f = facts[name];
        if ((f != null) &&
            (input is List<dynamic>) &&
            (f.length == input.length)) {
          for (int i = 0; i < input.length; i++) {
            if ((input[i] is! String)) {
              return false;
            }
            String s = input[i];
            if (s[0] == '_') {
              vars![s] = f[i];
            } else {
              if (s != f[i]) {
                return false;
              }
            }
          }
          return true;
        }
        List<dynamic> objStack = facts['objStack'];
        dynamic c;
        if (objStack.isNotEmpty) {
          int i = objStack.length - 1;
          while ((i >= 0) && (c == null)) {
            Map<String, dynamic> fact = facts[objStack[i]];
            c = fact[name];
            i--;
          }
        }
        c = (c != null) ? clauses[c] : clauses[name];
        if (c != null) {
          if ((input is! Map<String, dynamic>) && (input != null)) {
            ProcessEvent pe = ProcessEvent(name, map: {});
            String s = (c is List<dynamic>) ? c[0] : c;
            int inx = s.indexOf('|');
            if (inx < 0) {
              return false;
            }
            s = s.substring(0, inx);
            List<String> sl = s.split(',');
            if (input is List<dynamic>) {
              if (input.length > sl.length) {
                return false;
              }
              for (int i = 0; i < input.length; i++) {
                String si = sl[i].trim();
                if (si[0] == '_') {
                  if ((input[i] is! String) || (input[i][0] != '_')) {
                    pe.map![si] = input[i];
                  }
                } else if (input[i] is String) {
                  if ((input[i][0] != '_') && (si != input[i])) {
                    return false;
                  } /*  else {
                    pe.map![si] = nil;
                  } */
                }
              }
            } else {
              String si = sl[0].trim();
              if (si[0] == '_') {
                if ((input is! String) || (input[0] != '_')) {
                  pe.map![si] = input;
                }
              } else if (input is String) {
                if ((input[0] != '_') && (si != input)) {
                  return false;
                } /* else {
                  pe.map![si] = nil;
                } */
              }
            }
            Agent a = getAgent("pattern");
            dynamic r = a.process(pe);
            if ((r != null) && (r != false)) {
              if (input is List<dynamic>) {
                for (int i = 0; i < input.length; i++) {
                  if ((input[i] is String) && (input[i][0] == '_')) {
                    String si = sl[i].trim();
                    vars![input[i]] = (si[0] == '_') ? pe.map![si] : si;
                  }
                }
              } else {
                if ((input is String) && (input[0] == '_')) {
                  String si = sl[0].trim();
                  vars![input] = (si[0] == '_') ? pe.map![si] : si;
                }
              }
            }
            return r;
          }
          Agent a = getAgent("pattern");
          ProcessEvent pe = ProcessEvent(name, map: input);
          return a.process(pe);
        }
        Function? func = appFunc[name];
        if (func != null) {
          dynamic r;
          if (input is List<dynamic>) {
            if (input.isEmpty) {
              r = func();
            } else {
              r = Function.apply(func, input);
            }
          } else {
            if (input != null) {
              r = func(input);
            } else {
              r = func();
            }
          }
          return (r != null) ? r : true;
        }
        return false;
    }
  }

  @override
  Function getPattern(String name) {
    Function? pf = getPrimePattern[name] ?? appPatterns[name];
    if (pf == null) {
      patName = name;
      pf = getControlPattern;
    }
    return pf;
  }

  @override
  Agent getAgent(String name) {
    controlAgent.requestAgent(name);
    return controlAgent;
  }

  ProcessPattern getControlPattern(Map<String, dynamic> map) {
    controlAgent.requestAgent("pattern");
    return controlAgent.process(ProcessEvent(patName, map: map));
  }

  @override
  dynamic getResource(String res, String? spec, {dynamic value}) {
    if (res == "textStyleColor") {
      if (value != null) {
        Color c = getResource("color", spec!);
        TextStyle ts = value!;
        ts = ts.copyWith(color: c);
        return ts;
      }
      return null;
    }
    String _res = (res.contains("Color")) ? "color" : res;
    switch (_res) {
      case "appBarHeight":
        return model.appBarHeight;
      case "model":
        if (value == null) {
          return model.map[spec];
        }
        return model.map[spec][value];
      case "color":
        Color? c = colorMap[spec];
        if (c != null) {
          return c;
        }
        return ThemeDecoder.decodeColor(spec, validate: false);
      case "textStyle":
        if (value != null) {
          Map<String, dynamic> m = value;
          Color c = getResource("color", m["_color"]!);
          return getTextStyle(c, m["_size"], m["_weight"]);
        }
        return textStyle[spec];
      case "appRes":
        return resources[spec];
      case "icon":
        return myIcons[spec];
      case "resxValue":
        return resxController.getRxValue(spec!);
      case "setResxValue":
        resxController.setRxValue(spec!, value);
        return true;
      case "hratio":
        return model.scaleHeight * (value as double);
      case "wratio":
        return model.scaleWidth * (value as double);
      case "shratio":
        return model.screenHeight * (value as double);
      case "swratio":
        return model.screenWidth * (value as double);
      case "sizeScale":
        return sizeScale * (value as double);
      case "vertPadding":
        return EdgeInsets.symmetric(vertical: value);
      case "horzPadding":
        return EdgeInsets.symmetric(horizontal: value);
      case "boxPadding":
        return EdgeInsets.all(value);
      case "size5":
        return model.size5;
      case "size10":
        return model.size10;
      case "size20":
        return model.size20;
      case "fontScale":
        return model.fontScale * (value as double);
      case "setCache":
        resxController.setCache(spec!, value);
        return true;
      case "getCache":
        return resxController.getCache(spec!);
      case "removeCache":
        resxController.setCache(spec!, null);
        return true;
      case "lookup":
        return model.map["lookup"][spec];
      case "pageController":
        return PageController();
      case "refreshController":
        return RefreshController();
      case "textController":
        return TextEditingController();
      case "focusNode":
        return FocusNode();
      case "function":
        return appFunc[spec];
      case "text":
        return text[spec];
      case "schema":
        return schema[spec];
      case "infinity":
        return double.infinity;
      default:
        return resources[res];
    }
  }

  _setTimer(Map<String, dynamic> m, dynamic d) {
    if (d == null) {
      return;
    }
    m["_dateTime"] = d;
    String event = m["_processEvent"] ?? "setTimerEvent";
    ProcessEvent pe = ProcessEvent(event, map: {"_map": m});
    Agent a = getAgent("pattern");
    return a.process(pe);
  }

  @override
  addFunctions(Map<String, Function>? func) {
    if (func != null) {
      appFunc.addAll(func);
    }
  }

  @override
  addPatterns(Map<String, Function>? pat) {
    if (pat != null) {
      appPatterns.addAll(pat);
    }
  }

  _getDialog(ProcessEvent event) async {
    Agent a = getAgent("pattern");
    ProcessPattern p = a.process(event);
    Widget w = AlertDialog(
      content: getPatternWidget(p)!,
    );
    Get.dialog(w, navigatorKey: GlobalKey());
  }
}

class ControlAgent extends Agent {
  List<ProcessEvent> processStack = [];
  String _type = "pattern";
  Map<String, dynamic> patterns = model.map["patterns"];
  String mapName = "patMap";

  @override
  dynamic process(ProcessEvent event) {
    switch (_type) {
      case "process":
        return agentProcess(event);
      case "pattern":
        LogicProcessor lp = LogicProcessor(patterns);
        if (event.map != null) {
          lp.vars.addAll(event.map!);
        }
        var r = lp.process(event.name);
        if ((event.map != null) && (event.map!.length <= lp.vars.length)) {
          List<String> l = lp.vars.keys.toList();
          for (String k in l) {
            //if (event.map![k] == null) {
            if (lp.vars[k] != null) {
              event.map![k] = lp.vars[k];
            }
            //}
          }
        }
        return r;
      default:
        break;
    }
    return false;
  }

  requestAgent(String type) {
    _type = type;
  }

  dynamic agentProcess(ProcessEvent event) {
    return false;
  }

  bool mapPat(List<dynamic> l, Map<String, dynamic> vars) {
    if (l.length != 2) {
      return false;
    }
    List<dynamic> pl = (l[1] is String) ? l[1].split(';') : l[1];
    List<dynamic> patHeader = (l[0] is String) ? l[0].split(';') : l[0];
    int len = (patHeader.length > pl.length) ? pl.length : patHeader.length;
    for (int i = 0; i < len; i++) {
      var ipat = pl[i];
      ipat = (ipat is String)
          ? (ipat.isEmpty)
              ? nil
              : (ipat[0] == '_')
                  ? vars[ipat] ?? ipat
                  : ipat
          : ipat;
      String k = '_' + patHeader[i];
      if ((ipat != nil) && (ipat != exist)) {
        switch (k) {
          case "_hratio":
            k = "_height";
            double h = ipat * model.scaleHeight;
            vars[k] = h;
            break;
          case "_wratio":
            k = "_width";
            double w = ipat * model.scaleWidth;
            vars[k] = w;
            break;
          case "_color":
            vars[k] = ThemeDecoder.decodeColor(ipat, validate: false);
            break;
          case "_alignment":
          case "_align":
            vars[k] = ThemeDecoder.decodeAlignment(ipat, validate: false);
            break;
          case "_crossAxisAlignment":
            vars[k] =
                ThemeDecoder.decodeCrossAxisAlignment(ipat, validate: false);
            break;
          case "_mainAxisAlignment":
            vars[k] =
                ThemeDecoder.decodeMainAxisAlignment(ipat, validate: false);
            break;
          case "_mainAxisSize":
            vars[k] = ThemeDecoder.decodeMainAxisSize(ipat, validate: false);
            break;
          case "_verticalDirection":
            vars[k] =
                ThemeDecoder.decodeVerticalDirection(ipat, validate: false);
            break;
          case "_padding":
          case "_margin":
            vars[k] =
                ThemeDecoder.decodeEdgeInsetsGeometry(ipat, validate: false);
            break;
          default:
            var s = (ipat is String)
                ? int.tryParse(ipat) ??
                    (double.tryParse(ipat) ??
                        ((ipat == "true")
                            ? true
                            : (ipat == "false")
                                ? false
                                : ipat))
                : ipat;
            if (s is String) {
              if (s[0] == '[') {
                s = s.substring(1, s.length - 1);
                vars[k] = getListData(s);
              } else if (s[0] == '{') {
                s = s.substring(1, s.length - 1);
                vars[k] = getMapContent(s);
              } else {
                vars[k] = s;
              }
            } else {
              vars[k] = s;
            }
            break;
        }
      } else {
        if ((ipat == nil) && (vars[k] != null)) {
          vars[k] = null;
        }
      }
    }
    return true;
  }

  dynamic decode(List<dynamic> l, Map<String, dynamic> vars) {
    String name = l[0];
    var v = l[1];
    switch (name) {
      case "borderRadius":
        return ThemeDecoder.decodeBorderRadius(v, validate: false);
      case "alignment":
      case "align":
        if (v is Map<String, dynamic>) {
          return Alignment(v["horiz"], v["vert"]);
        }
        return ThemeDecoder.decodeAlignment(v, validate: false);
      case "textAlign":
        return ThemeDecoder.decodeTextAlign(v, validate: false);
      case "axis":
        if (v == "horizontal") {
          return Axis.horizontal;
        } else if (name == "vertical") {
          return Axis.vertical;
        }
        break;
      case "padding":
      case "margin":
        return ThemeDecoder.decodeEdgeInsetsGeometry(v, validate: false);
      case "mainAxisAlignment":
        return ThemeDecoder.decodeMainAxisAlignment(v, validate: false);
      case "wrapAlignment":
        return ThemeDecoder.decodeWrapAlignment(v, validate: false);
      case "wrapCrossAlignment":
        return ThemeDecoder.decodeWrapCrossAlignment(v, validate: false);
      default:
        return null;
    }
  }
}
