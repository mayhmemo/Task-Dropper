// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:task_dropper/data/datasources/local_source.dart';
import 'package:task_dropper/presentation/pages/splash_screen_page.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  databaseFactory = databaseFactoryFfiWeb;

  await LocalDataSource().database;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenPage(),
    );
  }
}