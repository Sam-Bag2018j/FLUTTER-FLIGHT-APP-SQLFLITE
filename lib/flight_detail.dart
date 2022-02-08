// ignore_for_file: prefer_const_constructors

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite_flight/dbhelper.dart';
import 'package:flutter_sqflite_flight/flight.dart';
import 'package:flutter_sqflite_flight/form_flight.dart';
import 'package:flutter_sqflite_flight/listflights.dart';
import 'package:flutter_sqflite_flight/main.dart';
import 'package:path/path.dart';

class FlightDetail extends StatefulWidget {
  // const SecondScreen({ Key? key }) : super(key: key);
  FlightDetail(
      {Key? key,
      required this.firstDate,
      required this.secondDate,
      required this.countryName,
      required this.dayDifference,
      required this.countryDistination,
      required this.flight,
      required this.id})
      : super(key: key);
  Flight flight;
  String firstDate;
  String secondDate;
  String countryName;
  String countryDistination;
  int dayDifference;
  int id;
  //const color1 = Colors.blueGrey[800];
  static const style_text = TextStyle(
      fontWeight: FontWeight.bold, color: Colors.black, fontSize: 26.0);
  static const style_text2 = TextStyle(
      fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22.0);
  @override
  State<FlightDetail> createState() => _FlightDetailState();
}

class _FlightDetailState extends State<FlightDetail> {
  @override
  var date1;
  var date2;
  var name1;
  var name2;
  void initState() {
    // TODO: implement initState
    super.initState();
    date1 = widget.firstDate;
    date2 = widget.secondDate;
    name1 = widget.countryName;
    name2 = widget.countryDistination;
    date2Controller = TextEditingController()..text = date2;
    dateController = TextEditingController()..text = date1;
    flightNameController = TextEditingController()..text = name1;

    flightDistinationController = TextEditingController()..text = name2;

    var id = widget.flight.id;
    String? name = widget.flight.name;
    String? dist = widget.flight.dist;
    String? firstDate = widget.flight.firstDate;
    String? secondDate = widget.flight.secondDate;
    int? days = widget.flight.days;
    days = widget.dayDifference;

    update(id, name, dist, days, firstDate, secondDate);
  }

  final dbHelper = DatabaseHelper.instance;

  late final int flightId;

  TextEditingController dateController = TextEditingController();
  TextEditingController date2Controller = TextEditingController();

  TextEditingController flightNameController = TextEditingController();

  TextEditingController flightDistinationController = TextEditingController();

  int days = 0;
  final player = AudioCache();
  void update(id, name, dist, days, firstDate, secondDate) async {
    // row to update
    Flight flight = Flight(id, name, dist, days, firstDate, secondDate);
    final rowsAffected = await dbHelper.update(flight);
    id = id;
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

  void delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    // _showMessageInScaffold('Your Flight Has Beendelete');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            initialIndex: 1, // default is 0
            length: 3, // Number of Tabs
            child: Scaffold(
                backgroundColor: Colors.yellow[50],
                appBar: AppBar(
                  //  title: const Text('Tabs Demo'),
                  backgroundColor: Colors.blueGrey[800],
                  // ignore: prefer_const_constructors
                  bottom: TabBar(tabs: const [
                    Tab(
                      icon: Icon(Icons.flight_takeoff),
                    ),
                    Tab(
                      icon: Icon(Icons.edit),
                    ),
                    Tab(
                        icon: Icon(
                      Icons.delete,
                    ))
                  ]),
                ),
                body: TabBarView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Center(
                        //child:
                        Text(
                            '${widget.countryName} To ${widget.countryDistination}',
                            style: FlightDetail.style_text), //),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Text(
                          widget.firstDate,
                          style: FlightDetail.style_text,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Text(widget.secondDate, style: FlightDetail.style_text),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Text(
                          '${widget.dayDifference} days',
                          style: FlightDetail.style_text,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 30),
                                primary: Colors.orangeAccent),
                            onPressed: () {
                              player.play('menu_click.mp3');
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.airplanemode_active_rounded),
                            label: const Text(
                              'Return',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ))
                      ],
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                                style: FlightDetail.style_text2,
                                // keyboardType:TextInputType. ,
                                controller: flightNameController,
                                decoration: InputDecoration(
                                  // fillColor: Colors.white,
                                  // filled: true,
                                  //border: OutlineInputBorder(),
                                  hintText: widget.countryName,
                                  // ignore: prefer_const_constructors
                                  hintStyle: FlightDetail.style_text,
                                  /*TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22)*/
                                ),
                                onSubmitted: (value) {
                                  print(widget.countryName);
                                  setState(() {
                                    widget.flight.name;
                                  });
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                              style: FlightDetail.style_text2,
                              // keyboardType:TextInputType. ,
                              controller: flightDistinationController,
                              onSubmitted: (value) {
                                setState(() {
                                  value = widget.flight.dist!;
                                });
                              },
                              decoration: InputDecoration(
                                  // fillColor: Colors.white,
                                  //filled: true,
                                  // border: OutlineInputBorder(),
                                  hintText: widget.countryDistination,
                                  hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                              style: FlightDetail.style_text2,
                              controller: dateController,
                              onTap: () async {
                                var date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                dateController.text =
                                    date.toString().substring(0, 10);
                                /* setState(
                                  () {
                                    widget.firstDate =
                                        dateController.text; //date.toString();
                                    print(widget.firstDate);
                                  },
                                );*/
                              },
                              onSubmitted: (value) {
                                setState(() {
                                  widget.flight.firstDate = value;
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: widget.firstDate,
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                                fillColor: Colors.white,
                                //filled: true,
                                // border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                              style: FlightDetail.style_text2,
                              controller: date2Controller,
                              onTap: () async {
                                var date2 = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                date2Controller.text =
                                    date2.toString().substring(0, 10);
                                /* setState(
                                  () {
                                    widget.secondDate = date2Controller
                                        .text; //date2.toString();
                                    // print(secondDate);
                                  },
                                );*/
                              },
                              onSubmitted: (value) {
                                setState(() {
                                  widget.flight.secondDate = value;
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                  //    fillColor: Colors.white,
                                  //     filled: true,
                                  //   border: const OutlineInputBorder(),
                                  hintText: widget.secondDate,
                                  // ignore: prefer_const_constructors
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)),
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 30),
                                primary: Colors.orangeAccent,
                                onPrimary: Colors.white,
                                shadowColor: Colors.orangeAccent,
                                elevation: 5),
                            onPressed: () {
                              player.play('menu_click.mp3');
                              setState(() {
                                differentDaysResult();

                                widget.countryName = flightNameController.text;
                                widget.countryDistination =
                                    flightDistinationController.text;
                                widget.firstDate = dateController.text;
                                widget.secondDate = date2Controller.text;
                                widget.dayDifference = differentDaysResult();
                                String name = flightNameController.text;
                                String dist = flightDistinationController.text;
                                widget.flight.days = differentDaysResult();
                                String firstDate = dateController.text;
                                String secondDate = date2Controller.text;
                                int id = widget.id;
                                update(id, name, dist, days, firstDate,
                                    secondDate);
                              });
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.airplanemode_active,
                            ),
                            label: const Text(
                              "SAVE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${name1} To ${name2}',
                              style: FlightDetail.style_text),
                          SizedBox(
                            height: 25,
                          ),
                          //  Text(name2, style: FlightDetail.style_text),
                          // SizedBox(
                          // height: 25,
                          //),
                          Text(date1, style: FlightDetail.style_text),
                          SizedBox(
                            height: 25,
                          ),
                          Text(date2, style: FlightDetail.style_text),
                          SizedBox(
                            height: 25,
                          ),
                          Text('${widget.dayDifference} days',
                              style: FlightDetail.style_text),
                          SizedBox(
                            height: 25,
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 30),
                                primary: Colors.orangeAccent,
                                onPrimary: Colors.white,
                                shadowColor: Colors.orangeAccent,
                                elevation: 5),
                            onPressed: () {
                              player.play('menu_click.mp3');

                              delete(widget.id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ListOfFlights(flights: [])));
                            },
                            icon: Icon(Icons.delete),
                            label: Text(
                              'Delete',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          )
                        ])
                  ],
                )))); // Main Layout
  }
}
