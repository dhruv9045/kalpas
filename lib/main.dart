import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task1/pages/home.dart';
import 'package:task1/pages/login.dart';
import 'package:task1/pages/register.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>("favourate");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kalpas",
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: <String, WidgetBuilder>{
        'login': (BuildContext context) => Login(),
        'home': (BuildContext context) => Home(),
        'register': (BuildContext context) => Register(),
      },
    );
  }
}
