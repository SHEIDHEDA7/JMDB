// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/movie_widgets/movie_watchList.dart';
import 'package:imdb_app/tv_widgets/tv_watchlist.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("W A T C H L I S T"),
            bottom: TabBar(
              labelColor: textColor,
              labelStyle: mediumText,
              indicatorColor: secondaryColor,
              indicatorWeight: 5,
              labelPadding: EdgeInsets.all(8),
              tabs: const [
                Text("Movie"),
                Text("Tv Shows"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MovieWL(),
              TvWL(),
            ],
          ),
        ));
  }
}
