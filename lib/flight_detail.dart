import 'package:flutter/material.dart';
import 'package:flutter_sqflite_flight/dbhelper.dart';
import 'package:flutter_sqflite_flight/flight.dart';
import 'package:flutter_sqflite_flight/form_flight.dart';
import 'package:flutter_sqflite_flight/main.dart';

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
  static const style_text = TextStyle(
      fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0);

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            initialIndex: 1, // default is 0
            length: 2, // Number of Tabs
            child: Scaffold(
                backgroundColor: Colors.black87,
                appBar: AppBar(
                  //  title: const Text('Tabs Demo'),
                  backgroundColor: Colors.black87,
                  // ignore: prefer_const_constructors
                  bottom: TabBar(tabs: const [
                    Tab(
                      icon: Icon(Icons.flight_land),
                    ),
                    Tab(
                      icon: Icon(Icons.edit),
                    )
                  ]),
                ),
                body: TabBarView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                                '${widget.countryName} TO ${widget.countryDistination}',
                                style: FlightDetail.style_text)),
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
                            style:
                                ElevatedButton.styleFrom(primary: Colors.amber),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.airplanemode_active_rounded),
                            label: const Text('Return'))
                      ],
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                                // keyboardType:TextInputType. ,
                                controller: flightNameController,
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(),
                                    hintText: widget.countryName),
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
                              // keyboardType:TextInputType. ,
                              controller: flightDistinationController,
                              onSubmitted: (value) {
                                setState(() {
                                  value = widget.flight.dist!;
                                });
                              },
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(),
                                  hintText: widget.countryDistination),
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
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
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
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  hintText: widget.secondDate),
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
                            label: const Text("SAVE"),
                          ),
                        ]),
                  ],
                )))); // Main Layout
  }
}
