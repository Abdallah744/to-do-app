import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shared/BLoC_observer.dart';
import 'layout/home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MaterialApp(
    home: HomeLayout(),
  ));
}