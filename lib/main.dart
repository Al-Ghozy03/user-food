// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_food/daerah.dart';
import 'package:user_food/filter.dart';
import 'package:user_food/home.dart';
import 'package:user_food/promo.dart';
import 'package:user_food/range_harga.dart';
import 'package:user_food/search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: "popin"),
      initialRoute: "/",
      routes: {
        "/": (context) => Home(),
        "/search": (context) => Search(
            search: ModalRoute.of(context)?.settings.arguments as String),
        "/filter": (context) => Filter(
            data: ModalRoute.of(context)?.settings.arguments as String),
        "/daerah": (context) => Daerah(
            data: ModalRoute.of(context)?.settings.arguments as String),
        "/promo": (context) => Promo(
            data: ModalRoute.of(context)?.settings.arguments as String),
        "/harga": (context) => RangeHarga(
            data: ModalRoute.of(context)?.settings.arguments as String),
      },
    );
  }
}
