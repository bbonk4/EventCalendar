import 'package:event_calendar/Calendar_Enums.dart';
import 'package:event_calendar/RecurrenceRule.dart';
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



  Event(this.startDate, {this.title, this.attached, this.id, this.description, this.currentDate, this.endDate, this.allDay, this.recurrenceRule}){
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

    if(recurrenceRule != null){
      recurrenceRule.startDate = startDate;
      recurrenceRule.initialize();
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
    return convertToLocal(currentDate) == convertToLocal(other.currentDate) && id == other.id && title == other.title;
  }
  int get hashCode => (super.hashCode);

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


  factory Event.fromJson(Map<String,dynamic> json){
    return Event(
      DateTime.parse(json["startDate"] ),
      id:json['id'],
      currentDate: DateTime.parse(json["currentDate"]),
      attached: json["attached"],
      title: json["title"],
      recurrenceRule: RecurrenceRule.fromJson(json["recurrenceRule"]),
      endDate: DateTime.parse(json["endDate"]),
      description: json["description"],
      allDay: json["allDay"]
    );
  }

  Map<String,dynamic> toJson() {
    return {"id":id,"title":title, "description": description, "startDate": startDate.toString(), "currentDate": currentDate.toString(), "endDate" : endDate.toString(), "attached":attached, "allDay" : allDay, "recurrenceRule": recurrenceRule!=null?recurrenceRule.toJson(): null};
  }

  }
