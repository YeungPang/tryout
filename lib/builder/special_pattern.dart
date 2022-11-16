import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';
import 'package:tryout/resources/icons.dart';
import './pattern.dart';
import './std_pattern.dart';
import '../model/locator.dart';
import '../resources/basic_resources.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../resources/fonts.dart';
import 'package:get/get.dart';
import '../resources/basic_resources.dart';
import 'package:flutter_switch/flutter_switch.dart';

class DraggablePattern extends ProcessPattern {
  DraggablePattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    Widget? c = getPatternWidget(map["_child"]);
    Widget? f = getPatternWidget(map["_feedback"]);
    Widget? d = getPatternWidget(map["_childWhenDragging"]);
    return Draggable(
        data: map["_data"],
        onDragStarted: () {
          ProcessEvent? action = map["_dragStarted"];
          if (action != null) {
            model.appActions.doFunction(action.name, action.map, action.map);
          }
        },
        child: c!,
        feedback: Opacity(
          child: f ?? c,
          opacity: 0.7,
        ),
        childWhenDragging: d ?? c);
  }
}

class DragTargetPattern extends ProcessPattern {
  DragTargetPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    Widget? c = getPatternWidget(map["_target"]);
    return DragTarget(
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {
        ProcessEvent? dropAction = map["_dropAction"];
        if (dropAction != null) {
          String? key = map["_key"];
          if (key != null) {
            map[key] = data;
          }
          Map<String, dynamic> dmap = {};
          if ((data != null) && (data is Map<String, dynamic>)) {
            dmap.addAll(data);
          }
          if (dropAction.map != null) {
            dmap.addAll(dropAction.map!);
          }
          model.appActions.doFunction(dropAction.name, dmap, dropAction.map);
        }
      },
      builder: (context, incoming, rejected) {
        return c!;
      },
    );
  }
}

class ImageBanner extends StatelessWidget {
  final String name;
  final double height;

  const ImageBanner(this.name, {this.height = 200.0, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(height: height * sizeScale),
        decoration: const BoxDecoration(color: Colors.grey),
        child: Image.asset(
          name,
          fit: BoxFit.cover,
        ));
  }
}

class ImageBannerPattern extends ProcessPattern {
  ImageBannerPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return (map["_widget"] ??=
        ImageBanner(map["_name"]!, height: map["_height"]));
  }
}

class InTextField extends StatelessWidget {
  final Map<String, dynamic> map;

  const InTextField(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController tc = map["_textController"];
    // Map<String, dynamic> pMap;
    // pMap = map["_parent"];
    // if (pMap != null) {
    //   pMap["_textEditingController"] = tc;
    // }
    Widget? p = getPatternWidget(map["_prefixIcon"]);
    Widget? s = getPatternWidget(map["_suffixIcon"]);
    Widget? ic = getPatternWidget(map["icon"]);
    return TextField(
      autocorrect: map["_autocorrect"] ?? true,
      autofocus: map["_autofocus"] ?? true,
      controller: tc,
      onEditingComplete: () => _completeEdit(tc, context),
      enabled: map["_enabled"] ?? true,
      style: map["_textStyle"],
      showCursor: map["_showCursor"],
      maxLines: map["_maxLines"] ?? 1,
      expands: map["_expands"] ?? false,
      onSubmitted: map["_onSubmitted"],
      keyboardType: map["_keyboardType"],
      decoration: InputDecoration(
        border: map["_inputBorder"] ?? const OutlineInputBorder(),
        icon: ic,
        hintText: map["_hintText"],
        hintStyle: map["_hintStyle"],
        labelText: map["_labelText"],
        labelStyle: map["_labelStyle"],
        prefixIcon: p,
        suffixIcon: s,
        filled: map["_filled"],
        fillColor: map["_fillColor"],
        contentPadding: map["_padding"],
      ),
    );
  }

  _completeEdit(TextEditingController tc, BuildContext context) {
    String text = tc.text.toString();
    if (text.isNotEmpty) {
      dynamic actions = map["_complete"];
      if (actions != null) {
        if (actions is ProcessEvent) {
          model.appActions.doFunction(actions.name, actions.map, actions.map);
        } else if (actions is Map<String, dynamic>) {
          model.appActions.doFunction(
              actions["_func"], actions["_tapAction"], actions["_map"]);
        }
      }
      bool clear = map["_clear"] ?? false;
      if (clear) {
        tc.clear();
      }
    } else {
      ProcessEvent? actions = map["_incomplete"];
      if (actions != null) {
        model.appActions.doFunction(actions.name, actions.map, actions.map);
      }
    }
    bool retainFocus = map["_retainFocus"] ?? false;
    if (retainFocus) {
      FocusScope.of(context).requestFocus();
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}

class InTextFieldPattern extends ProcessPattern {
  InTextFieldPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return InTextField(map);
  }
}

class ValueText<T> extends StatelessWidget {
  final Map<String, dynamic> map;

  const ValueText(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: map["_notifier"],
      builder: (BuildContext context, T value, Widget? child) =>
          _getListenerWidget(value),
    );
  }

  Widget _getListenerWidget(T value) {
    Function? f = map["_converter"];
    map["_text"] = (f != null) ? f(value, map) : value.toString();
    ProcessPattern p = TextPattern(map);
    map["widget"] = p.getWidget();
    return map["widget"];
  }
}

class ValueTextPattern<T> extends ProcessPattern {
  ValueTextPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return ValueText<T>(map);
  }
}

class ValueChildContainer extends StatelessWidget {
  final Map<String, dynamic> map;

  const ValueChildContainer(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProcessPattern>(
      valueListenable: map["_childNoti"],
      builder: (BuildContext context, ProcessPattern value, Widget? child) =>
          _getContainer(value),
    );
  }

  Widget _getContainer(ProcessPattern value) {
    Widget? w = getPatternWidget(value);
    return Container(
        child: w,
        color: map["_color"],
        alignment: map["_alignment"],
        clipBehavior: map["_clipBehavior"] ?? Clip.none,
        constraints: map["_boxConstraints"],
        decoration: map["_decoration"],
        foregroundDecoration: map["_foregroundDecoration"],
        width: map["_width"],
        height: map["_height"],
        margin: map["_margin"],
        padding: map["_padding"],
        transform: map["_transform"]);
  }
}

class ValueChildContainerPattern extends ProcessPattern {
  ValueChildContainerPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return ValueChildContainer(map);
  }
}

class TapItem extends StatelessWidget {
  final Map<String, dynamic> map;

  const TapItem(this.map, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget? w = getPatternWidget(map["_child"]);
    return GestureDetector(onTap: () => _onTap(context, map), child: w);
  }
}

tapAction(Map<String, dynamic> map) {
  _onTap(Get.context, map);
}

_onTap(BuildContext? context, Map<String, dynamic> map) {
  dynamic onTap = map["_onTap"];
  String? func;
  dynamic m;
  Map<String, dynamic>? _map;
  if (onTap is Map<String, dynamic>) {
    func = onTap["_func"];
    m = onTap["_tapAction"];
    _map = onTap["_map"];
  } else if (onTap is ProcessEvent) {
    func = onTap.name;
    m = map["_tapAction"];
    _map = onTap.map;
  }
  if (func != null) {
    GlobalKey? key = map["_key"];
    if (m is Map<String, dynamic>) {
      dynamic rxName = m["_rxName"];
      double op = (rxName == null) ? 1.0 : resxController.getRxValue(rxName);
      if (op <= 0.5) {
        return;
      }
    }
    model.context = (key == null) ? context : key.currentContext;
    model.appActions.doFunction(func, m, _map);
    //controller.model.context = null;
  }
}

class TapItemPattern extends ProcessPattern {
  TapItemPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return TapItem(map);
  }
}

class BadgePattern extends ProcessPattern {
  BadgePattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    Widget? w = getPatternWidget(map["_child"]);
    Widget? bw = getPatternWidget(map["_badgeContext"]);
    return Badge(
      badgeContent: bw,
      badgeColor: map["_badgeColor"],
      showBadge: map["_showBadge"] ?? true,
      padding: const EdgeInsets.all(0.0),
      child: w,
    );
  }
}

class CardPattern extends ProcessPattern {
  CardPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    Widget? w = getPatternWidget(map["_child"]);
    return Card(
      color: map["_cardColor"],
      shadowColor: map["_shadowColor"],
      elevation: map["_elevation"],
      shape: map["_shape"] ??
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(map["_cardRadius"] ?? 4.0)),
      borderOnForeground: map["_borderOnForeground"] ?? true,
      margin: map["_margin"],
      clipBehavior: map["_clipBehavior"],
      child: w,
    );
  }
}

class ValueOpacityPattern extends ProcessPattern {
  ValueOpacityPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return ValueListenableBuilder<double>(
      valueListenable: map["_notifier"],
      builder: (BuildContext context, double value, Widget? child) => Opacity(
        child: getPatternWidget(map["_child"]),
        opacity: value,
      ),
    );
  }
}

class ObxOpacityPattern extends ProcessPattern {
  ObxOpacityPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    String rxName = map["_rxName"];
    return Obx(() {
      return Opacity(
        child: getPatternWidget(map["_child"]),
        opacity: resxController.getRxValue(rxName),
      );
    });
  }
}

class ScrollLayoutPattern extends ProcessPattern {
  ScrollLayoutPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    Widget? w = getPatternWidget(map["_child"]);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: w,
          ),
        ),
      );
    });
  }
}

class DottedBorderPattern extends ProcessPattern {
  DottedBorderPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    Widget? w = getPatternWidget(map["_child"]);
    double? r = map["_radius"];
    return DottedBorder(
      dashPattern: map["_dashPattern"] ?? [4, 2],
      strokeWidth: map["_strokeWidth"] ?? 1,
      radius: (r != null) ? Radius.circular(r) : const Radius.circular(0),
      borderType: (r != null) ? BorderType.RRect : BorderType.Rect,
      color: map["_dottedColor"],
      child: w!,
    );
  }
}

class InteractiveViewerPattern extends ProcessPattern {
  InteractiveViewerPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    Widget? w = getPatternWidget(map["_child"]);
    return InteractiveViewer(
      scaleEnabled: map["_scaleEnabled"] ?? true,
      panEnabled: map["_panEnabled"] ?? true,
      constrained: false,
      minScale: map["_minScale"] ?? 0.1,
      maxScale: map["_maxScale"] ?? 4,
      child: w!,
    );
  }
}

class WillPopScopeActionsPattern extends ProcessPattern {
  WillPopScopeActionsPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    Widget? w = getPatternWidget(map["_child"]);
    return WillPopScope(
      onWillPop: () async {
        ProcessEvent? actions = map["_backActions"];
        if (actions != null) {
          model.appActions.getAgent("action").process(actions);
        }
        return true;
      },
      child: w!,
    );
  }
}

class ColorButton extends StatelessWidget {
  final Map<String, dynamic> map;

  const ColorButton(this.map, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double borderRadius = map["_btnBRadius"] ?? size10;
    Widget? w = getPatternWidget(map["_child"]);
    var grad = map["_gradient"];
    if (grad is String) {
      grad = resources[grad];
    }
    Gradient? g = grad ??
        ((map["_beginColor"] == null)
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [map["_beginColor"], map["_endColor"]]));
    Color? c = map["_color"];
    BoxBorder? b = (map["_borderColor"] == null)
        ? null
        : Border.all(
            color: map["_borderColor"], width: map["_borderWidth"] ?? 1.0);

    BoxDecoration box = BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: b,
      color: c,
      gradient: g,
      boxShadow: (map["_noShadow"] != null)
          ? null
          : [
              BoxShadow(
                color: Colors.grey[400]!,
                offset: const Offset(
                  2, // Move to right 10  horizontally
                  2, // Move to bottom 10 Vertically
                ),
              )
            ],
    );
    return Container(
      alignment: map["_cbAlignment"] ?? Alignment.center,
      height: map["_height"],
      width: map["_width"],
      decoration: box,
      child: w,
    );
  }
}

class ColorButtonPattern extends ProcessPattern {
  ColorButtonPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return ColorButton(map);
  }
}

class ValueTypeListener<T> extends StatelessWidget {
  final Map<String, dynamic> map;

  const ValueTypeListener(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: map["_notifier"],
      builder: (BuildContext context, T value, Widget? child) =>
          _getListenerWidget(value),
    );
  }

  Widget _getListenerWidget(T value) {
    ProcessPattern child = map["_child"];
    String? key = map["_notifierKey"];
    key ??= (value is List<dynamic>) ? "_children" : "_child";
    child.map[key] = value;
    return getPatternWidget(child)!;
  }
}

class ValueTypeListenerPattern<T> extends ProcessPattern {
  ValueTypeListenerPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return ValueTypeListener<T>(map);
  }
}

class IconButtonWidget extends StatelessWidget {
  final Map<String, dynamic> map;

  const IconButtonWidget(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var icv = map["_icon"];
    Widget? w;
    if (icv is String) {
      Function iepf = model.appActions.getPattern("Icon")!;
      ProcessPattern pp = iepf(map);
      w = pp.getWidget();
    } else {
      w = getPatternWidget(icv);
    }
    //Icon ic = w! as Icon;
    return IconButton(
      icon: w!,
      padding: map["_padding"] ?? const EdgeInsets.all(8.0),
      onPressed: () => _onTap(context, map),
    );
  }
}

class IconButtonPattern extends ProcessPattern {
  IconButtonPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return IconButtonWidget(map);
  }
}

class IconTextWidget extends StatelessWidget {
  final Map<String, dynamic> map;

  const IconTextWidget(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var icv = map["_icon"];
    Widget? w;
    if (icv is String) {
      Function iepf = model.appActions.getPattern("Icon")!;
      ProcessPattern pp = iepf(map);
      w = pp.getWidget();
    } else {
      w = getPatternWidget(icv);
    }

    bool isHoriz = map["_horiz"] ?? false;
    Widget? gap = (map["_gap"] == null) ? null : getPatternWidget(map["_gap"]);
    List<Widget>? children;
    MainAxisAlignment? ma;
    String? txt = map["_text"];
    if (txt != null) {
      children = (gap == null)
          ? [w!, Text(txt, style: map["_textStyle"])]
          : [gap, w!, gap, Text(txt, style: map["_textStyle"])];
      ma = map["_mainAxisAlignment"] ??
          ((gap == null)
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.start);
    }
    return InkWell(
      child: (txt == null)
          ? w!
          : (isHoriz
              ? Row(
                  children: children!,
                  mainAxisAlignment: ma!,
                )
              : Column(
                  children: children!,
                  mainAxisAlignment: ma!,
                )),
      onTap: () => _onTap(context, map),
      highlightColor: map["_highlightColor"],
      hoverColor: map["_hoverColor"],
    );
  }
}

class IconTextPattern extends ProcessPattern {
  IconTextPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return IconTextWidget(map);
  }
}

class VisiblePattern extends ProcessPattern {
  VisiblePattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return Visibility(
      child: getPatternWidget(map["_child"])!,
      visible: map["_visible"],
    );
  }
}

class ObxPattern extends ProcessPattern {
  ObxPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    ProcessPattern child = map["_child"];
    return Obx(() {
      String rxName = map["_valueName"];
      dynamic value = resxController.getRxValue(rxName);
      String key = map["_valueKey"] ??
          ((value is List<dynamic>) ? "_children" : "_child");
      child.map[key] = value;
      return getPatternWidget(child)!;
    });
  }
}

class ObxProcessPattern extends ProcessPattern {
  ObxProcessPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return Obx(() {
      String rxName = map["_processName"];
      ProcessEvent event = resxController.getRxValue(rxName);
      Agent a = model.appActions.getAgent("pattern");

      var p = a.process(event);

      if (p is ProcessPattern) {
        return p.getWidget();
      }
      return p as Widget;
    });
  }
}

class PageViewPattern extends ProcessPattern {
  int index = 0;
  PageViewPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    dynamic ml = map["_children"];
    List<Widget>? lw = (ml is List<Widget>)
        ? ml
        : (ml is List<dynamic>)
            ? getPatternWidgetList(ml)
            : null;
    String pn = map["_pageNoti"];
    return PageView(
      controller: map["_pageController"],
      children: lw!,
      scrollDirection: map["_scrollDirection"] ?? Axis.horizontal,
      onPageChanged: (int inx) {
        if (inx != index) {
          resxController.setRxValue(pn, inx);
          index = inx;
        }
      },
    );
  }
}

class PageBarPattern extends ProcessPattern {
  PageBarPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    PageController pc = map["_pageController"];
    Icon? inxIcon = getPatternWidget(map["_inxIcon"]) as Icon;
    Icon? nonInxIcon = getPatternWidget(map["_nonInxIcon"]) as Icon;
    int tp = map["_totalPages"];
    String pn = map["_pageNoti"];
    List<BottomNavigationBarItem> bil = [];
    for (int i = 0; i < tp; i++) {
      BottomNavigationBarItem bi = BottomNavigationBarItem(
          activeIcon: inxIcon, icon: nonInxIcon, label: "");
      bil.add(bi);
    }
    return Obx(() {
      int inx = resxController.getRxValue(pn);
      return BottomNavigationBar(
        currentIndex: inx,
        items: bil,
        selectedFontSize: 8.0,
        unselectedFontSize: 8.0,
        onTap: (index) {
          pc.animateToPage(index,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
      );
    });
  }
}

class PagingWidget extends StatefulWidget {
  final Map<String, dynamic> map;
  const PagingWidget(this.map, {Key? key}) : super(key: key);

  @override
  _PagingWidgetState createState() => _PagingWidgetState();
}

class _PagingWidgetState extends State<PagingWidget> {
  late Map<String, dynamic> map;
  late Map<String, dynamic> dmap;
  RefreshController rc = RefreshController();
  late List<dynamic> itemRef;
  ScrollController sc = ScrollController();

  @override
  void initState() {
    map = widget.map;
    dmap = map["_dataCache"];
    _nextPage(dmap);
    super.initState();
  }

  @override
  void dispose() {
    rc.dispose();
    sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (map != widget.map) {
      map = widget.map;
      dmap = map["_dataCache"];
      _nextPage(dmap);
    }
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () async {
          int inx = dmap["_pInx"];
          if (inx > 0) {
            setState(() {
              _prevPage(dmap);
              double end = sc.position.maxScrollExtent;
              sc.jumpTo(end);
            });
          }
          rc.refreshCompleted();
        },
        onLoading: () async {
          if (dmap["_dataCompleted"] != true) {
            setState(() {
              _nextPage(dmap);
              sc.jumpTo(0.0);
            });
          }
          rc.loadComplete();
        },
        controller: rc,
        header: CustomHeader(
          builder: (BuildContext context, RefreshStatus? mode) {
            Widget body;
            bool top = dmap["_pInx"] == 0;
            if (mode == RefreshStatus.idle) {
              String text = top ? "Top of data" : "pull down to refresh";
              body = Text(text);
            } else if (mode == RefreshStatus.refreshing) {
              body = const CupertinoActivityIndicator();
            } else if (mode == RefreshStatus.failed) {
              body = const Text("Refresh Failed!Click retry!");
            } else if (mode == RefreshStatus.canRefresh) {
              String text = top ? "Top of data" : "release to refresh";
              body = Text(text);
            } else {
              body = const Text("Top of Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            bool noMore = dmap["_dataCompleted"] ?? false;
            if (mode == LoadStatus.idle) {
              String text = noMore ? "No more data" : "pull up load";
              body = Text(text);
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              String text = noMore ? "No more data" : "release to load more";
              body = Text(text);
            } else {
              body = const Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        child: _getChild(itemRef, sc));
  }

  Widget _getChild(List<dynamic>? itemRef, ScrollController sc) {
    if ((itemRef == null) || (itemRef.isEmpty)) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    bool expandable = map["_expandable"] ?? false;
    if (expandable) {
      return ExpansionPanelList.radio(
        children: _getExpandableChildren(itemRef),
      );
    }
    return ListView.builder(
      controller: sc,
      scrollDirection: map["_direction"] ?? Axis.vertical,
      padding: map["_padding"],
      shrinkWrap: map["_shrinkWrap"] ?? true,
      physics: map["_physics"],
      itemCount: itemRef.length,
      itemBuilder: (context, index) => _itemBuilder(itemRef[index], index),
    );
  }

  List<ExpansionPanelRadio> _getExpandableChildren(List<dynamic> itemRef) {
    return List<ExpansionPanelRadio>.generate(itemRef.length, (index) {
      return ExpansionPanelRadio(
        value: index,
        headerBuilder: (BuildContext context, bool isExpanded) =>
            _itemBuilder(itemRef[index], index),
        body: _expandedItemBuilder(itemRef[index], index),
      );
    });
  }

  Widget _itemBuilder(dynamic item, int index) {
    Map<String, dynamic> lmap = {
      "_item": item,
      "_index": index,
    };
    Function pf = model.appActions.getPattern(map["_childPattern"])!;
    Map<String, dynamic>? cmap = map["_childMap"];
    if (cmap != null) {
      lmap.addAll(cmap);
    }
    ProcessEvent? tevent = map["_onTap"];
    if (tevent != null) {
      lmap["_onTap"] = tevent;
    }
    ProcessPattern p = pf(lmap);

    if (lmap["_onTap"] == null) {
      return p.getWidget();
    }
    lmap["_child"] = p;

    return TapItemPattern(lmap).getWidget();
  }

  Widget _expandedItemBuilder(dynamic item, int index) {
    Map<String, dynamic> lmap = {
      "_item": item,
      "_index": index,
    };
    Function pf = model.appActions.getPattern(map["_expandPattern"])!;
    Map<String, dynamic>? cmap = map["_expandMap"];
    if (cmap != null) {
      lmap.addAll(cmap);
    }
    ProcessPattern p = pf(lmap);
    return p.getWidget();
  }

  _nextPage(Map<String, dynamic> m) {
    bool noMore = m["_dataCompleted"] ?? false;
    if (noMore) {
      return;
    }
    List<dynamic> pList = m["_dataList"];
    int? inx = m["_pInx"];
    int plen = m["_plen"];
    int rlen = m["_nrlen"] ?? 0;
    int len = pList.length - plen;
    if (inx != null) {
      inx += plen - rlen;
      if (inx >= len) {
        inx = len;
      }
      len = plen;
    } else {
      inx = 0;
      len = (pList.length > plen) ? plen : pList.length;
    }
    m["_pInx"] = inx;
    itemRef = [];
    for (int i = 0; i < len; i++) {
      itemRef.add(pList[i + inx]);
    }
    if (pList.length <= (inx + plen)) {
      m["_dataCompleted"] = true;
    }
  }

  _prevPage(Map<String, dynamic> m) {
    List<dynamic> pList = m["_dataList"];
    int? inx = m["_pInx"];
    int plen = m["_plen"];
    int rlen = m["_prlen"] ?? 0;
    rlen = plen - rlen;
    if ((inx == null) || (inx == 0)) {
      return;
    }
    inx = (rlen > inx) ? 0 : (inx - rlen);
    int len = (pList.length > plen) ? plen : pList.length;
    itemRef = [];
    for (int i = 0; i < len; i++) {
      itemRef.add(pList[i + inx]);
    }
    m["_pInx"] = inx;
    if (pList.length > plen) {
      m["_dataCompleted"] = false;
    }
  }
}

class PagingPattern extends ProcessPattern {
  PagingPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return PagingWidget(map);
  }
}

class DropdownButtonWidget extends StatefulWidget {
  final Map<String, dynamic> map;
  const DropdownButtonWidget(this.map, {Key? key}) : super(key: key);

  @override
  _DropdownButtonWidgetState createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  late Map<String, dynamic> map;
  late String type;
  dynamic _value;
  late List<dynamic> _items;
  dynamic _hint;
  dynamic rxName;
  dynamic csName;
  dynamic fsmName;
  dynamic _icon;
  dynamic _iconSize;
  dynamic _style;
  dynamic _inMap;

  @override
  void initState() {
    map = widget.map;
    type = map["_type"] ?? "string";
    _value = map["_value"];
    _items = map["_items"];
    _hint = map["_hint"];
    rxName = map["_rxName"];
    csName = map["_cacheName"];
    fsmName = map["_fsmName"];
    _icon = map["_icon"] ?? const Icon(Icons.arrow_drop_down);
    _iconSize = map["_iconSize"] ?? 24.0;
    _style = map["_textStyle"];
    _inMap = map["_inMap"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (type == "string") {
      return DropdownButton<String>(
        items: _items.map((e) {
          return DropdownMenuItem<String>(value: e, child: Text(e));
        }).toList(),
        value: _value,
        onChanged: (newValue) => _onChange(newValue),
        hint: (_hint != null)
            ? Text(
                _hint,
                style: _style,
              )
            : null,
        style: _style,
        icon: _icon,
        iconSize: _iconSize,
      );
    }
    return DropdownButton<Widget>(
      items: _items.map((e) {
        return DropdownMenuItem<Widget>(
          value: e,
          child: e,
        );
      }).toList(),
      value: _value,
      onChanged: (newValue) => _onChange(newValue),
      hint: (_hint != null)
          ? Text(
              _hint,
              style: _style,
            )
          : null,
      style: _style,
      icon: _icon,
      iconSize: _iconSize,
    );
  }

  _onChange(newValue) {
    setState(() {
      _value = newValue;
    });
    if (csName != null) {
      resxController.setCache(csName, newValue);
    }
    if (rxName != null) {
      resxController.setRxValue(rxName, newValue);
    }
    if (fsmName != null) {
      Map<String, dynamic> m = _inMap ?? {};
      m['_value'] = newValue;
      model.appActions.doFunction("fsmEvent", fsmName, m);
    }
  }
}

class DropdownButtonPattern extends ProcessPattern {
  DropdownButtonPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return DropdownButtonWidget(map);
  }
}

class ProgressText extends StatelessWidget {
  final Map<String, dynamic> map;

  const ProgressText(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic text = map["_text"];
    Widget pind = const Center(
      child: CircularProgressIndicator(),
    );
    Widget w;
    if (text == null) {
      w = pind;
    } else {
      w = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          pind,
          Text(
            text,
            style: map["_textStyle"],
          )
        ],
      );
    }
    return w;
  }
}

class ProgressTextPattern extends ProcessPattern {
  ProgressTextPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return ProgressText(map);
  }
}

class ListTileWidget extends StatelessWidget {
  final Map<String, dynamic> map;

  const ListTileWidget(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? t = getPatternWidget(map["_title"]);
    Widget? l = getPatternWidget(map["_leading"]);
    Widget? s = getPatternWidget(map["_subtitle"]);
    Widget? r = getPatternWidget(map["_trailing"]);
    return ListTile(
      key: map["_key"],
      leading: l,
      title: t,
      subtitle: s,
      trailing: r,
      isThreeLine: map["_isThreeLine"] ?? false,
      shape: map["_shape"],
      selected: map["_selected"] ?? false,
      selectedColor: map["_selectedColor"],
      selectedTileColor: map["_selectedTileColor"],
      iconColor: map["_iconColor"],
      textColor: map["_textColor"],
      tileColor: map["_tileColor"],
      contentPadding: map["_contentPadding"],
      enabled: map["_enabled"] ?? true,
      focusColor: map["_focusColor"],
      hoverColor: map["_hoverColor"],
      autofocus: map["_autofocus"] ?? false,
      onLongPress: map["_onLongPress"],
      onTap: () => _onTap(context, map),
    );
  }
}

class ListTilePattern extends ProcessPattern {
  ListTilePattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return ListTileWidget(map);
  }
}

class TabColumnWidget extends StatefulWidget {
  final Map<String, dynamic> map;
  const TabColumnWidget(this.map, {Key? key}) : super(key: key);

  @override
  _TabColumnWidget createState() => _TabColumnWidget();
}

class _TabColumnWidget extends State<TabColumnWidget>
    with SingleTickerProviderStateMixin {
  late Map<String, dynamic> map;
  late TabController _tc;
  final List<Widget> _tabList = [];
  late List<Widget> _children;

  @override
  void initState() {
    map = widget.map;
    List<dynamic> tabs = map["_tabs"];
    for (dynamic tab in tabs) {
      late Tab t;
      if (tab is String) {
        t = Tab(text: tab);
      } else if (tab is List<dynamic>) {
        int i = (tab[0] is String) ? 0 : 1;
        String s = tab[i];
        i = (i == 0) ? 1 : 0;
        Widget? w = getPatternWidget(tab[i]);
        t = Tab(
          icon: w,
          text: s,
        );
      } else {
        Widget? w = getPatternWidget(tab);
        t = Tab(
          icon: w,
        );
      }
      _tabList.add(t);
    }
    _tc = TabController(length: _tabList.length, vsync: this);
    _children = getPatternWidgetList(map["_children"]);
    super.initState();
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            unselectedLabelColor: colorMap["grey"],
            labelColor: colorMap["btnBlue"],
            tabs: _tabList,
            controller: _tc,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              children: _children,
              controller: _tc,
            ),
          ),
        ],
      ),
    );
  }
}

Size? getSize(GlobalKey? _key) {
  if (_key == null) {
    return null;
  }
  final RenderBox renderBox =
      _key.currentContext?.findRenderObject() as RenderBox;

  return renderBox.size;
}

class TabColumnPattern extends ProcessPattern {
  TabColumnPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return TabColumnWidget(map);
  }
}

class DrawerPattern extends ProcessPattern {
  DrawerPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    Widget? w = getPatternWidget(map["_child"]);
    Color c = Colors.blueGrey;
    return Drawer(
      backgroundColor: map["_backgroundColor"] ?? c,
      width: map["_width"],
      child: w,
    );
  }
}

class FloatingActionPattern extends ProcessPattern {
  FloatingActionPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    dynamic icon = map["_icon"];
    if (icon is String) {
      icon = IconPattern(map).getWidget();
    }
    Widget? w = icon ?? getPatternWidget(map["_child"]);
    dynamic fgColor = map["_fgColor"];
    if (fgColor is String) {
      fgColor = colorMap[fgColor];
    }
    dynamic bgColor = map["_bgColor"];
    if (bgColor is String) {
      bgColor = colorMap[bgColor];
    }
    return FloatingActionButton(
      child: w,
      foregroundColor: fgColor,
      backgroundColor: bgColor,
      onPressed: () => _onTap(model.context, map),
    );
  }
}

class Bubble extends StatelessWidget {
  final Map<String, dynamic> map;

  const Bubble(this.map, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    model.context = context;
    dynamic ml = map["_bubbleBox"];
    dynamic lw = (ml! is List<Widget>)
        ? ml
        : (ml is List<dynamic>)
            ? getPatternWidgetList(ml)
            : getPatternWidget(ml);
    Widget? w = getPatternWidget(map["_bubbleArrow"]);
    return Align(
        alignment: map["_align"],
        child: Material(
            type: MaterialType.transparency,
            child: SizedBox(
                height: map["_bubbleHeight"],
                width: map["_boxWidth"],
                child: Stack(children: [
                  Align(
                    alignment: map["_boxAlign"],
                    child: Container(
                        height: map["_boxHeight"],
                        decoration: map["_boxDecoration"] ?? RCDecoration),
                  ),
                  Align(alignment: map["_arrowAlign"], child: w),
                  Align(
                      alignment: map["_boxAlign"],
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(size10),
                          child: SizedBox(
                            height: map["_boxHeight"],
                            child: (lw is List<Widget>)
                                ? Column(
                                    mainAxisAlignment:
                                        map["_mainAxisAlignment"] ??
                                            MainAxisAlignment.start,
                                    children: lw,
                                  )
                                : lw,
                          )))
                ]))));
  }
}

class SwitchPattern extends ProcessPattern {
  SwitchPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return FlutterSwitch(
        value: map["_onOff"] ?? false,
        onToggle: (value) {
          map["_onOff"] = value;
          _onTap(model.context, map);
        });
  }
}

class BubblePattern extends ProcessPattern {
  BubblePattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    if (map["_widget"] == null) {
      map["_widget"] = Bubble(map);
    }
    return map["_widget"];
  }
}

ProcessPattern getMenuBubble(Map<String, dynamic> map) {
  Map<String, dynamic> imap = {
    "_height": 0.06 * model.scaleHeight,
    "_name": "assets/images/menu_bubble.png",
    "_boxFit": BoxFit.cover,
  };
  Function pf = model.appActions.getPattern("ImageAsset")!;
  ProcessPattern arrow = pf(imap);
  dynamic mBox = map["_menuBox"];
  double boxHeight = map["_boxHeight"] ?? 0.0;
  if ((mBox is! ProcessPattern) && (mBox is! Widget)) {
    List<dynamic> menuBox = mBox ?? [];
    if (menuBox.isNotEmpty) {
      boxHeight = menuBox.length * 30.0 * sizeScale;
    } else {
      imap = {"_width": size20};
      pf = model.appActions.getPattern("SizedBox")!;
      Color c = const Color(0xFF1785C1);
      imap = {
        "_textStyle": mediumNormalTextStyle,
        "_iconSize": size20,
        "_iconColor": c,
        "_highlightColor": c,
        "_hoverColor": c,
        "_gap": pf(imap),
        "_horiz": true,
        "_key": map["_key"],
      };

      pf = model.appActions.getPattern("IconText")!;
      List<dynamic> menuList = map["_menuList"];
      //ProcessEvent pe = ProcessEvent("menu");

      for (String mStr in menuList) {
        ProcessEvent pe = ProcessEvent("fsmEvent");
        List<String> ls = mStr.split(";");
        pe.map = {"_event": ls[0], "_title": ls[1]};
        imap["_icon"] = ls[0];
        imap["_text"] = ls[1];
        imap["_onTap"] = pe;
        //List<dynamic> ld = [ls[1], true];
        imap["_tapAction"] = "menufsm";
        menuBox.add(pf(imap));
        boxHeight += 30.0 * sizeScale;
      }
      mBox = menuBox;
    }
  }
  double boxWidth = map["_boxWidth"] ?? 0.50 * model.scaleWidth;
  double ax = 1.0 - (41.1 / model.screenWidth);
  imap = {
    "_align": Alignment(ax, -0.85),
    "_bubbleArrow": arrow,
    "_bubbleBox": mBox,
    "_bubbleHeight": 0.23399 * model.scaleHeight,
    "_arrowAlign": const Alignment(0.9, -0.95),
    "_boxAlign": Alignment.centerRight,
    "_boxWidth": boxWidth,
    "_mainAxisAlignment": MainAxisAlignment.spaceEvenly,
    "_boxHeight": boxHeight,
  };
  pf = model.appActions.getPattern("Bubble")!;
  return pf(imap);
}

class TextIconRow extends StatelessWidget {
  final Map<String, dynamic> map;

  const TextIconRow(this.map, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic icon = map["_icon"];
    if ((icon != null) && (icon is! Widget)) {
      icon = IconPattern(map).getWidget();
    }
    bool fitted = map["_fitted"] ?? false;
    bool split = map["_split"] ?? false;
    bool iconFirst = map["_iconFirst"] ?? false;
    late Widget g;
    if (split) {
      Widget t = Expanded(
          child: (fitted)
              ? FittedBox(
                  child: Text(map["_text"], style: map["_textStyle"]),
                )
              : Text(map["_text"], style: map["_textStyle"]));
      Widget? ic = (icon != null)
          ? GestureDetector(
              onTap: () => _onTap(context, map),
              child: icon,
            )
          : null;
      g = Row(
        children: (iconFirst) ? [ic!, t] : ((ic == null) ? [t] : [t, ic]),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      );
    } else {
      g = GestureDetector(
          onTap: () => _onTap(context, map),
          child: RichText(
            text: (!iconFirst)
                ? TextSpan(
                    text: map["_text"] + "    ",
                    style: map["_textStyle"],
                    children: (icon != null)
                        ? [
                            WidgetSpan(
                                child: icon,
                                alignment: PlaceholderAlignment.middle),
                          ]
                        : null,
                  )
                : TextSpan(
                    children: [
                      WidgetSpan(
                          child: icon, alignment: PlaceholderAlignment.middle),
                      TextSpan(
                        text: "    " + map["_text"],
                        style: map["_textStyle"],
                      )
                    ],
                  ),
          ));
      if (fitted) {
        g = FittedBox(
          child: g,
        );
      }
    }
    return g;
  }
}

class TextIconRowPattern extends ProcessPattern {
  TextIconRowPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return TextIconRow(map);
  }
}

class TextIconListPattern extends ProcessPattern {
  List<Widget> children = [];

  TextIconListPattern(Map<String, dynamic> map) : super(map);

  setChildren() {
    dynamic item = map["_item"];
    Map<String, dynamic> entity = model.map["entity"];
    String header = entity["header"];
    var ent = map["_entity"];
    Map<String, dynamic> me = {};
    if (ent is List<dynamic>) {
      for (String e in ent) {
        getAttrMap(e, me, entity);
      }
    } else {
      getAttrMap(ent, me, entity);
    }
    List<dynamic> aList = map["_attrList"];
    Widget div = const Divider(
      thickness: 1.5,
    );
    int d = 0;
    int ta = 0;
    for (var a in aList) {
      if (a == "div") {
        if (d > 0) {
          children.add(div);
          d = 0;
        }
      } else {
        Map<String, dynamic>? ma = (a is Map<String, dynamic>) ? a : null;
        String? name = (ma != null) ? ma["_attr"] : a;
        String? attr;
        dynamic data;
        if (name != null) {
          attr = me[name];
          data = _getItemData(name, item);
        }
        if (((attr != null) && (data != null)) ||
            ((ma != null) && (attr == null))) {
          d++;
          ta++;
          Map<String, dynamic> m = (attr != null)
              ? model.appActions.doFunction("patMap", [header, attr], null)
              : {};
          m.addAll(map);
          if (ma != null) {
            m.addAll(ma);
          }
          if (data != null) {
            m["_text"] = (m["_prefix"] != null)
                ? m["_prefix"] + data.toString()
                : data.toString();
          }
          children.add(TextIconRow(m));
        }
      }
    }
    Map<String, dynamic>? rinfo = map["_rinfo"];
    if (rinfo != null) {
      rinfo["_total"] = ta;
    }
  }

  @override
  Widget getWidget({String? name}) {
    return Column(
      children: children,
    );
  }

  dynamic _getItemData(String name, dynamic item) {
    if (item is Map<String, dynamic>) {
      return item[name];
    }
    if (item is List<dynamic>) {
      for (Map<String, dynamic> it in item) {
        dynamic data = it[name];
        if (data != null) {
          return data;
        }
      }
    }
    return null;
  }
}

getAttrMap(String name, Map<String, dynamic> me, Map<String, dynamic> entity) {
  Map<String, dynamic> attr = entity[name];
  attr.forEach((key, value) {
    if (key[0] == '_') {
      String k = key.substring(1);
      getAttrMap(k, me, entity);
    } else {
      me[key] = value;
    }
  });
}
