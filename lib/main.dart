// import 'package:first/screens/bmi_calculator.dart';
import 'package:bloc/bloc.dart';
import 'package:todo/layout/home_layout.dart';
import 'package:todo/shared/bloc_observer.dart';
// import 'package:todo/screens/login_screen.dart';
// import 'package:todo/screens/users_screen.dart';
import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: HomeLayout(),
    );
  }
}
