import 'package:event_calendar/Calendar_Enums.dart';
import 'package:event_calendar/RecurrenceRule.dart';
import 'package:event_calendar/Reminder.dart';
import 'package:event_calendar/Result.dart';

class Event{
  String title;
  String description;
  String id;
  DateTime startDate;
  DateTime endDate;
  Object attached;
  bool allDay;
  RecurrenceRule recurrenceRule;
  Reminder reminder;



  Event(this.startDate, {this.title, this.attached, this.id, this.description, this.endDate, this.allDay, this.recurrenceRule, this.reminder}){
    startDate = convertFromLocal(startDate);
    if(endDate == null){
      this.endDate = startDate;
    }
    if(title == null){
      title = "";
    }
  }

  Event clone(){
    return Event(
      startDate,
      id: id,
      title: title,
      allDay: allDay,
      description: description,
      endDate: endDate,
      recurrenceRule: recurrenceRule,
      reminder: reminder,
      attached: attached
    );
  }

  void convertEventToLocal(){
    startDate = convertToLocal(startDate);
    endDate = convertToLocal(endDate);
  }

  //TODO Switch this to check the id
  operator ==(other) =>startDate == other.startDate;

  // Return null if there is no next Date
  // (Exclusive)
  Result<List<Event>> between(DateTime start, DateTime end){
    start = convertFromLocal(start);
    end = convertFromLocal(end);
    Result<List<Event>> result = new Result();
    result.data = new List();

    //First check if single date
    if(startDate != null && endDate != null){

      if(recurrenceRule != null){
        Result rResult = recurrenceRule.between(start, end);
        if(rResult.passed){
          for(int i = 0; i < rResult.data.length; i++){
            Event tempEvent = clone();
            tempEvent.startDate = rResult.data[i];
            result.data.add(tempEvent);
          }
        }


      }else{
        if(start.millisecondsSinceEpoch < startDate.millisecondsSinceEpoch && startDate.millisecondsSinceEpoch < end.millisecondsSinceEpoch) {
          result.data = [clone()];
        }
      }
    }else{
      result.errorMessages.add("no next Date");
    }

    return result;
  }


}