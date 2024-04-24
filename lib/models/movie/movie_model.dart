// In general all the movies
class Movie {
  int? id;
  double? rating;
  String? title;
  String? backdrop; // Back poster
  String? poster;
  String? overview;

  Movie({
    this.id,
    this.rating,
    this.title,
    this.backdrop,
    this.poster,
    this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"],
        rating: json["vote_average"].toDouble(),
        title: json["title"],
        backdrop: json["backdrop_path"],
        poster: json["poster_path"],
        overview: json["oveview"],
      );
}

class MovieModel {
  final List<Movie>? movies;
  final String? error;
  MovieModel({this.error, this.movies});

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        movies: (json["results"] as List) // Converting the results into list
            .map((data) => Movie.fromJson(data))
            .toList(),
        error: "",
      );
  // In case error is returned
  factory MovieModel.withError(String error) => MovieModel(
        movies: [],
        error: error,
      );
}
