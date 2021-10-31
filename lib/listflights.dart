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
          IconButton(
              hoverColor: Colors.deepOrange[400],
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FlightForm()));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 30.0,
              ))
        ],
      ),
      body: Center(
        child: Scrollbar(
          child: ListView.builder(
            itemCount: widget.flights.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Dismissible(
                  key: UniqueKey(),
                  // decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    setState(() {
                      //delete()
                      int? id = widget.flights[index].id;
                      widget.flights.removeAt(index);
                      delete(id);
                    });
                  },
                  child: Card(
                    color: Colors.black,
                    child: ListTile(
                      title: Text(
                          '${widget.flights[index].name} - ${widget.flights[index].dist}',
                          style: styleList),
                      //title: Text(newList(Index)),
                      subtitle: Text('${widget.flights[index].firstDate}',
                          style: const TextStyle(color: Colors.amberAccent)),
                      trailing: Text(
                          '${widget.flights[index].days.toString()} days',
                          style: const TextStyle(color: Colors.amberAccent)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (Context) => FlightDetail(
                                      id: widget.flights[index].id!.toInt(),
                                      firstDate: widget.flights[index].firstDate
                                          .toString(),
                                      secondDate: widget
                                          .flights[index].secondDate
                                          .toString(),
                                      countryName:
                                          widget.flights[index].name.toString(),
                                      dayDifference:
                                          widget.flights[index].days!.toInt(),
                                      countryDistination:
                                          widget.flights[index].dist.toString(),
                                      flight: widget.flights[index],
                                    )));
                      },
                    ),
                  ),
                  background: Container(
                    color: Colors.red,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ));
              // );
            },
          ),
        ),
      ),
    );
  }
}
