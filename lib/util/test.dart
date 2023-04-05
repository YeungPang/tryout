import 'package:tryout/model/locator.dart';
import 'package:calendar_view/calendar_view.dart';
import '../model/main_model.dart';

dynamic getTest(Map<String, dynamic> map) {
  String test = map["_test"];
  switch (test) {
    case "calendarEvent":
      model.eventController.addAll(_events);
      return true;
    case "multiLines":
      return multiLines;
    case "toDoList":
      return toDoList;
    case "load":
      int i = map["_pageId"];
      switch (i) {
        case -1:
          return guestData;
        default:
          return quiltedImages;
      }
    default:
      break;
  }
  return null;
}

DateTime get _now => DateTime.now();

List<CalendarEventData<Event>> _events = [
  CalendarEventData(
    date: _now,
    event: const Event(title: "Joe's Birthday"),
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 22),
  ),
  CalendarEventData(
    date: _now.add(const Duration(days: 1)),
    startTime: DateTime(_now.year, _now.month, _now.day, 18),
    endTime: DateTime(_now.year, _now.month, _now.day, 19),
    event: const Event(title: "Wedding anniversary"),
    title: "Wedding anniversary",
    description: "Attend uncle's wedding anniversary.",
  ),
  CalendarEventData(
    date: _now,
    startTime: DateTime(_now.year, _now.month, _now.day, 14),
    endTime: DateTime(_now.year, _now.month, _now.day, 17),
    event: const Event(title: "Football Tournhment"),
    title: "Football Tournhment",
    description: "Go to football tournhment.",
  ),
  CalendarEventData(
    date: _now.add(const Duration(days: 3)),
    startTime: DateTime(
        _now.add(const Duration(days: 3)).year,
        _now.add(const Duration(days: 3)).month,
        _now.add(const Duration(days: 3)).day,
        10),
    endTime: DateTime(
        _now.add(const Duration(days: 3)).year,
        _now.add(const Duration(days: 3)).month,
        _now.add(const Duration(days: 3)).day,
        14),
    event: const Event(title: "Sprint Meeting."),
    title: "Sprint Meeting.",
    description: "Last day of project submission for last year.",
  ),
  CalendarEventData(
    date: _now.subtract(const Duration(days: 2)),
    startTime: DateTime(
        _now.subtract(const Duration(days: 2)).year,
        _now.subtract(const Duration(days: 2)).month,
        _now.subtract(const Duration(days: 2)).day,
        14),
    endTime: DateTime(
        _now.subtract(const Duration(days: 2)).year,
        _now.subtract(const Duration(days: 2)).month,
        _now.subtract(const Duration(days: 2)).day,
        16),
    event: const Event(title: "Team Meeting"),
    title: "Team Meeting",
    description: "Team Meeting",
  ),
  CalendarEventData(
    date: _now.subtract(const Duration(days: 2)),
    startTime: DateTime(
        _now.subtract(const Duration(days: 2)).year,
        _now.subtract(const Duration(days: 2)).month,
        _now.subtract(const Duration(days: 2)).day,
        10),
    endTime: DateTime(
        _now.subtract(const Duration(days: 2)).year,
        _now.subtract(const Duration(days: 2)).month,
        _now.subtract(const Duration(days: 2)).day,
        12),
    event: const Event(title: "Chemistry Viva"),
    title: "Chemistry Viva",
    description: "Today is Joe's birthday.",
  ),
];

List<Map<String, dynamic>> toDoList = [
  {
    "_title": "First",
    "_content": "There is a lot to do.\nFirst thing first",
    "_level": "high"
  },
  {
    "_title": "Second",
    "_content": "There is a lot to do.\nSecond to do",
    "_level": "medium"
  },
  {
    "_title": "Third",
    "_content":
        "There is a lot to do. We make this a very long sentence that it cannot be put in one line.",
    "_level": "low"
  },
  {
    "_title": "Forth",
    "_content": "There is a lot to do.\nForth to do",
    "_level": "low"
  },
];

List<dynamic> guestData = [
  {
    "title": "新郎 新娘",
    "cf_members": ["苑蔚", "祟謙"],
    "cf_cashCoupon": '0',
    "cf_gift": '0',
    "cf_attend": '0',
    "cf_table": "男主家席"
  },
  {
    "title": "Damian's family",
    "cf_members": ["Damian", "Tiff", "Kayla", "Jamie"],
    "cf_cashCoupon": '0',
    "cf_gift": '0',
    "cf_attend": '0',
    "cf_table": "女家親人席 (1)"
  },
  {
    "title": "源哥家人",
    "cf_members": ["源哥", "三家姐"],
    "cf_cashCoupon": '0',
    "cf_gift": '0',
    "cf_attend": '0',
    "cf_table": "女家親人席 (2)"
  },
  {
    "title": "細舅父",
    "cf_members": ["重揚"],
    "cf_cashCoupon": '0',
    "cf_gift": '0',
    "cf_attend": '0',
    "cf_table": "女主家席"
  }
];

final List<dynamic> quiltedImages = [
  {"title": "1", "image": "https://picsum.photos/250?image=1"},
  {"title": "2", "image": "https://picsum.photos/250?image=2"},
  {"title": "3", "image": "https://picsum.photos/250?image=3"},
  {"title": "4", "image": "https://picsum.photos/250?image=4"},
  {"title": "5", "image": "https://picsum.photos/250?image=5"},
  {"title": "6", "image": "https://picsum.photos/250?image=6"},
  {"title": "7", "image": "https://picsum.photos/250?image=7"},
  {"title": "8", "image": "https://picsum.photos/250?image=8"},
  {"title": "9", "image": "https://picsum.photos/250?image=9"},
  {"title": "10", "image": "https://picsum.photos/250?image=10"},
  {"title": "11", "image": "https://picsum.photos/250?image=11"},
  {"title": "12", "image": "https://picsum.photos/250?image=12"},
  {"title": "13", "image": "https://picsum.photos/250?image=13"},
  {"title": "14", "image": "https://picsum.photos/250?image=14"},
  {"title": "15", "image": "https://picsum.photos/250?image=15"},
  {"title": "16", "image": "https://picsum.photos/250?image=16"},
  {"title": "17", "image": "https://picsum.photos/250?image=17"},
  {"title": "18", "image": "https://picsum.photos/250?image=18"},
  {"title": "19", "image": "https://picsum.photos/250?image=19"},
  {"title": "20", "image": "https://picsum.photos/250?image=20"},
];

String multiLines =
    "a\nb\nc\nd\ne\nf\ng\nh\ni\nj\nk\nl\nm\nn\no\np\nq\nr\ns\nt\nu\nv\nw\nx\ny\nz\n1\n2\n3\n4\n5\n6\n7\n8\n9\n10";
