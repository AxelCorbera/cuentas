import 'package:Cuentas/objects/data.dart';
import 'package:Cuentas/pages/details.dart';
import 'package:Cuentas/pages/home.dart';
import 'package:Cuentas/pages/start.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mis cuentas',
        theme: ThemeData(),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (BuildContext context) {
            switch (settings.name) {
              case '/Home':
                return Home(app: Firebase.app(),);
              case '/Start':
                return Start();
              case '/Details':
                var arguments = settings.arguments as Args;
                return Details(args: arguments,);
              default:
                return Home(app: Firebase.app());
            }
          });
        }
    );
  }
}