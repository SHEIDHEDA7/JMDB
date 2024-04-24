// Here a particular movie detail is returned with its ID
import 'package:imdb_app/models/genre_model.dart';

class MovieDetails {
  int? id;
  double? rating;
  int? runtime;
  List<Genre>? genre;
  String? title;
  String? releaseDate;
  String? backdrop;
  String? poster;
  String? overview;
  MovieDetails({
    this.id,
    this.rating,
    this.runtime,
    this.genre,
    this.title,
    this.releaseDate,
    this.backdrop,
    this.poster,
    this.overview,
  });
  factory MovieDetails.fromJson(Map<String, dynamic> json) => MovieDetails(
        id: json["id"],
        rating: json["vote_average"].toDouble(),
        title: json["title"],
        backdrop: json["backdrop_path"],
        poster: json["poster_path"],
        overview: json["overview"],
        runtime: json['runtime'],
        genre: (json['genres'] as List)
            .map((genre) => Genre.fromJson(genre))
            .toList(),
        releaseDate: json['release_date'],
      );
}

class MovieDetailModel {
  final MovieDetails? details;
  final String? error;

  MovieDetailModel({this.details, this.error});

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      MovieDetailModel(
        details: MovieDetails.fromJson(json),
        error: "",
      );
  factory MovieDetailModel.withError(String error) => MovieDetailModel(
        details: MovieDetails(),
        error: error,
      );
}
