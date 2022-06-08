import 'package:get/get.dart';
import 'package:webxene_core/auth_manager.dart';
import 'package:webxene_core/instance_manager.dart';

import '../../model/locator.dart';
import '../../util/map_util.dart';

xeminoAppInit() {
  Map<String, Function> func = {
    "addrToMap": MapUtil.addrToMap,
    "toTel": MapUtil.toTel,
    "setTimer": setTimer,
    "getTimeInterval": getTimeInterval,
    "getDate": getDate,
    "getTime": getTime,
    "login": login,
  };
  model.appActions.addFunctions(func);
}

setTimer(Map<String, dynamic> m) {
  dynamic d = m["_inTimer"] ?? DateTime.now();
  String pref = m["_company"];
  String event = m["_event"];
  late DateTime dateTime;
  String timerP = "timer" + pref;
  Map<String, dynamic> mTimer = resxController.getCache(timerP) ?? {};
  String state = mTimer["_state"] ?? "new";
  if (event == "timer") {
    if (state == "new") {
      dateTime = d;
      mTimer["_start"] = d;
      mTimer["_state"] = "new";
    } else {
      dateTime = mTimer["_start"];
    }
    String date = getDate(dateTime);
    String time = getTime(dateTime);
    resxController.setRxValue("dateStart" + pref, date);
    resxController.setRxValue("timeStart" + pref, time);
    switch (state) {
      case "edited":
      case "stopped":
        dateTime = mTimer["_end"];
        break;
      default:
        dateTime = d;
        mTimer["_end"] = d;
    }
    date = getDate(dateTime);
    time = getTime(dateTime);
    resxController.setRxValue("dateEnd" + pref, date);
    resxController.setRxValue("timeEnd" + pref, time);
  } else {
    switch (event) {
      case "start":
        mTimer["_state"] = "started";
        break;
      case "stop":
      case "timing":
        if (event == "stop") {
          mTimer["_state"] = "stopped";
        }
        mTimer["_end"] = d;
        resxController.setRxValue("dateEnd" + pref, getDate(d));
        resxController.setRxValue("timeEnd" + pref, getTime(d));
        break;
      default:
        dateTime =
            (event.contains("Start")) ? mTimer["_start"] : mTimer["_end"];
        mTimer["_state"] = "edited";
        late DateTime dt;
        if (event.contains("date")) {
          dt = DateTime(d.year, d.month, d.day, dateTime.hour, dateTime.minute);
          resxController.setRxValue(event + pref, getDate(dt));
        } else {
          if (event == "timing") {
            dt = d;
          } else {
            dt = DateTime(
                dateTime.year, dateTime.month, dateTime.day, d.hour, d.minute);
          }
          resxController.setRxValue(event + pref, getTime(dt));
        }
        if (event.contains("Start")) {
          mTimer["_start"] = dt;
        } else {
          mTimer["_end"] = dt;
        }
        break;
    }
  }
  resxController.setCache(timerP, mTimer);
}

dynamic getTimeInterval(List<dynamic> dl) {
  String spref = dl[0];
  dynamic dataType = (dl.length > 1) ? dl[1] : null;
  Map<String, dynamic> m = resxController.getCache("timer" + spref);
  DateTime? sdt = m["_start"];
  DateTime? edt = m["_end"];
  if ((sdt == null) || (edt == null)) {
    return null;
  }
  final diff = edt.difference(sdt);
  switch (dataType) {
    case "day":
      return diff.inDays;
    case "hour":
      return diff.inHours;
    case "minute":
      return diff.inMinutes;
    case "second":
      return diff.inSeconds;
    case "dhm":
    case "dhmstr":
      int min = diff.inMinutes;
      int hr = min ~/ 60;
      int d = hr ~/ 24;
      hr = hr % 24;
      min = min % 60;
      if (dataType == "dhmstr") {
        return (d.toString() + ':' + hr.toString() + ':' + min.toString());
      }
      return {"day": d, "hourr": hr, "minute": min};
    default:
      return diff;
  }
}

String getTime(DateTime dateTime) {
  return dateTime.hour.toString() + ':' + dateTime.minute.toString();
}

String getDate(DateTime dateTime) {
  return dateTime.day.toString() +
      '.' +
      dateTime.month.toString() +
      '.' +
      dateTime.year.toString();
}

login(List<dynamic> dl) {
  InstanceManager().setupInstance(dl[0], {
    'instance': {'DEBUG_HTTP': false}
  });
  AuthManager().runSingleStageLogin(dl[1], dl[2]).then((_) {
    if (AuthManager().state == AuthState.complete) {
      Get.toNamed("/sample");
    }
  });
}
