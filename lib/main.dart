import 'package:bloc/bloc.dart';
import 'package:conditional_builder_null_safety/example/example.dart';

import 'package:todo/shared/bloc_observer.dart';

import 'package:flutter/material.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}
