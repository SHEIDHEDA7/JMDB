// Here a particular Tv series detail is returned with its ID
import 'package:imdb_app/models/genre_model.dart';

class TvDetails {
  int? id;
  double? rating;
  int? runtime;
  int? numberOfEpisodes;
  int? numberOfSeasons;
  List<Genre>? genre;
  String? name;
  String? firstAirDate;
  String? backdrop;
  String? poster;
  String? overview;

  TvDetails({
    this.id,
    this.rating,
    this.runtime,
    this.genre,
    this.name,
    this.firstAirDate,
    this.numberOfEpisodes,
    this.numberOfSeasons,
    this.backdrop,
    this.poster,
    this.overview,
  });
  factory TvDetails.fromJson(Map<String, dynamic> json) => TvDetails(
        id: json["id"],
        rating: json["vote_average"].toDouble(),
        name: json["name"],
        backdrop: json["backdrop_path"],
        poster: json["poster_path"],
        overview: json["overview"],
        runtime: json['runtime'],
        genre: (json['genres'] as List)
            .map((genre) => Genre.fromJson(genre))
            .toList(),
        firstAirDate: json['first_air_date'],
        numberOfEpisodes: json['number_of_episodes'],
        numberOfSeasons: json['number_of_seasons'],
      );
}

class TvDetailModel {
  final TvDetails? details;
  final String? error;

  TvDetailModel({this.details, this.error});

  factory TvDetailModel.fromJson(Map<String, dynamic> json) => TvDetailModel(
        details: TvDetails.fromJson(json),
        error: "",
      );
  factory TvDetailModel.withError(String error) => TvDetailModel(
        details: TvDetails(),
        error: error,
      );
}
