import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/hive_movie_model.dart';
import 'package:imdb_app/models/hive_tv_model.dart';
import 'package:imdb_app/screens/home.dart';

Future main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HiveMovieModelAdapter());
  Hive.registerAdapter(HiveTvModelAdapter());
  await Hive.openBox<HiveMovieModel>('movie_list');
  await Hive.openBox<HiveTvModel>('tv_list');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "JMDB",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: scaffoldColor,
        appBarTheme: const AppBarTheme(color: Colors.transparent),
      ),
      home: const Home(),
    );
  }
}
