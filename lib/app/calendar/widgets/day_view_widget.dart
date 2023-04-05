import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../../../model/main_model.dart';

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
