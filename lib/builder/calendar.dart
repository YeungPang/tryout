import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:tryout/app/calendar/pages/day_view_page.dart';
import 'package:tryout/app/calendar/pages/month_view_page.dart';
import 'package:tryout/app/calendar/pages/week_view_page.dart';
import './pattern.dart';
import 'package:tryout/app/calendar/extension.dart';
import '../../model/main_model.dart';

class CalendarWidget extends StatelessWidget {
  final Map<String, dynamic> map;

  const CalendarWidget(this.map, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => context.pushRoute(const MonthViewPageDemo()),
            child: const Text("Month View"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => context.pushRoute(const DayViewPageDemo()),
            child: const Text("Day View"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => context.pushRoute(const WeekViewDemo()),
            child: const Text("Week View"),
          ),
        ],
      ),
    );
  }
}

class MonthViewWidget extends StatelessWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;

  const MonthViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MonthView<Event>(
      key: state,
      width: width,
      onCellTap: (events, date) {
        debugPrint("date" + date.toString() + "events: " + events.toString());
      },
      onEventTap: (event, date) {
        debugPrint("date" + date.toString() + "events: " + event.toString());
      },
    );
  }
}

class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;

  const WeekViewWidget({Key? key, this.state, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeekView<Event>(
      key: state,
      width: width,
      onEventTap: (events, date) {
        debugPrint("date" + date.toString() + "events: " + events.toString());
      },
      onDateTap: (date) {
        debugPrint("date" + date.toString());
      },
    );
  }
}

class DayViewWidget extends StatelessWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const DayViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DayView<Event>(
      key: state,
      width: width,
      onDateTap: (date) {
        debugPrint("date" + date.toString());
      },
      onEventTap: (events, date) {
        debugPrint("date" + date.toString() + "events: " + events.toString());
      },
    );
  }
}

class CalendarPattern extends ProcessPattern {
  CalendarPattern(Map<String, dynamic> map) : super(map);
  @override
  Widget getWidget({String? name}) {
    return CalendarWidget(map);
  }
}
