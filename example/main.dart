import 'package:event_calendar/event_calendar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Calendar Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  Calendar calendar = new Calendar(title: "My Calendar", id:"calendarID");

  void initState(){
    super.initState();
    calendar.addEvent(Event(DateTime(2020, 6, 1, 12, 0, 0), id: "1", title: "Take out the garbage", recurrenceRule: RecurrenceRule(Frequency.weekly, byDay: [DayOfTheWeek.Monday, DayOfTheWeek.Friday], count: -1)));
    calendar.addEvent(Event(DateTime(2020, 6, 18, 12, 0, 0), id: "2", title: "Pay garbage bill", recurrenceRule: RecurrenceRule(Frequency.monthly, count: 4)));
    calendar.addEvent(Event(DateTime(2020, 7, 17, 12, 0, 0), id: "3", title: "Cancel garbage service"));
  }

  List<Widget> displayEvents(DateTime start, DateTime end){
    List<Widget> children = List();
    List<Event> events = calendar.getEvents(start, end);
    events.sort((a, b){
      return a.currentDate.difference(b.currentDate).inSeconds;
    });
    events.forEach((e){
      print(e.title);
      children.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(child: GestureDetector(onTap: (){

        },child:
        Row(
          children: <Widget>[
            Expanded(child: Container(color: Colors.blue,child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.title, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${e.currentDate.toIso8601String()}", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),),
                ),
              ],
            ))),
          ],
        ),
        )),
      ));
    });

    if(children.length == 0){
      children.add(Center(child:Container(child: Text("All clear! \nNo events planned for this day", textAlign: TextAlign.center,style: TextStyle(fontSize: 18),), height: 100)));
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Container(height: 50,),
          Column(children: displayEvents(DateTime(2020, 6, 18, 12, 0, 0), DateTime(2020, 7, 17, 12, 0, 0))),
        ],),
      ),
    );
  }
}
