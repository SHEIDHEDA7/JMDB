// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/hive_movie_model.dart';
import 'package:imdb_app/models/movie/movie_model.dart';
import 'package:imdb_app/movie_widgets/movie_info.dart';
import 'package:imdb_app/movie_widgets/similar_movies.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;
  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Box<HiveMovieModel> _movieWl;

  @override
  void initState() {
    _movieWl = Hive.box<HiveMovieModel>('movie_list');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movie.title!,
          // style: mediumLargeText,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              // Backdrop + Poster
              Stack(
                clipBehavior: Clip.none, // To make poster overflow
                children: [
                  // Backdrop
                  widget.movie.backdrop ==
                          null // If any movie doesnt have backdrop show container
                      ? Container()
                      : Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original${widget.movie.backdrop!}",
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                  // Poster, overflowing
                  Positioned(
                    left: 15,
                    top: 190,
                    child: widget.movie.backdrop == null
                        ? Container()
                        : Container(
                            height: 180,
                            width: 120,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w200${widget.movie.poster!}",
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                  ),
                ],
              ),

              // Movie Info
              MovieInfo(
                id: widget.movie.id!,
                movie: widget.movie,
              ),

              const SizedBox(
                height: 10,
              ),
              // Similar movies
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SimilarMovies(id: widget.movie.id!),
              ),
              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ],
      ),

      // Add to Watch list floating button
      floatingActionButton: SizedBox(
        width: 150,
        height: 60,
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                HiveMovieModel newVal = HiveMovieModel(
                  id: widget.movie.id!,
                  rating: widget.movie.rating!,
                  title: widget.movie.title!,
                  backDrop: widget.movie.backdrop!,
                  poster: widget.movie.poster!,
                  overview: widget.movie.title!,
                );
                _movieWl.add(newVal);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Added ${widget.movie.title} to Watch list",
                    overflow: TextOverflow.ellipsis,
                  ),
                  backgroundColor: textColor,
                  duration: const Duration(milliseconds: 900),
                ));
              });
            },
            backgroundColor: secondaryColor,
            splashColor: Colors.blueGrey.shade300,
            label: const Text("Add to Watch List"),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      //
    );
  }
}
