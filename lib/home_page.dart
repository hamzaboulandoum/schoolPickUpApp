import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_school_bus_admin/Screens/chat_page.dart';
import 'package:e_school_bus_admin/Screens/map_page.dart';
import 'package:e_school_bus_admin/Screens/notifications.dart';
import 'package:e_school_bus_admin/optimization/map_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/services.dart';

import 'google_maps/polyline.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  // here we create a snapshot of the collection users
  final Function(User?) onSignOut;
  // ignore: use_key_in_widget_constructors
  const HomePage({required this.onSignOut, Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Home Page Variables
  String firstName = "Name_Of_Responsible";
  String lastName = "Last_Name_Of_Responsible";
  String adress = "adress";
  String phoneNumber = "Phone_Number_Of_Responsible";
  String schoolName = "SchoolName";
  String schoolPassword = "SchoolPassword";
  String email = "Email_Of_Responsible";

  //Pages Variables
  final screens = [
    const Notifications(),
    //MapScreen(),
    MapPage(),
    //const MapTemporary(),
    const chatPage(),
  ];

  //UI Variables
  int currentIndex = 0;

  // Future Logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    widget.onSignOut(null);
  }

  // UI Widgets
  Widget buildLogOutBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          logout();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
          elevation: MaterialStateProperty.all<double>(10),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              return states.contains(MaterialState.pressed)
                  ? Colors.black12
                  : null;
            },
          ),
        ),

        child: const Text(
          'Log Out',
          style: TextStyle(
            color: Color(0xff5ac18e),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // ignore: prefer_const_constructors
      ),
    );
  }

  // getting the listtile
  ListTile _tile(String title, String subtitle, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      leading: Icon(
        icon,
        color: Colors.white70,
      ),
    );
  }

  //Adding User Data
  Widget getUserData(String title, String subtitle, IconData icon) {
    //getting current user
    User? currentUser = FirebaseAuth.instance.currentUser;
    late String currentUserId = currentUser!.uid;

    //Getting Collection Reference
    CollectionReference school =
        FirebaseFirestore.instance.collection('Schools');

    //returning The Future Builder
    return FutureBuilder<DocumentSnapshot>(
      future: school.doc(currentUserId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Encoutred an error");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document Does Not Exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return _tile(title, data[subtitle], icon);
        }
        return const Text("Loading");
      },
    );
  }

  //SideBar
  Widget sideBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 0,
        ),
        child: Column(
          children: [
            getUserData("Nom :", lastName, Icons.person_add),
            getUserData("Prenom:", firstName, Icons.person_add),
            getUserData("Email :", email, Icons.email),
            getUserData("Adress :", adress, Icons.location_on),
            getUserData("Ecole:", schoolName, Icons.school),
            getUserData(" Mot de Passe :", schoolPassword, Icons.password),
            getUserData("Numero de telephone:", phoneNumber, Icons.phone),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: buildLogOutBtn(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  //Navigation Drawer Widget
  Widget navigationdrawerwidget() {
    return SafeArea(
      child: Drawer(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x665ac18e),
                        Color(0x995ac18e),
                        Color(0xcc5ac18e),
                        Color(0xff5ac18e),
                      ],
                    ),
                  ),
                  child: sideBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigationdrawerwidget(),
      appBar: AppBar(
        backgroundColor: const Color(0x665ac18e),
        title: const Text(
          'E School Bus Admin',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.green,
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
            icon: Icon(Icons.notifications),
            label:
                'Notifications', // it is necessary to add a label inside this widget
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.maps_home_work),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
