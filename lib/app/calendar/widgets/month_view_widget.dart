import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../../../model/main_model.dart';

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
