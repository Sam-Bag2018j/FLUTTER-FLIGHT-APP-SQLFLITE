import 'package:flutter/material.dart';
import 'package:flutter_sqflite_flight/dbhelper.dart';
import 'package:flutter_sqflite_flight/flight.dart';
import 'package:flutter_sqflite_flight/flight_detail.dart';
import 'package:flutter_sqflite_flight/form_flight.dart';
import 'package:flutter_sqflite_flight/listflights.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ListOfFlights(
          flights: [],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  List<Flight> flights = [];
  final dbHelper = DatabaseHelper.instance;
  void queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    flights.clear();
    allRows.forEach((row) => flights.add(Flight.fromMap(row)));

    //  _showMessageInScaffold('Query done.');
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
    // _showMessageInScaffold('inserted row id: $id');
  }

  @override
  void initState() {
    // TODO: implement initState
    // final VoidCallback test2 = queryAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*  backgroundColor: Colors.grey[800],
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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  onPrimary: Colors.white,
                  shadowColor: Colors.amberAccent,
                  elevation: 5),
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
                            )));
              },
              icon: const Icon(Icons.airplanemode_active),
              label: const Text('Submit'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  onPrimary: Colors.white,
                  shadowColor: Colors.amberAccent,
                  elevation: 5),
              onPressed: () {
                //final test = queryAll();
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

                          ListOfFlights(flights: flights //

                              ),
                    ));
              },
              icon: const Icon(
                Icons.airplanemode_active,
              ),
              label: const Text("see List"),
            )
          ],
        ),
      ),*/
        );
  }
}
