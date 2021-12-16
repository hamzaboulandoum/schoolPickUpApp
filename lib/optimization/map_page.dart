import 'package:e_school_bus_admin/optimization/calcule.dart';
import 'package:e_school_bus_admin/optimization/map_state.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: mainu(),
        builder:
            (BuildContext context, AsyncSnapshot<List<MapState>> mapStates) {
          if (!mapStates.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              body: Center(
                  child: Column(
            children: mapStates.data!,
          )));
        });
  }
}
