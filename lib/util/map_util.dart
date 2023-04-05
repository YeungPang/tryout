import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geocoding/geocoding.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:tryout/agent/config_agent.dart';
import '../builder/pattern.dart';
import '../model/locator.dart';
import '../resources/basic_resources.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:image_picker/image_picker.dart';

class MapUtil {
  MapUtil._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    await launchUrlString(googleMapUrl);
  }

  static Future<void> openMapFromAddr(String addr) async {
    List<Location> placemarks = await locationFromAddress(addr);
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=" +
        placemarks[0].latitude.toString() +
        ',' +
        placemarks[0].longitude.toString();
    //await launch(googleMapUrl);
    if (await canLaunchUrlString(googleMapUrl)) {
      await launchUrlString(googleMapUrl);
    } else {
      throw "Cannot open map";
    }
  }

  static Future<void> addrToMap(String addr) async {
    MapsLauncher.launchQuery(addr);
    // String addrPlus = addr.replaceAll(' ', '+');
    // String googleMapUrl = "https://www.google.com/maps/place/" + addrPlus;
    // await launchUrlString(googleMapUrl);
  }

  static Future<void> toTel(String telNo) async {
    await launchUrlString("tel:" + telNo);
  }

  static Future<void> toUrl(String url) async {
    await launchUrlString("https://" + url);
  }
}

setTimer(Map<String, dynamic> m) {
  dynamic d = m["_dateTime"] ?? DateTime.now();
  String event = m["_event"];
  Map<String, dynamic> map = m["_map"];
  Map<String, dynamic> mTimer = map["_mTimer"];
  String dayField = m["_dayField"] ?? "day";
  String timeField = m["_timeField"] ?? "time";
  if (event.contains("timer")) {
    String date = getDate(d);
    String time = getTime(d);
    DateTime dt = d;
    if (event.contains("Start")) {
      mTimer["_dayStart"] = d;
      mTimer["_timeStart"] = TimeOfDay(hour: dt.hour, minute: dt.minute);
      dayField += "Start";
      timeField += "Start";
    } else {
      mTimer["_dayStop"] = d;
      mTimer["_timeStop"] = TimeOfDay(hour: dt.hour, minute: dt.minute);
      dayField += "Stop";
      timeField += "Stop";
      _setTotal(map, mTimer);
    }
    resxController.setRxValue(dayField, date);
    resxController.setRxValue(timeField, time);
  } else {
    mTimer['_' + event] = d;
    String sfix = event.contains("Start") ? "Start" : "Stop";
    if (event.contains("day")) {
      String date = getDate(d);
      resxController.setRxValue(dayField + sfix, date);
    } else {
      String time = getTime(d);
      resxController.setRxValue(timeField + sfix, time);
    }
    if ((mTimer["_dayStart"] != null) &&
        (mTimer["_timeStart"] != null) &&
        (mTimer["_dayStop"] != null) &&
        (mTimer["_timeStop"] != null)) {
      _setTotal(map, mTimer);
    }
  }
}

_setTotal(Map<String, dynamic> m, Map<String, dynamic> mTimer) {
  String totalField = m["_totalField"] ?? "totalTime";
  List<dynamic> il = [mTimer, m["_dataType"]];
  if (m["_dataTag"] != null) {
    il.add(m["_dataTag"]);
  }
  String tis = getTimeInterval(il);
  resxController.setRxValue(totalField, tis);
}

String getTime(dynamic dateTime) {
  if (dateTime is DateTime) {
    return dateTime.hour.toString() + ':' + dateTime.minute.toString();
  } else if (dateTime is TimeOfDay) {
    return dateTime.hour.toString() + ':' + dateTime.minute.toString();
  }
  return "";
}

String getDate(DateTime dateTime) {
  return dateTime.day.toString() +
      '.' +
      dateTime.month.toString() +
      '.' +
      dateTime.year.toString();
}

dynamic getTimeInterval(List<dynamic> dl) {
  Map<String, dynamic> mTimer = dl[0];
  dynamic dataType = (dl.length > 1) ? dl[1] : null;
  DateTime d = mTimer["_dayStart"];
  TimeOfDay t = mTimer["_timeStart"];
  DateTime sdt = DateTime(d.year, d.month, d.day, t.hour, t.minute);
  d = mTimer["_dayStop"];
  t = mTimer["_timeStop"];
  DateTime edt = DateTime(d.year, d.month, d.day, t.hour, t.minute);
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
    case "hmstr":
    case "dhm":
    case "dhmstr":
      int min = diff.inMinutes;
      int hr = min ~/ 60;
      min = min % 60;
      if (dataType == "hmstr") {
        return (hr.toString() + ':' + min.toString());
      }
      int d = hr ~/ 24;
      hr = hr % 24;
      String dstr = (dl.length > 2) ? dl[2] : 'd';
      if (dataType == "dhmstr") {
        return (d.toString() +
            dstr +
            ' ' +
            hr.toString() +
            ':' +
            min.toString());
      }
      return {"day": d, "hour": hr, "minute": min};
    default:
      return diff;
  }
}

initTimer(Map<String, dynamic> m) {
  String dayField = m["_dayField"] ?? "day";
  String timeField = m["_timeField"] ?? "time";
  String cacheName = m["_cacheName"];
  Map<String, dynamic> mTimer = resxController.getCache(cacheName) ?? {};
  DateTime? d = mTimer["_dayStart"];
  String ds = (d == null) ? "__.__.____" : getDate(d);
  resxController.setRxValue(dayField + "Start", ds);
  d = mTimer["_dayStop"];
  ds = (d == null) ? "__.__.____" : getDate(d);
  resxController.setRxValue(dayField + "Stop", ds);
  TimeOfDay? t = mTimer["_timeStart"];
  ds = (t == null) ? "__:__" : getTime(t);
  resxController.setRxValue(timeField + "Start", ds);
  t = mTimer["_timeStop"];
  ds = (t == null) ? "__:__" : getTime(t);
  resxController.setRxValue(timeField + "Stop", ds);
  m["_mTimer"] = mTimer;
  if ((mTimer["_dayStart"] != null) &&
      (mTimer["_timeStart"] != null) &&
      (mTimer["_dayStop"] != null) &&
      (mTimer["_timeStop"] != null)) {
    _setTotal(m, mTimer);
  } else {
    String totalField = m["_totalField"] ?? "totalTime";
    resxController.setRxValue(totalField, "00:00");
  }
  if (mTimer.isEmpty) {
    resxController.setCache(cacheName, mTimer);
  }
}

scanQRCode(Map<String, dynamic> map) {
  String lineColor = map["_lineColor"] ?? "#FF1785C1";
  String cancelButtonText = map["_cancel"] ?? "cancel";
  bool isShowFlashIcon = map["_flash"] ?? true;
  FlutterBarcodeScanner.scanBarcode(
          lineColor, cancelButtonText, isShowFlashIcon, ScanMode.QR)
      .then((value) {
    processValue(map, value);
  }).catchError((error) {
    ProcessEvent? pe = map["_errEvent"];
    if (pe != null) {
      Agent a = model.appActions.getAgent("pattern");
      pe.map = map["_errMap"] ?? {};
      pe.map!["_err"] = error.toString();
      a.process(pe);
    }
  });
}

processValue(Map<String, dynamic> map, dynamic value) {
  dynamic _pe = map["_processEvent"] ?? map["_onTap"];
  ProcessEvent? pe = (_pe is String) ? ProcessEvent(_pe) : _pe;
  if (pe == null) {
    return;
  }
  Agent a = model.appActions.getAgent("pattern");
  Map<String, dynamic>? _inMap = map["_inMap"];
  if (_inMap != null) {
    if (pe.map != null) {
      pe.map!.addAll(_inMap);
    } else {
      pe.map = _inMap;
    }
  }
  //pe.map ??= map["_inMap"];
  if (value != null) {
    pe.map ??= {};
    pe.map!["_value"] = value;
  }
  a.process(pe);
}

imagePicker(Map<String, dynamic> map) {
  String imgs = map["_imageSource"];
  ImageSource imageSource =
      (imgs == 'camera') ? ImageSource.camera : ImageSource.gallery;
  ImagePicker().pickImage(source: imageSource).then((value) {
    processValue(map, value);
  });
}

String? getText(Map<String, dynamic> map) {
  TextEditingController? tc = map["_textController"];
  bool clear = map["_clear"] ?? false;
  if (tc == null) {
    return null;
  }
  String? _txt = tc.text;
  if (clear) {
    tc.text = "";
  }
  return _txt;
}

Color? getMapColor(Map<String, dynamic> map) {
  dynamic c = map["_color"];
  if (c == null) {
    return null;
  }
  if (c is String) {
    return colorMap[c];
  }
  return c;
}

xFileToUint8List(Map<String, dynamic> map) async {
  XFile xfile = map['_xfile'];
  final path = xfile.path;
  File(path).readAsBytes().then((value) {
    processValue(map, value);
  });
}

List<dynamic> remapData(Map<String, dynamic> map) {
  List<dynamic> _value = map["_value"];
  List<dynamic> _rvalue = [];
  List<dynamic> _fields = map["_fields"];
  for (Map<String, dynamic> m in _value) {
    Map<String, dynamic> rm = {};
    for (var k in _fields) {
      dynamic v = m[k];
      if (v != null) {
        rm[k] = v;
      }
    }
    if (rm.isNotEmpty) {
      _rvalue.add(rm);
    }
  }
  return _rvalue;
}

mapList(Map<String, dynamic> map) {
  String listName = map['_listName'];
  String keyName = map['_key'];
  Map<String, dynamic> item = map['_item'];
  String str = item[listName];
  List<dynamic> ld = [];
  RegExp re = RegExp(r"[\[\],]");
  List<String> ninx = str.split(re);
  for (String s in ninx) {
    if (s.isNotEmpty) {
      ld.add(s.trim());
    }
  }
  item[keyName] = ld;
}

ImageProvider? getImageProvider(dynamic image) {
  ImageProvider? ip;
  if (image != null) {
    if (image is String) {
      if (image.contains("http")) {
        ip = CachedNetworkImageProvider(image);
      } else {
        ip = AssetImage(image);
      }
    } else if (image is Uint8List) {
      ip = MemoryImage(image);
    } else if ((image is File) || (image is XFile)) {
      File f = (image is XFile) ? File(image.path) : image;
      ip = FileImage(f);
    }
  }
  return ip;
}
