import 'package:event_calendar/Calendar_Enums.dart';
import 'package:event_calendar/RecurrenceRule.dart';
import 'package:event_calendar/Reminder.dart';
import 'package:event_calendar/Result.dart';

class Event{
  String title;
  String description;
  String id;
  DateTime startDate;
  DateTime currentDate;
  DateTime endDate;
  Object attached;
  bool allDay;
  RecurrenceRule recurrenceRule;
  Reminder reminder;



  Event(this.startDate, {this.title, this.attached, this.id, this.description, this.currentDate, this.endDate, this.allDay, this.recurrenceRule, this.reminder}){
    startDate = convertFromLocal(startDate);
    if(currentDate == null) {
      currentDate = startDate;
    }else{
      currentDate = convertFromLocal(currentDate);
    }
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
      currentDate: currentDate,
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
    currentDate = convertToLocal(currentDate);
    endDate = convertToLocal(endDate);
  }

  //TODO Switch this to check the id
  operator ==(other) {
   return currentDate == other.currentDate && title == other.title;
  }

    Event getNextEvent({DateTime startAfter}){
      Event nextTime;

      if(startAfter == null){
        startAfter = currentDate;
      }

      if(recurrenceRule != null){
        DateTime nextDate;

        if(startAfter != null) {
          nextDate = recurrenceRule.nextDateTime(startAfter);
        }else{
          nextDate = recurrenceRule.nextDateTime(currentDate);
        }

        if(nextDate != null && (recurrenceRule.until == null || (recurrenceRule.until != null && nextDate != recurrenceRule.until && (nextDate.difference(recurrenceRule.until).isNegative || nextDate.difference(recurrenceRule.until) == Duration.zero)))){
          nextTime = clone();
          nextTime.currentDate = nextDate;
        }



      }else{
        if(startAfter.difference(startDate).isNegative){
          nextTime = this;
        }
      }

      return nextTime;
    }

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
              tempEvent.currentDate = rResult.data[i];
              result.data.add(tempEvent);
            }
          }


        }else{
          if(start.millisecondsSinceEpoch < currentDate.millisecondsSinceEpoch && currentDate.millisecondsSinceEpoch <= end.millisecondsSinceEpoch) {
            result.data = [clone()];
          }
        }
      }else{
        result.errorMessages.add("no next Date");
      }

      return result;
    }
  }
