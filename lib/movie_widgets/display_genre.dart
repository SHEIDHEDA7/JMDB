import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/genre_model.dart';
import 'package:imdb_app/movie_widgets/get_genres.dart';
import 'package:imdb_app/service/http_requests.dart';

class DisplayMovieGenres extends StatefulWidget {
  const DisplayMovieGenres({super.key});

  @override
  State<DisplayMovieGenres> createState() => _DisplayMovieGenresState();
}

class _DisplayMovieGenresState extends State<DisplayMovieGenres> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GenreModel>(
      future: HttpRequest.getGenres("movie"),
      builder: (context, AsyncSnapshot<GenreModel> snapshot) {
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
  _genreRow(GenreModel data) {
    List<Genre>? genres = data.genres;

    if (genres!.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: const Text(
          "NO GENRES FOUND",
          style: mediumText,
        ),
      );
    } else {
      return GenreList(genres: genres);
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
