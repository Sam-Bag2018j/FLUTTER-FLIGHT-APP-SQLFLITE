import 'package:flutter/material.dart';
import 'package:flutter_sqflite_flight/dbhelper.dart';
import 'package:flutter_sqflite_flight/flight.dart';
import 'package:flutter_sqflite_flight/flight_detail.dart';
import 'package:flutter_sqflite_flight/listflights.dart';

class FlightForm extends StatefulWidget {
  const FlightForm({Key? key}) : super(key: key);

  @override
  _FlightFormState createState() => _FlightFormState();
}

class _FlightFormState extends State<FlightForm> {
  final dateController = TextEditingController();
  final date2Controller = TextEditingController();
  final flightNameController = TextEditingController();
  final flightDistinationController = TextEditingController();
  String firstDate = "";
  String secondDate = "";
  String countryName = '';
  String countryDistination = "";
  int days = 0;

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    date2Controller.dispose();
    flightNameController.dispose();
    flightDistinationController.dispose();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    // to = DateTime.parse(date2Controller.text);
    return (to.difference(from).inHours / 24).round();
  }

  int differentDaysResult() {
    setState(() {
      days = (daysBetween(DateTime.parse(dateController.text),
          DateTime.parse(date2Controller.text)));
    });
    return days;
  }

  List<String> countryNames = [];
  List<String> countryDistinationList = [];

  void addItemToList() {
    setState(() {
      countryNames.add(flightNameController.text);
      //print(countryNames);
    });
  }

  late final int flightId;
  List<Flight> flights = [];
  final dbHelper = DatabaseHelper.instance;
  void queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    flights.clear();
    allRows.forEach((row) => flights.add(Flight.fromMap(row)));
    setState(() {});
  }

  void insert(name, dist, days, firstDate, secondDate) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnDist: dist,
      DatabaseHelper.columnDays: days,
      DatabaseHelper.columnDate1: firstDate,
      DatabaseHelper.columnDate2: secondDate
    };
    Flight flight = Flight.fromMap(row);
    final id = await dbHelper.insert(flight);
    setState(() {
      flightId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                // keyboardType:TextInputType. ,
                controller: flightNameController,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: 'Enter Your Flight Name'),
                onSubmitted: (value) {
                  setState(() {
                    //  getNames(value);
                    countryNames.add(value);
                    // addItemToList();
                    print(countryName);
                  });
                },
                // print(getNames(value));
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                // keyboardType:TextInputType. ,
                controller: flightDistinationController,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: 'Enter Your Flight Name'),

                onSubmitted: (value) {
                  setState(() {
                    //  getNames(value);
                    countryDistinationList.add(value);
                    // addItemToList();
                    print(countryDistinationList);
                  });
                },
                // print(getNames(value));
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: dateController,
                onTap: () async {
                  var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  dateController.text = date.toString().substring(0, 10);
                  setState(() {
                    firstDate = date2Controller.text; //date.toString();
                    print(firstDate);
                  });
                },
                readOnly: true,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: 'Pick your departure date '),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: date2Controller,
                onTap: () async {
                  var date2 = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  date2Controller.text = date2.toString().substring(0, 10);
                  setState(() {
                    secondDate = date2Controller.text; //date2.toString();
                    print(secondDate);
                  });
                },
                readOnly: true,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: 'Pick your arrival date '),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(130, 30),
                  primary: Colors.amber,
                  onPrimary: Colors.white,
                  shadowColor: Colors.amberAccent,
                  elevation: 2),
              onPressed: () {
                setState(() {
                  days = (daysBetween(DateTime.parse(dateController.text),
                      DateTime.parse(date2Controller.text)));
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlightDetail(
                            firstDate: dateController.text,
                            secondDate: date2Controller.text,
                            countryName: flightNameController.text,
                            countryDistination:
                                flightDistinationController.text,
                            dayDifference: days,
                            flight: flights[flightId],
                            id: flightId)));
              },
              child: const Text('FLIGHT DETAIL'),
            ),
            const SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(130, 30),
                  primary: Colors.amber,
                  onPrimary: Colors.white,
                  shadowColor: Colors.amberAccent,
                  elevation: 2),
              onPressed: () {
                setState(() {
                  queryAll();
                });
                differentDaysResult();
                String name = flightNameController.text;
                String dist = flightDistinationController.text;
                int days = differentDaysResult();
                String firstDate = dateController.text;
                String secondDate = date2Controller.text;

                insert(name, dist, days, firstDate, secondDate);
                print(firstDate);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          // ignore: prefer_const_constructors

                          ListOfFlights(flights: flights),
                    ));
              },
              child: const Text("SAVE"),
            ),
            const SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(130, 30),
                  primary: Colors.amber,
                  onPrimary: Colors.white,
                  shadowColor: Colors.amberAccent,
                  elevation: 2),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListOfFlights(flights: flights)));
              },
              child: const Text('FLIGHTS LIST'),
            )
          ],
        ),
      ),
    );
  }
}
