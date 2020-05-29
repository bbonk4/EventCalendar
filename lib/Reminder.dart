class Reminder{
  String title;
  String description;
  String id;

  Reminder({this.title,this.id, this.description});

  operator ==(other) =>id == other.id;

}