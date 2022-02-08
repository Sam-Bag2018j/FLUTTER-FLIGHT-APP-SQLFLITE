import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite_flight/dbhelper.dart';
import 'package:flutter_sqflite_flight/flight.dart';
import 'package:flutter_sqflite_flight/flight_detail.dart';
import 'package:flutter_sqflite_flight/form_flight.dart';
//import 'package:flutter_sqflite_flight/main.dart';
//import 'package:path/path.dart';

class ListOfFlights extends StatefulWidget {
  List<Flight> flights = [];

  ListOfFlights({Key? key, required this.flights}) : super(key: key);
  @override
  _ListOfFlightsState createState() => _ListOfFlightsState();
}

class _ListOfFlightsState extends State<ListOfFlights> {
  final dbHelper = DatabaseHelper.instance;
  // ignore: unnecessary_const
  static const styleList = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 26,
      fontStyle: FontStyle.normal);

  void queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    widget.flights.clear();
    allRows.forEach((row) => widget.flights.add(Flight.fromMap(row)));
    setState(() {});
  }

  List<Flight> myFlights = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryAll();
    myFlights = widget.flights;
  }

  void delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    //_showMessageInScaffold('deleted $rowsDeleted row(s): row $id');
  }

  final player = AudioCache();

  @override
  Widget build(BuildContext context) {
    setState(() {
      queryAll();
    });
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.yellow[50],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
                hoverColor: Colors.deepOrange[400],
                onPressed: () {
                  player.play('menu_click.mp3');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FlightForm()));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.orangeAccent,
                  size: 40.0,
                )),
          )
        ],
      ),
      body: //Center(
          //  child: Scrollbar(
          // child:
          ListView.builder(
        itemCount: widget.flights.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Card(
              color: Colors.blueGrey[700],
              child: ListTile(
                title: Text(
                    '${widget.flights[index].name} - ${widget.flights[index].dist}',
                    style: styleList),
                //title: Text(newList(Index)),
                subtitle: Text('${widget.flights[index].firstDate}',
                    style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                trailing: Text('${widget.flights[index].days.toString()} days',
                    style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  player.play('menu_click.mp3');
                  queryAll();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (Context) => widget.flights[index] != null
                            ? FlightDetail(
                                id: widget.flights[index].id!.toInt(),
                                firstDate:
                                    widget.flights[index].firstDate.toString(),
                                secondDate:
                                    widget.flights[index].secondDate.toString(),
                                countryName:
                                    widget.flights[index].name.toString(),
                                dayDifference:
                                    widget.flights[index].days!.toInt(),
                                countryDistination:
                                    widget.flights[index].dist.toString(),
                                flight: widget.flights[index],
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
