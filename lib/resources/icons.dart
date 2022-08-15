import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../builder/pattern.dart';
import '../model/locator.dart';
import './basic_resources.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SGIcons {
  SGIcons._();

  static const _kFontFam = 'SGIcons2';
  static const _kFontPkg = null;

  static const IconData almost =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData answer =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData article =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData back =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bookmark =
      IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData camera =
      IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cancel =
      IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData challenge =
      IconData(0xe807, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData clap =
      IconData(0xe808, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData complete =
      IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData correct_1 =
      IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData correct =
      IconData(0xe80b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData delete =
      IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData friends =
      IconData(0xe80d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData help =
      IconData(0xe80e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData hint =
      IconData(0xe80f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData home =
      IconData(0xe810, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData home_menu_ =
      IconData(0xe811, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData incomplete =
      IconData(0xe812, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData incorrect =
      IconData(0xe813, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lifelost =
      IconData(0xe814, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lives =
      IconData(0xe815, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData menu_hamburger =
      IconData(0xe816, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData next =
      IconData(0xe817, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData notification =
      IconData(0xe818, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData plus =
      IconData(0xe819, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData progress =
      IconData(0xe81a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData progress_menu_ =
      IconData(0xe81b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData rate =
      IconData(0xe81c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData recent =
      IconData(0xe81d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData response =
      IconData(0xe81e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData search =
      IconData(0xe81f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData settings =
      IconData(0xe820, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData share =
      IconData(0xe821, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shop =
      IconData(0xe822, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData thumbsup =
      IconData(0xe823, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData unread =
      IconData(0xe824, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData upload =
      IconData(0xe825, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData wrong =
      IconData(0xe826, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData toggle_off =
      IconData(0xe827, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData toggle_on =
      IconData(0xe828, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData hint_bubble_arrow =
      IconData(0xe829, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData quit_bubble_arrow =
      IconData(0xe82a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

class IconPattern extends ProcessPattern {
  IconPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    String iname = map["_icon"]!;
    IconData? id = myIcons[iname];
    double size = map["_iconSize"] ?? 24.0;
    size *= model.sizeScale;
    var c = map["_iconColor"] ?? const Color(0xFF00344F);
    if (c is String) {
      c = colorMap[c];
    }
    Color color = c;
    if (map["_widget"] == null) {
      if (id != null) {
        map["_widget"] = Icon(id, size: size, color: color);
      } else {
        String img = imgIcons[iname] ?? iname;
        if (img.contains("http")) {
          map["_widget"] = ImageIcon(
            CachedNetworkImageProvider(img),
            color: color,
            size: size * 2.0,
          );
        } else {
          map["_widget"] = ImageIcon(
            AssetImage(img),
            color: color,
            size: size * 2.0,
          );
        }
      }
    }
    return map["_widget"];
  }
}

const Map<String, IconData> myIcons = {
  "add": Icons.add,
  "abort": Icons.cancel_presentation,
  "almost": SGIcons.almost,
  "answer": SGIcons.answer,
  "arrowBack": Icons.arrow_back,
  "arrowDown": Icons.arrow_downward,
  "article": SGIcons.article,
  "back": SGIcons.back,
  "bookmark": SGIcons.bookmark,
  "calendar": Icons.calendar_month,
  "cached": Icons.cached,
  "camera": SGIcons.camera,
  "cancel": SGIcons.cancel,
  "challenge": SGIcons.challenge,
  "chat": Icons.chat,
  "clap": SGIcons.clap,
  "complete": SGIcons.complete,
  "correct": SGIcons.correct,
  "correct_1": SGIcons.correct_1,
  "edit": Icons.edit,
  "delete": SGIcons.delete,
  "filter": Icons.filter_alt_outlined,
  "friends": SGIcons.friends,
  "help": SGIcons.help,
  "hint": SGIcons.hint,
  "hint_bubble_arrow": SGIcons.hint_bubble_arrow,
  "home": SGIcons.home,
  "home_menu_": SGIcons.home_menu_,
  "incomplete": SGIcons.incomplete,
  "incorrect": SGIcons.incorrect,
  "lifelost": SGIcons.lifelost,
  "list": Icons.list,
  "lives": SGIcons.lives,
  "map": Icons.location_pin,
  "menu": Icons.menu,
  "menu_hamburger": SGIcons.menu_hamburger,
  "next": SGIcons.next,
  "notification": SGIcons.notification,
  "pickTime": Icons.av_timer,
  "plus": SGIcons.plus,
  "phone": Icons.phone,
  "progress": SGIcons.progress,
  "progress_menu_": SGIcons.progress_menu_,
  "properties": Icons.perm_media,
  "questions": Icons.question_answer,
  "quit_bubble_arrow": SGIcons.quit_bubble_arrow,
  "rate": SGIcons.rate,
  "recent": SGIcons.recent,
  "required": FontAwesomeIcons.starOfLife,
  "response": SGIcons.response,
  "rightArrowFull": Icons.arrow_right_outlined,
  "save": Icons.save,
  "start": Icons.start,
  "schedule": Icons.schedule,
  "search": SGIcons.search,
  "settings": SGIcons.settings,
  "share": SGIcons.share,
  "shop": SGIcons.shop,
  "sortDown": FontAwesomeIcons.arrowDownAZ,
  "sortUp": FontAwesomeIcons.arrowUpZA,
  "stop": Icons.stop,
  "thumbsup": SGIcons.thumbsup,
  "timer": Icons.timer,
  "toggle_off": SGIcons.toggle_off,
  "toggle_on": SGIcons.toggle_on,
  "unread": SGIcons.unread,
  "upload": SGIcons.upload,
  "website": Icons.language,
  "wrong": SGIcons.wrong,
};

const Map<String, String> imgIcons = {
  "customer": "assets/images/contact_mail_black.png",
  "contact": "assets/images/contacts_black.png",
  "xeminologo": "assets/images/xeminologo.png",
};
