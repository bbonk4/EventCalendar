# Event Calendar

This package is for calculating calendar events with Reccurring events without the use of device calendar.

## Installation

Just add the latest version of ```event_calendar``` to the ```pubspec.yabl``` file

### Side note
Due to the nature of this package unit testing can be dificult so if you find any inaccurate dates please share them on the issues page.

## Usage

Start off by creating a calendar. You can add an event with the ```addEvent(Event event)```.
you can follow the simple example below or look at the ```./example/main.dart``` file.
```
Calendar calendar = new Calendar(title: "My Calendar", id:"calendarID");

calendar.addEvent(Event(DateTime(2020, 6, 1, 10, 0, 0), id: "1", title: "Single event"));

//Get a single next event
calendar.getNextEvent(startAfter: DateTime(2020, 5, 28, 12, 0, 0));

DateTime start = DateTime(2020, 5, 28, 12, 0, 0);
DateTime end = DateTime(2020, 6, 2, 12, 0, 0);

//get all events within a time frame
List<Events> events = calendar.getEvents(start, end);
```

## Calendar Features
[x] Parse to and from json <br>
[x] Get next Event <br>
[x] Get events in time frame <br>
[x] Limit event ocurrences <br>
[x] Recurring events <br>
   - Hourly <br>
   - Daily <br>
   - Weekly <br>
   - Monthly (both from start of month and from last date) <br>
   - Yearly <br>
[x] Intervals <br>

TODO <br>
[] Completions <br>
[] Exceptions <br>
[] Exclusions <br>


    




