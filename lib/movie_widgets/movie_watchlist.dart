// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/hive_movie_model.dart';

class MovieWL extends StatefulWidget {
  const MovieWL({super.key});

  @override
  State<MovieWL> createState() => _MovieWLState();
}

class _MovieWLState extends State<MovieWL> {
  late Box<HiveMovieModel> _movieWl;

  @override
  void initState() {
    _movieWl = Hive.box<HiveMovieModel>('movie_list');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _movieWl.isEmpty
          ? Center(
              child: Text(
                "No movies added to watch list",
                style: mediumText.copyWith(color: const Color(0xFF586067)),
              ),
            )
          : ListView(children: [
              Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _movieWl.listenable(),
                    builder: (context, Box<HiveMovieModel> item, _) {
                      List<int> keys =
                          item.keys.cast<int>().toList(); // Gets keys from hive
                      return ListView.builder(
                        itemCount: keys.length, // Number of items
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // Getting particular key
                          final key = keys[index];

                          // Getting key specific item
                          final HiveMovieModel? _item = item.get(key);

                          // Single movie added
                          return GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5,
                              ),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    _item!.title,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle:
                                      Text(_item.rating.toStringAsFixed(1)),
                                  leading: Image(
                                    height: 200,
                                    image: NetworkImage(
                                        "https://image.tmdb.org/t/p/original${_item.poster}"),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _movieWl.deleteAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ]),
    );
  }
}
