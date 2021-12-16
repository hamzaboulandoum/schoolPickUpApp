import 'package:e_school_bus_admin/optimization/calcule.dart';
import 'package:e_school_bus_admin/optimization/map_state.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  //UI Variables
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: mainu(),
        builder:
            (BuildContext context, AsyncSnapshot<List<MapState>> mapStates) {
          if (!mapStates.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.green,
              fixedColor: Colors.white,
              iconSize: 25,
              showUnselectedLabels: false,
              onTap: (index) => setState(
                () {
                  //it informs all the tree that the index was updated
                  currentIndex = index;
                },
              ),
              currentIndex: currentIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on),
                  label:
                      'Notifications', // it is necessary to add a label inside this widget
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on),
                  label: 'Map',
                ),
              ],
            ),
            body: IndexedStack(
              index: currentIndex,
              children: mapStates.data!,
            ),
          );
        });
  }
}
