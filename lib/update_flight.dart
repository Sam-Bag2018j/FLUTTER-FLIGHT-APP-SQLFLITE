import 'package:flutter/material.dart';
import 'package:flutter_sqflite_flight/dbhelper.dart';
import 'package:flutter_sqflite_flight/flight.dart';

class UpdateFlight extends StatefulWidget {
  const UpdateFlight({Key? key}) : super(key: key);

  @override
  _UpdateFlightState createState() => _UpdateFlightState();
}

class _UpdateFlightState extends State<UpdateFlight> {
  final dateController = TextEditingController();
  final date2Controller = TextEditingController();
  final flightNameController = TextEditingController();
  final flightDistinationController = TextEditingController();
  String firstDate = "";
  String secondDate = "";
  String countryName = '';
  String countryDistination = "";
  int days = 0;
  final dbHelper = DatabaseHelper;

  void _update(id, name, dist, days, firstDate, secondDate) async {
    // row to update
    Flight flight = Flight(id, name, dist, days, firstDate, secondDate);
    // ignore: unused_local_variable
    // final rowsAffected = await dbHelper.update(flight);
    //   _showMessageInScaffold('updated $rowsAffected row(s)');
  }

  // _showMessageInScaffold('updated $rowsAffected row(s)');
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
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
                      // countryNames.add(value);
                      // addItemToList();
                      //   print(countryName);
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
                    setState(() {});
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
                      // print(firstDate);
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
                      // print(secondDate);
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
            ])));

    //);
  }
}
