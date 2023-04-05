import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './pattern.dart';
import './std_pattern.dart';
import '../resources/basic_resources.dart';
import '../model/locator.dart';
import './special_pattern.dart';

class CheckListView extends StatelessWidget {
  final Map<String, dynamic> map;
  final List<String> level = ["high", "medium"];

  CheckListView(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? _rxName = map["_rxName"];
    bool dismissible = (_rxName != null);
    late List<dynamic> data;
    if (dismissible) {
      return Obx(() {
        data = resxController.getRxValue(_rxName);
        return ListView.builder(
            itemBuilder: ((context, index) {
              return _itemBuilder(context, index, data, _rxName);
            }),
            itemCount: data.length);
      });
    }
    data = map["_data"];
    return ListView.builder(
        itemBuilder: ((context, index) {
          return _itemBuilder(context, index, data, null);
        }),
/*         separatorBuilder: ((context, index) {
          return map["_separator"] ??
              SizedBox(
                height: size10,
              );
        }), */
        itemCount: data.length);
  }

  Widget _itemBuilder(
      BuildContext context, int index, List<dynamic> data, String? _rxName) {
    Map<String, dynamic> dmap = data[index];
    Map<String, dynamic> inMap = dmap["_inMap"] ?? {};
    inMap["_index"] = index;
    String? _level = dmap["_level"];
    int inx = (_level != null) ? level.indexOf(_level) : -1;
    switch (inx) {
      case 0:
        dmap['_fillColor'] = "incorrect";
        break;
      case 1:
        dmap['_fillColor'] = "btnBlue";
        break;
      default:
        dmap['_fillColor'] = "grey";
        break;
    }
    dmap["_checkColor"] = "white";
    dmap["_shape"] =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
    ProcessPattern pp = CheckBoxPattern(dmap);
    Widget cb = pp.getWidget();
    Map<String, dynamic> tmap = {"_text": dmap["_content"], "_maxLines": 10};
    pp = WrapTextPattern(tmap);
    if (_rxName != null) {
      return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            List<dynamic> removedList = map["_removed"] ?? [];
            removedList.add(data[index]);
            map["_removed"] = removedList;
            data.removeAt(index);
            resxController.setRxValue(_rxName, data);
          },
          background: Container(
            child: const Center(
                child: Icon(
              Icons.delete,
              color: Colors.white,
            )),
            decoration: imageDecoration,
          ),
          child: Card(
            child: ListTile(
              leading: cb,
              title: Text(dmap['_title']),
              subtitle: pp.getWidget(),
            ),
          ));
    }
    return Card(
      child: ListTile(
        leading: cb,
        title: Text(dmap['_title']),
        subtitle: Text(dmap['_content']),
      ),
    );
  }
}

class CheckListPattern extends ProcessPattern {
  CheckListPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return CheckListView(map);
  }
}
