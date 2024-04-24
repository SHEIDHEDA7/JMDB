// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/hive_tv_model.dart';
import 'package:imdb_app/models/tv/tv_model.dart';
import 'package:imdb_app/tv_widgets/similar_shows.dart';
import 'package:imdb_app/tv_widgets/tv_info.dart';

class TvDetailPage extends StatefulWidget {
  final Tv show;
  const TvDetailPage({super.key, required this.show});

  @override
  State<TvDetailPage> createState() => _TvDetailState();
}

class _TvDetailState extends State<TvDetailPage> {
  late Box<HiveTvModel> _tvWl;

  @override
  void initState() {
    super.initState();
    _tvWl = Hive.box<HiveTvModel>('tv_list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.show.name!,
          // style: mediumLargeText,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(children: [
        Column(
          children: [
            // Backdrop + Poster
            Stack(
              clipBehavior: Clip.none, // To make poster overflow
              children: [
                // Backdrop
                widget.show.backdrop == null
                    ? Container()
                    : Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                "https://image.tmdb.org/t/p/original${widget.show.backdrop!}",
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                // Poster, overflowing
                Positioned(
                  left: 15,
                  top: 190,
                  child: widget.show.poster == null
                      ? Container()
                      : Container(
                          height: 180,
                          width: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w200${widget.show.poster!}",
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                ),
              ],
            ),

            // TV info
            TvInfo(
              id: widget.show.id!,
              show: widget.show,
            ),
            const SizedBox(
              height: 10,
            ),

            // Similar shows
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SimilarShows(id: widget.show.id!),
            ),
            const SizedBox(
              height: 35,
            ),
          ],
        ),
      ]),

      // Add to Watch list floating button
      floatingActionButton: SizedBox(
        width: 150,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  HiveTvModel newVal = HiveTvModel(
                    id: widget.show.id!,
                    rating: widget.show.rating!,
                    name: widget.show.name!,
                    backDrop: widget.show.backdrop!,
                    poster: widget.show.poster!,
                    overview: widget.show.name!,
                  );
                  _tvWl.add(newVal);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Added ${widget.show.name} to Watch list",
                      overflow: TextOverflow.ellipsis,
                    ),
                    backgroundColor: textColor,
                    duration: Duration(seconds: 1),
                  ));
                });
              },
              backgroundColor: secondaryColor,
              splashColor: Colors.amber,
              label: const Text(
                "Add to watch list",
                style: TextStyle(color: scaffoldColor),
              )),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
