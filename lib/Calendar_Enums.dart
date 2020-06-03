enum Frequency {hourly, daily, weekly, monthly, yearly}

enum DayOfTheWeek {Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday}

enum MonthOfYear {January, February, March, April, May, June, July, August, September, October, November, December}

enum WeekNumber {First, Second, Third, Fourth, Last}


const int HOUR_IN_MILLI = 3600000;
const int DAY_IN_MILLI = 86400000;
const int WEEK_IN_MILLI = 604800000;

int lastDayOfMonth(DateTime month) {
var beginningNextMonth = (month.month < 12)
? new DateTime(month.year, month.month + 1, 1)
    : new DateTime(month.year + 1, 1, 1);
return beginningNextMonth.subtract(new Duration(days: 1)).day;
}

DateTime getStartOfDay(DateTime time){
  if(time == null)
    return null;
  return DateTime(time.year, time.month,time.day);
}

DateTime convertFromLocal(DateTime time){
  if(time == null)
    return null;
  return DateTime.utc(time.year, time.month, time.day, time.hour, time.minute, time.second);
}

DateTime convertToLocal(DateTime time){
  if(time == null)
    return null;
  return DateTime(time.year, time.month, time.day, time.hour, time.minute, time.second);
}

String dayOfWeekToString (List<DayOfTheWeek> dayOfTheWeek){
  return dayOfTheWeek.toList().toString();
}

List<DayOfTheWeek> stringToDayOfWeek (String text){
  return text.split(",").map((text){
    if(text.contains("Monday")){
      return DayOfTheWeek.Monday;
    }
    if(text.contains("Tuesday")){
      return DayOfTheWeek.Tuesday;
    }
    if(text.contains("Wednesday")){
      return DayOfTheWeek.Wednesday;
    }
    if(text.contains("Thursday")){
      return DayOfTheWeek.Thursday;
    }
    if(text.contains("Friday")){
      return DayOfTheWeek.Friday;
    }
    if(text.contains("Saturday")){
      return DayOfTheWeek.Saturday;
    }
    if(text.contains("Sunday")){
      return DayOfTheWeek.Sunday;
    }
    return null;

  }).toList();
}