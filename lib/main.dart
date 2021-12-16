import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_school_bus_admin/authentication/decision_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  //what this does is that it only initializes the firebase app
  //FirebaseAppCheck appCheck = FirebaseAppCheck.instance;
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        // We do also need to configure this splash screen to really be useful
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // ignore: avoid_print
            print('You have an error !${snapshot.error.toString()}');
            return const Text('Something went wrong');
          } else if (snapshot.hasData) {
            return const DecisionTree();
            //so nothing has changed everything is smooth
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
