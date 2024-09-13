import 'package:flutter/material.dart';
import 'package:soul_connection/models/event.module.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class CalandarPage extends StatefulWidget {
  const CalandarPage({super.key, required this.callbackEvent});
  final Function(EventModel) callbackEvent;

  @override
  State<CalandarPage> createState() => _CalandarPageState();
}

Color getRandomColor() {
  final random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

Map<DateTime, List<Event>> loadDynamicEvents() {
  Map<DateTime, List<Event>> events = {};
  for (var eventData in allEvents) {
    DateTime eventDate = DateFormat('dd-MM-yyyy').parse(eventData.date);

    Event singleEvent = Event(
      eventData.name,
      getRandomColor(),
      eventData.id.toString(),
    );
    events[eventDate] = [singleEvent];
    events[eventDate] = [singleEvent];
  }
  return events;
}

class _CalandarPageState extends State<CalandarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Event>> _events = loadDynamicEvents();

  List<Event> _getEventsForDay(DateTime day) {
    DateTime key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  EventModel? currentEvent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Event>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          eventLoader: (day) => _getEventsForDay(day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          daysOfWeekHeight: 30,
          daysOfWeekStyle: const DaysOfWeekStyle(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            weekdayStyle: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          calendarStyle: CalendarStyle(
            markersMaxCount: 3,
            cellMargin: const EdgeInsets.all(2),
            defaultTextStyle: const TextStyle(fontSize: 14),
            outsideTextStyle: const TextStyle(color: Colors.grey),
            weekendTextStyle: const TextStyle(color: Colors.black),
            todayTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.6),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            isTodayHighlighted: true,
            outsideDecoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
            ),
            defaultDecoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              return _buildDay(day);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDay(DateTime day) {
    final events = _getEventsForDay(day);

    return Container(
      width: 200,
      height: 85,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.day.toString(),
            style: const TextStyle(fontSize: 12),
          ),
          ...events.map((event) => _buildEventMarker(event)),
        ],
      ),
    );
  }

  Widget _buildEventMarker(Event event) {
    return GestureDetector(
      onTap: () {
        for (var element in allEvents) {
          if (element.id.toString() == event.id) {
            widget.callbackEvent(allEvents[allEvents.indexOf(element)]);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 2),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: event.color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.circle, size: 8, color: Colors.white),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                event.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String title;
  final String id;
  final Color color;

  Event(this.title, this.color, this.id);
}
