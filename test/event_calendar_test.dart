import 'package:flutter_test/flutter_test.dart';

import 'package:event_calendar/event_calendar.dart';

void main() {
  test('Check single event ocurrence', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1588084707000), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1588084600000), DateTime.fromMillisecondsSinceEpoch(1588084806000)),
        [Event( DateTime.fromMillisecondsSinceEpoch(1588084707000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588084707000), title: "Thing 1", id: "1")]);
  });

  test('Check multiple event ocurrence', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1588084707000), title: "Thing 1", id: "1")]);
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1588084708000), title: "Thing 1", id: "2")]);
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1588084709000), title: "Thing 1", id: "3")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1588084600), DateTime.fromMillisecondsSinceEpoch(1588084710000)),
        [ Event(DateTime.fromMillisecondsSinceEpoch(1588084600000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588084707000), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588084707000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588084708000), title: "Thing 1", id: "2"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588084709000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588084709000), title: "Thing 1", id: "3")]);
  });

  test('Check recurring infinite event hourly', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1588084707000),recurrenceRule: RecurrenceRule(Frequency.hourly, count: -1), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1588084600000), DateTime.fromMillisecondsSinceEpoch(1588095507000)),
        [ Event(DateTime.fromMillisecondsSinceEpoch(1588084707000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588084707000),recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588084707000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588088307000),recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588084707000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588091907000),recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588084707000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588095507000),recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
        ]);
  });

  test('Check recurring event hourly', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1588078800000),recurrenceRule: RecurrenceRule(Frequency.hourly, count: 19), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1588122000000), DateTime.fromMillisecondsSinceEpoch(1588208400000)),
        [ Event(DateTime.fromMillisecondsSinceEpoch(1588078800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588122000000), recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588078800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588125600000), recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588078800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588129200000), recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588078800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588132800000), recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588078800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588136400000), recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588078800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588140000000), recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588078800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588143600000), recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
        ]);
  });

  test('Check recurring event every 2 hours', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1588078800000),recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3, interval: 2), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1588078800000), DateTime.fromMillisecondsSinceEpoch(1588093200001)),
        [ Event(DateTime.fromMillisecondsSinceEpoch(1588078800000),currentDate: DateTime.fromMillisecondsSinceEpoch(1588078800000), recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588078800000),currentDate: DateTime.fromMillisecondsSinceEpoch(1588086000000), recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588078800000),currentDate: DateTime.fromMillisecondsSinceEpoch(1588093200000), recurrenceRule: RecurrenceRule(Frequency.hourly, count: 3), title: "Thing 1", id: "1"),
        ]);
  });

  test('Check recurring event daily', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1588063107000),recurrenceRule: RecurrenceRule(Frequency.daily,interval: 1, count: 6), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1588063107000), DateTime.fromMillisecondsSinceEpoch(1588581507001)),
        [
          Event(DateTime.fromMillisecondsSinceEpoch(1588063107000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588063107000), recurrenceRule: RecurrenceRule(Frequency.daily, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588063107000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588149507000), recurrenceRule: RecurrenceRule(Frequency.daily, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588063107000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588235907000), recurrenceRule: RecurrenceRule(Frequency.daily, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588063107000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588322307000), recurrenceRule: RecurrenceRule(Frequency.daily, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588063107000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588408707000), recurrenceRule: RecurrenceRule(Frequency.daily, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588063107000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588495107000), recurrenceRule: RecurrenceRule(Frequency.daily, count: -1), title: "Thing 1", id: "1"),

        ]);
  });

  test('Check recurring ifinite event daily', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1588063107000),recurrenceRule: RecurrenceRule(Frequency.daily,interval: 1, count: -1), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1588235907000), DateTime.fromMillisecondsSinceEpoch(1588408707001)),
        [ Event(DateTime.fromMillisecondsSinceEpoch(1588063107000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588235907000),recurrenceRule: RecurrenceRule(Frequency.daily, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588063107000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588322307000),recurrenceRule: RecurrenceRule(Frequency.daily, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588063107000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588408707000),recurrenceRule: RecurrenceRule(Frequency.daily, count: -1), title: "Thing 1", id: "1"),
        ]);
  });

  test('Check recurring weekly events (monday, tuesday, wednesday, thursday, friday)', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1590418800000),recurrenceRule: RecurrenceRule(Frequency.weekly, byDay: [DayOfTheWeek.Monday, DayOfTheWeek.Tuesday, DayOfTheWeek.Wednesday, DayOfTheWeek.Thursday, DayOfTheWeek.Friday],interval: 1, count: 10), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1590418800000), DateTime.fromMillisecondsSinceEpoch(1591369200001)),
        [
          Event(DateTime.fromMillisecondsSinceEpoch(1590418800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1590418800000), recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590418800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1590505200000), recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590418800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1590591600000), recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590418800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1590678000000), recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590418800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1590764400000), recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590418800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1591023600000), recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590418800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1591110000000), recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590418800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1591196400000), recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590418800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1591282800000), recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590418800000), currentDate: DateTime.fromMillisecondsSinceEpoch(1591369200000), recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
        ]);
  });

  test('Check recurring ifinite weekly events ( wednesday, friday, sunday)', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1588579200000),recurrenceRule: RecurrenceRule(Frequency.weekly, byDay: [DayOfTheWeek.Sunday,  DayOfTheWeek.Wednesday, DayOfTheWeek.Friday],interval: 1, count: -1), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1589097600000), DateTime.fromMillisecondsSinceEpoch(1589702400001)),
        [ Event(DateTime.fromMillisecondsSinceEpoch(1588579200000), currentDate: DateTime.fromMillisecondsSinceEpoch(1589097600000),recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588579200000), currentDate: DateTime.fromMillisecondsSinceEpoch(1589356800000),recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588579200000), currentDate: DateTime.fromMillisecondsSinceEpoch(1589529600000),recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588579200000), currentDate: DateTime.fromMillisecondsSinceEpoch(1589702400000),recurrenceRule: RecurrenceRule(Frequency.weekly, count: -1), title: "Thing 1", id: "1"),
        ]);
  });

  test('Check recurring monthly (1st day)', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1588320000000),recurrenceRule: RecurrenceRule(Frequency.monthly, interval: 1, count: 3), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1588310000000), DateTime.fromMillisecondsSinceEpoch(1593590400001)),
        [ Event(DateTime.fromMillisecondsSinceEpoch(1588320000000), currentDate: DateTime.fromMillisecondsSinceEpoch(1588320000000), recurrenceRule: RecurrenceRule(Frequency.monthly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588320000000), currentDate: DateTime.fromMillisecondsSinceEpoch(1590998400000), recurrenceRule: RecurrenceRule(Frequency.monthly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1588320000000), currentDate: DateTime.fromMillisecondsSinceEpoch(1593590400000), recurrenceRule: RecurrenceRule(Frequency.monthly, count: -1), title: "Thing 1", id: "1"),
        ]);
  });

  test('Check recurring monthly (31st day)', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1590912000000),recurrenceRule: RecurrenceRule(Frequency.monthly, interval: 1, count: 4), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1596182400000), DateTime.fromMillisecondsSinceEpoch(1604131200001)),
        [
          Event(DateTime.fromMillisecondsSinceEpoch(1590912000000), currentDate: DateTime.fromMillisecondsSinceEpoch(1596182400000),recurrenceRule: RecurrenceRule(Frequency.monthly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590912000000), currentDate: DateTime.fromMillisecondsSinceEpoch(1598860800000),recurrenceRule: RecurrenceRule(Frequency.monthly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590912000000), currentDate: DateTime.fromMillisecondsSinceEpoch(1604131200000),recurrenceRule: RecurrenceRule(Frequency.monthly, count: -1), title: "Thing 1", id: "1"),

        ]);
  });

  test('Check recurring monthly (last day)', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1590955200000),recurrenceRule: RecurrenceRule(Frequency.monthly, interval: 1, count: 4, isLastDayOfMonth: true), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1588310000000), DateTime.fromMillisecondsSinceEpoch(1601539200001)),
        [
          Event(DateTime.fromMillisecondsSinceEpoch(1590955200000), currentDate: DateTime.fromMillisecondsSinceEpoch(1590955200000),recurrenceRule: RecurrenceRule(Frequency.monthly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590955200000), currentDate: DateTime.fromMillisecondsSinceEpoch(1593547200000),recurrenceRule: RecurrenceRule(Frequency.monthly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590955200000), currentDate: DateTime.fromMillisecondsSinceEpoch(1596225600000),recurrenceRule: RecurrenceRule(Frequency.monthly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590955200000), currentDate: DateTime.fromMillisecondsSinceEpoch(1598904000000),recurrenceRule: RecurrenceRule(Frequency.monthly, count: -1), title: "Thing 1", id: "1"),
        ]);
  });

  test('Check recurring Yearly', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event(DateTime.fromMillisecondsSinceEpoch(1590566400000),recurrenceRule: RecurrenceRule(Frequency.yearly, interval: 2, count: 3), title: "Thing 1", id: "1")]);
    expect(
        calendar.getEvents(
            DateTime.fromMillisecondsSinceEpoch(1590566400000), DateTime.fromMillisecondsSinceEpoch(1716796700000)),
        [

          Event(DateTime.fromMillisecondsSinceEpoch(1590566400000), currentDate: DateTime.fromMillisecondsSinceEpoch(1590566400000),recurrenceRule: RecurrenceRule(Frequency.yearly, count: -1), title: "Thing 1", id: "1"),
          Event(DateTime.fromMillisecondsSinceEpoch(1590566400000), currentDate: DateTime.fromMillisecondsSinceEpoch(1653638400000),recurrenceRule: RecurrenceRule(Frequency.yearly, count: -1), title: "Thing 1", id: "1"),
        ]);
  });

  test('Check next event', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([
      Event(DateTime.fromMillisecondsSinceEpoch(1588063107000),
          recurrenceRule: RecurrenceRule(Frequency.daily, interval: 2, count: 3), title: "Thing 1", id: "1"),
      Event(DateTime.fromMillisecondsSinceEpoch(1588063107000),
          recurrenceRule: RecurrenceRule(Frequency.daily, interval: 2, count: 3), title: "Thing 2", id: "2"),
      Event(DateTime.fromMillisecondsSinceEpoch(1588063207000),
          recurrenceRule: RecurrenceRule(Frequency.yearly, interval: 2, count: 3), title: "Thing 3", id: "3"),
      Event(DateTime.fromMillisecondsSinceEpoch(1588063207000), title: "moo 3", id: "5"),
      Event(DateTime.fromMillisecondsSinceEpoch(1590418800000),
          recurrenceRule: RecurrenceRule(Frequency.weekly,
              byDay: [
                DayOfTheWeek.Monday,
                DayOfTheWeek.Tuesday,
                DayOfTheWeek.Wednesday,
                DayOfTheWeek.Thursday,
                DayOfTheWeek.Friday
              ],
              interval: 1,
              count: 1),
          title: "Thing 4",
          id: "4")
    ]);

//    Event event = calendar.getNextEvent(startAfter: DateTime.fromMillisecondsSinceEpoch(1588070307000));
//    while(event != null){
//      print(event.toJson());
//      event = calendar.getNextEvent(event: event);
//    }

    expect(
      calendar.getNextEvent(
          event: Event(DateTime.fromMillisecondsSinceEpoch(1588063107000),
              recurrenceRule: RecurrenceRule(Frequency.daily, interval: 2, count: -1), title: "Thing 1", id: "1")),
        Event(DateTime.fromMillisecondsSinceEpoch(1588063107000),
            recurrenceRule: RecurrenceRule(Frequency.daily, interval: 2, count: 2), title: "Thing 2", id: "2"),
    );
    expect(
      calendar.getNextEvent(
          event: Event(DateTime.fromMillisecondsSinceEpoch(1590418800000),
              currentDate: DateTime.fromMillisecondsSinceEpoch(1588235907000),
              recurrenceRule: RecurrenceRule(Frequency.daily, interval: 2, count: 2),
              title: "Thing 3",
              id: "3")),
      Event(DateTime.fromMillisecondsSinceEpoch(1590418800000),
          recurrenceRule: RecurrenceRule(Frequency.weekly,
              byDay: [
                DayOfTheWeek.Monday,
                DayOfTheWeek.Tuesday,
                DayOfTheWeek.Wednesday,
                DayOfTheWeek.Thursday,
                DayOfTheWeek.Friday
              ],
              interval: 1,
              count: 10),
          title: "Thing 4",
          id: "4"),
    );
  });

  test('Check Json', () {
    final calendar = Calendar(id: "calendarId", title: "My Calendar");
    calendar.addEvents([Event.fromJson(Event(DateTime.fromMillisecondsSinceEpoch(1588063107000), title: "Thing 1", id: "1").toJson()),
      Event.fromJson(Event(DateTime.fromMillisecondsSinceEpoch(1590418800000),recurrenceRule: RecurrenceRule(Frequency.weekly, byDay: [DayOfTheWeek.Monday, DayOfTheWeek.Tuesday, DayOfTheWeek.Wednesday, DayOfTheWeek.Thursday, DayOfTheWeek.Friday],interval: 1, count: 10), title: "Thing 1", id: "1").toJson())]);
    expect(
        calendar.getNextEvent(startAfter: DateTime.fromMillisecondsSinceEpoch(1588063106000)),
         Event(DateTime.fromMillisecondsSinceEpoch(1588063107000), title: "Thing 1", id: "1"),
        );
    expect(
      calendar.getNextEvent( startAfter: DateTime.fromMillisecondsSinceEpoch(1588063107000)),
      Event(DateTime.fromMillisecondsSinceEpoch(1590418800000),recurrenceRule: RecurrenceRule(Frequency.weekly, byDay: [DayOfTheWeek.Monday, DayOfTheWeek.Tuesday, DayOfTheWeek.Wednesday, DayOfTheWeek.Thursday, DayOfTheWeek.Friday],interval: 1, count: 10), title: "Thing 1", id: "1"),
    );
  });
}
