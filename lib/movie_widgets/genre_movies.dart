import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/movie/movie_model.dart';
import 'package:imdb_app/screens/movie_details.dart';
import 'package:imdb_app/service/http_requests.dart';

class GenreMovie extends StatefulWidget {
  final int genreId;
  const GenreMovie({super.key, required this.genreId});

  @override
  State<GenreMovie> createState() => _GenreMovieState();
}

class _GenreMovieState extends State<GenreMovie> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieModel>(
      future: HttpRequest.discoverMovie(widget.genreId),
      builder: (context, AsyncSnapshot<MovieModel> snapshot) {
        if (snapshot.hasData) {
          // If error data is returned
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _errorWidget(snapshot.data!.error);
          }
          return _genreRow(snapshot.data!);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingWidget();
        } else {
          return _errorWidget(snapshot.error);
        }
      },
    );
  }

  // Widgets
  _genreRow(MovieModel data) {
    List<Movie>? movies = data.movies;

    if (movies!.isEmpty) {
      return const SizedBox(
        child: Text(
          "NO MOVIES FOUND",
          style: mediumText,
        ),
      );
    }
    // Movie Container
    else {
      return SizedBox(
        height: 250,
        child: ListView.builder(
          itemCount: movies.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MovieDetailPage(movie: movies[index])),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    movies[index].poster == null
                        ?
                        // If poster is not loaded
                        Container(
                            height: 180,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                                child: Icon(
                              Icons.videocam_off_outlined,
                              color: textColor,
                            )),
                          )
                        :
                        // Poster of Movie
                        Hero(
                            tag: movies[index].id!,
                            child: Container(
                              height: 180,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://image.tmdb.org/t/p/w200/${movies[index].poster!}"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Name of movie
                    SizedBox(
                      width: 100,
                      child: Text(
                        movies[index].title!,
                        style: mediumSmallText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Rating
                    Row(
                      children: [
                        // Star Icon
                        const Icon(
                          Icons.star_purple500_outlined,
                          color: secondaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        // Rating
                        Text(
                          movies[index].rating!.toStringAsFixed(1),
                          style: mediumSmallText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        color: textColor,
        strokeWidth: 4,
      ),
    );
  }

  _errorWidget(dynamic error) {
    return Center(
      child: Text("Something is wrong : $error"),
    );
  }
}
