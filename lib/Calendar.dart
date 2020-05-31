import 'package:event_calendar/Calendar_Enums.dart';
import 'package:event_calendar/Event.dart';
import 'package:event_calendar/Result.dart';

class Calendar{
  String title;
  String id;
  List<Event> events;


  Calendar({this.title,this.id, this.events}){
    if(events == null){
      events = new List();
    }
  }

  operator ==(other) =>id == other.id;

  List<Event> getEvents(DateTime start, DateTime end, {convertToLocal = true}){
    List<Event> tempEvents = List();

    if(events.length == 0){
      return tempEvents;
    }

    for(int i = 0; i < events.length; i++){
      Event event = events[i];

      Result<List<Event>> result = event.between(start.subtract(Duration(seconds: 1)), end);
      //While the date passes without error
      if(result.passed){
        tempEvents.addAll(result.data);
      }

    }

    if(convertToLocal){
      for(int j = 0; j < tempEvents.length; j++){
        tempEvents[j].convertEventToLocal();
      }
    }

    return tempEvents;
  }

  Event getNextEvent({Event event, DateTime startAfter}){
    if(event == null && startAfter == null){
      startAfter = convertFromLocal(DateTime.now());
    }else if(event != null){
      startAfter = event.currentDate;
    }
    Event nextTime;
    int compare;
    for(int i = 0; i < events.length; i++){
      Event nextEvent = events[i].getNextEvent(startAfter: startAfter);
      if(nextEvent != null && nextEvent.currentDate.millisecondsSinceEpoch >= startAfter.millisecondsSinceEpoch && (nextTime == null || (nextTime != null && nextEvent.currentDate.millisecondsSinceEpoch < nextTime.currentDate.millisecondsSinceEpoch))){
        if(event != null && events[i].title.compareTo(event.title).isNegative || compare == null) {
          if(nextTime != null) {
            compare = events[i].title.compareTo(nextTime.title);
          }else{
            compare = events[i].title.compareTo(event.title);
          }

          if(compare < 0 || nextEvent.currentDate != event.currentDate) {
            nextTime = nextEvent;
          }

        }else{
          nextTime = events[i].getNextEvent();
        }

      }
    }


    return nextTime;
  }


  //Inlcusive
  bool DateTimeBetween(DateTime time, DateTime start, DateTime end){
    if(time.millisecondsSinceEpoch > start.millisecondsSinceEpoch && time.millisecondsSinceEpoch < end.millisecondsSinceEpoch){
      return true;
    }

    return false;
  }

  void addEvents(List<Event> newEvents){
    events.addAll(newEvents);
  }

  void removeEvent(Event event){
    int index = events.indexWhere((e)=> e.id == event.id);
    events.removeAt(index);
  }


}