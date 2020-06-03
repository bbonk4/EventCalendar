import 'package:event_calendar/Calendar_Enums.dart';
import 'package:event_calendar/Result.dart';

import 'Calendar_Enums.dart';

class RecurrenceRule{
  // -1 = infinite
  int count;
  int interval;
  DateTime startDate;
  DateTime until;
  bool allDay;
  Frequency frequency;
  List<DayOfTheWeek> byDay;
  int dayOffset;
  bool isLastDayOfMonth;
  List<MonthOfYear> monthOfYear;
  //Include these dates
  List<DateTime> exceptions;
  //Exclude these dates
  List<DateTime> exclusions;
  List<DateTime> completed;



  RecurrenceRule( this.frequency, {this.startDate, this.count, this.interval, this.until, this.allDay, this.byDay, this.exceptions, this.exclusions, this.isLastDayOfMonth}){
   if(count == null){
     this.count = 1;
   }
   if(interval == null){
     this.interval = 1;
   }
   if(isLastDayOfMonth == null){
     this.isLastDayOfMonth = false;
   }
   if(byDay == null){
     this.byDay = List();
   }
   if(exceptions == null){
     this.exceptions  = List();
   }
   if(exclusions == null){
     this.exclusions = List();
   }


   if(startDate != null){
     initialize();
   }
  }

  void initialize(){
    startDate = convertFromLocal(startDate);
    until = calculateWeeklyEndDate();
  }

  //Exclusive
  // I.E if Rule is every hour starting at 1200 and start time is 1200
  // expected value will be 1300
  DateTime nextDateTime(DateTime start, {int position = 0}){
    DateTime nextTime;
    start = convertFromLocal(start);

    if(start.difference(startDate).isNegative && byDay == null){
      return startDate;
    }
    if(until != null && (until == start || !start.difference(until).isNegative)){
      return null;
    }


    if(frequency == Frequency.hourly){
      int offset = (start.difference(startDate).inMilliseconds/HOUR_IN_MILLI).ceil();
      bool initial = false;

      if(start.difference(startDate).isNegative){
        start = startDate;
        initial = true;
      }

      if(start == startDate || !(start.difference(DateTime.fromMillisecondsSinceEpoch(startDate.millisecondsSinceEpoch + offset*HOUR_IN_MILLI).toUtc()).inMilliseconds/HOUR_IN_MILLI).isNegative) {
        offset += interval;
      }

      if(count >= offset/interval){
        nextTime = DateTime.fromMillisecondsSinceEpoch(startDate.millisecondsSinceEpoch + offset*HOUR_IN_MILLI).toUtc();
      }else if(count == -1){
        nextTime = DateTime.fromMillisecondsSinceEpoch(startDate.millisecondsSinceEpoch + offset*HOUR_IN_MILLI).toUtc();
      }

      if(initial){
        nextTime = startDate;
      }
    }

    if(frequency == Frequency.daily){
      int offset = (start.difference(startDate).inMilliseconds/DAY_IN_MILLI).ceil();
      bool initial = false;

      if(start.difference(startDate).isNegative){
        start = startDate;
        initial = true;
      }

      if(start == startDate || !(start.difference(DateTime.fromMillisecondsSinceEpoch(startDate.millisecondsSinceEpoch + offset*DAY_IN_MILLI).toUtc()).inMilliseconds/DAY_IN_MILLI).isNegative) {
        offset += interval;
      }

      if(count >= offset/interval){
        nextTime = DateTime.fromMillisecondsSinceEpoch(startDate.millisecondsSinceEpoch + offset*DAY_IN_MILLI).toUtc();
      }else if(count == -1){
        nextTime = DateTime.fromMillisecondsSinceEpoch(startDate.millisecondsSinceEpoch + offset*DAY_IN_MILLI).toUtc();
      }

      if(initial){
        nextTime = startDate;
      }
    }

    if(frequency == Frequency.weekly){
      bool initial = false;

      if(start.difference(startDate).isNegative || (start == startDate && position == 0)){
        start = startDate;
        initial = true;
      }



      //offset should be from first valid day
      DateTime temp = nearestDay(start, List.generate(byDay.length, (position){
//        print(byDay[position]);
        return nextByDay(start, byDay[position], initial: initial);
      }),
      initial: initial);

      if(temp == null){
        //Determine next forward week
        //then determine if byDay is inbetween start and nextTime
        DateTime tempTime = DateTime.fromMillisecondsSinceEpoch(startDate.millisecondsSinceEpoch + interval*position*WEEK_IN_MILLI).toUtc();
        temp = nearestDay(tempTime, List.generate(byDay.length, (position){
          return nextByDay(tempTime, byDay[position]);
        }));

      }

      if(count >= position) {
        nextTime = temp;
      }else if(count == -1){
        nextTime = temp;
      }
    }

    if(frequency == Frequency.monthly){
      //if monthOfYear is null assume every month
      bool initial = false;
      if(start.difference(startDate).isNegative){
        start = startDate;
        initial = true;
      }


      int offset = getMonthsApart(startDate, start);
      DateTime temp;

      //Option 1 is monthly by dayOfMonth
      if(!isLastDayOfMonth){
        if(initial){
          temp = start;
        }else{
          temp = nextByMonth(start, initial: initial);
        }

      }

      //Option 2 is monthly by last day
      if(isLastDayOfMonth){
        dayOffset = lastDayOfMonth(startDate) - startDate.day;
        temp = nextByMonth(start, initial: initial);
      }
      if(initial)
        nextTime = temp;
      if(count >= offset) {
        nextTime = temp;
      }else if(count == -1){
        nextTime = temp;
      }

    }

    if(frequency == Frequency.yearly){
      bool initial = false;
      if(start.difference(startDate).isNegative){
        start = startDate;
        initial = true;
      }
      int offset = start.year - startDate.year;

      if(!start.difference(new DateTime.utc(start.year, startDate.month, startDate.day, startDate.hour, startDate.minute, startDate.second)).isNegative || start.difference(new DateTime.utc(start.year, startDate.month, startDate.day, startDate.hour, startDate.minute, startDate.second)) == Duration.zero){
        offset += interval;
      }

      if(count >= offset/interval) {
        nextTime = DateTime.utc(startDate.year + offset, startDate.month, startDate.day, startDate.hour, startDate.minute, startDate.second);
      }else if(count == -1){
        nextTime = DateTime.utc(startDate.year + offset, startDate.month, startDate.day, startDate.hour, startDate.minute, startDate.second);
      }
      if(initial){
        nextTime = startDate;
      }

    }

    return nextTime;
  }


  //if no dates return null
  DateTime nearestDay(DateTime start, List<DateTime> dates, {initial = false}){
    if(dates.length == 0)
      return null;
    Duration dif = -start.difference(dates[0]);

    for(int i = 0; i < dates.length; i++){
      if(dif > -start.difference(dates[i]) && start.difference(dates[i]).isNegative || (initial && start == dates[i])){
        dif = -start.difference(dates[i]);
      }
    }


    if(dif.isNegative)
      return null;

    return start.add(dif);
  }

  DateTime calculateWeeklyEndDate(){
    if(count != -1){
      DateTime nextDate = nextDateTime(startDate);
      DateTime time;
      int position = 1;
      while(nextDate != null){
        time = nextDate;
        nextDate = nextDateTime(time, position: position);
        position++;
      }
      return time;
    }

    return null;
  }

  DateTime nextByDay(DateTime start, DayOfTheWeek day, {bool initial = false}){
    int dif = day.index - (start.weekday - 1);
    DateTime temp = DateTime.fromMillisecondsSinceEpoch(start.millisecondsSinceEpoch).toUtc();

//    print(start.weekday);
    if(dif.isNegative){
//      print("negative");
      temp = temp.add(Duration(days: dif + 7));
      temp = new DateTime.utc(temp.year, temp.month, temp.day, startDate.hour, startDate.minute, startDate.second);
    }else if(dif == 0) {
      if(temp.difference(new DateTime.utc(temp.year, temp.month, temp.day, startDate.hour, startDate.minute, startDate.second)).isNegative || initial){
        temp = temp.add(Duration(days: dif));
        temp = new DateTime.utc(temp.year, temp.month, temp.day, startDate.hour, startDate.minute, startDate.second);
      }else if(!initial) {
        temp = temp.add(Duration(days: 7));
        temp = new DateTime.utc(temp.year, temp.month, temp.day, startDate.hour, startDate.minute, startDate.second);
      }

    } else {
//      print("positive");
      temp = temp.add(Duration(days: dif));
      temp = new DateTime.utc(temp.year, temp.month, temp.day, startDate.hour, startDate.minute, startDate.second);
    }

    return temp;
  }

  DateTime nextByMonth(DateTime start, {bool initial}){
    DateTime temp;
    if(isLastDayOfMonth){
      if(initial) {
        temp = new DateTime.utc(
            start.year,
            start.month,
            lastDayOfMonth(start) - dayOffset,
            start.hour,
            start.minute,
            start.second,);
      }else{
        temp = new DateTime.utc(
            start.year,
            start.month + 1,
            1,
            start.hour,
            start.minute,
            start.second,);
        temp = new DateTime(temp.year, temp.month, lastDayOfMonth(temp) - dayOffset, temp.hour, temp.minute, temp.second);
      }
      int attempts = 1;

      while(lastDayOfMonth(temp) - dayOffset <= 0){
        attempts++;
        temp = new DateTime.utc(start.year, start.month + attempts, lastDayOfMonth(temp) - dayOffset,  startDate.hour, startDate.minute, startDate.second);
      }
    }else {

      temp = new DateTime.utc(start.year, start.month, startDate.day, startDate.hour, startDate.minute, startDate.second);
      int attempts = 0;
      if(temp == start){
        temp = new DateTime.utc(start.year, start.month + 1, startDate.day, startDate.hour, startDate.minute, startDate.second);
        attempts = 1;
      }

      while(temp.day != startDate.day){
        temp = new DateTime.utc(start.year, start.month + attempts, startDate.day, startDate.hour, startDate.minute, startDate.second);
        attempts++;
      }
    }
    return temp;
  }

  int getMonthsApart(DateTime start, DateTime end){
    int months = 0;

    if(isLastDayOfMonth){
      while(start.difference(end).isNegative){
        if(lastDayOfMonth(start) >= (dayOffset+1)){
          months++;
        }
        start = new DateTime(start.year, start.month, lastDayOfMonth(start), start.hour,start.minute, start.second).add(Duration(days: 1));
      }

    }else{
      int day = start.day;
      while(start.difference(end).isNegative){
        if(lastDayOfMonth(start) >= day){
          months++;
        }
        start = new DateTime(start.year, start.month, lastDayOfMonth(start), start.hour,start.minute, start.second).add(Duration(days: 1));
      }

    }
    return months;
  }

  Result<List<DateTime>> between(DateTime start, DateTime end){
    Result<List<DateTime>> result = Result();
    List<DateTime> times = List();
    DateTime time = nextDateTime(start);

    while(time != null && (time.difference(end).isNegative || time.difference(end) == Duration.zero) && (until == null || (until != null && time != until && (time.difference(until).isNegative || time.difference(until) == Duration.zero)))){
      times.add(time);
      time = nextDateTime(time, position: times.length);
    }

    if(times.length > 0) {
      result.data = times;
    }else{
      result.errorMessages.add("no next Date");
    }

    return result;
  }

  factory RecurrenceRule.fromJson(Map<String,dynamic> json){
    if(json == null)
      return null;
    List<DateTime> tmpExcept;
    (json["exceptions"] as List<dynamic>).forEach((s){
      tmpExcept.add(DateTime.parse(s));
    });
    List<DateTime> tmpExclude;
    (json["exclusions"] as List<dynamic>).forEach((s){
      tmpExclude.add(DateTime.parse(s));
    });
    return RecurrenceRule(
      Frequency.values[json['frequency']],
      startDate: DateTime.parse(json['startDate']),
      allDay: json["allDay"],
      byDay: stringToDayOfWeek(json["byDay"]),
      count: json["count"],
      interval: json["interval"],
      isLastDayOfMonth: json["isLastDayOfMonth"],
      exceptions: tmpExcept,
      exclusions: tmpExclude,
      until: DateTime.parse(json["until"])
    );
  }

  Map<String,dynamic> toJson() {
    return {"count":count,
    "interval":interval,
    "startDate":startDate.toString(),
    "until" : until.toString(),
    "allDay" : allDay,
    "frequency" : frequency.index,
    "byDay" : byDay.toString(),
    "dayOffset" : dayOffset,
    "isLastDayOfMonth": isLastDayOfMonth,
    "monthOfYear": monthOfYear.toString(),
    "exceptions": exceptions.map((date){
      return date.toString();
    }).toList(),
    "exclusions": exclusions.map((date){
      return date.toString();
    }).toList()};
  }
}