import 'package:flutter_sqflite_flight/dbhelper.dart';

class Flight {
  int? id;
  String? name;
  String? dist;
  int? days;
  String? firstDate;
  String? secondDate;

  Flight(this.id, this.name, this.dist, this.days, this.firstDate,
      this.secondDate);

  Flight.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    dist = map['dist'];
    days = map['days'];
    firstDate = map['firstDate'];
    secondDate = map['secondDate'];
  }
  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnDist: dist,
      DatabaseHelper.columnDays: days,
      DatabaseHelper.columnDate1: firstDate, //as String
      DatabaseHelper.columnDate2: secondDate //as String
    };
  }
}
