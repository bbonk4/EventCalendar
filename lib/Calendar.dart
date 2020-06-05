import 'package:event_calendar/Calendar_Enums.dart';
import 'package:event_calendar/Event.dart';
import 'package:event_calendar/Result.dart';

class Calendar {
  String title;
  String id;
  List<Event> events;

  Calendar({this.title, this.id, this.events}) {
    if (events == null) {
      events = new List();
    }
  }

  operator ==(other) => id == other.id;
  int get hashCode => (super.hashCode);

  List<Event> getEvents(DateTime start, DateTime end, {convertToLocal = true}) {
    List<Event> tempEvents = List();

    if (events.length == 0) {
      return tempEvents;
    }

    for (int i = 0; i < events.length; i++) {
      Event event = events[i];

      Result<List<Event>> result = event.between(start.subtract(Duration(seconds: 1)), end);
      //While the date passes without error
      if (result.passed) {
        tempEvents.addAll(result.data);
      }
    }

    if (convertToLocal) {
      for (int j = 0; j < tempEvents.length; j++) {
        tempEvents[j].convertEventToLocal();
      }
    }

    return tempEvents;
  }

  Event getNextEvent({Event event, DateTime startAfter}) {

    if (event == null && startAfter == null) {
      startAfter = convertFromLocal(DateTime.now());
    } else if (event != null) {
      startAfter = event.currentDate;
    }
    startAfter = convertFromLocal(startAfter);
    Event nextTime;
    for (int i = 0; i < events.length; i++) {
      Event nextEvent = events[i].getNextEvent(startAfter: startAfter);
      if (nextEvent == null) continue;
      if (nextTime != null && nextEvent.compareTo(nextTime) < 0) {
        if (event != null && nextEvent.compareTo(event) > 0) {
          nextTime = nextEvent;
        }else if(event == null){
          nextTime = nextEvent;
        }
      }

      if (nextTime == null && (event == null || nextEvent.compareTo(event) > 0)) {
        nextTime = nextEvent;
      }
    }


    return nextTime;
  }

  factory Calendar.fromJson(Map<String, dynamic> json) {
    List<dynamic> tempListEvents = (json["events"] as List);
    List<Event> tmpEvents = tempListEvents.map((e) {
      Map<String, dynamic> data = e.cast<String, dynamic>();
      return Event.fromJson(data);
    }).toList();

    return Calendar(id: json['id'], title: json['title'], events: tmpEvents);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "events": events.map((event) {
        return event.toJson();
      }).toList()
    };
  }

  //Inlcusive
  bool dateTimeBetween(DateTime time, DateTime start, DateTime end) {
    if (time.millisecondsSinceEpoch > start.millisecondsSinceEpoch &&
        time.millisecondsSinceEpoch < end.millisecondsSinceEpoch) {
      return true;
    }

    return false;
  }

  void addEvents(List<Event> newEvents) {
    events.addAll(newEvents);
  }

  void addEvent(Event newEvent) {
    events.add(newEvent);
  }

  List<Event> getAllEvents() {
    return events;
  }

  bool updateEvent(Event event) {
    int index = events.indexWhere((e) => e.id == event.id);
    events[index] = event;
    if (index != -1) return true;
    return false;
  }

  void removeEvent(Event event) {
    int index = events.indexWhere((e) => e.id == event.id);
    events.removeAt(index);
  }
}
