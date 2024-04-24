// In general all the movies
class Tv {
  int? id;
  double? rating;
  String? name;
  String? backdrop; // Back poster
  String? poster;
  String? overview;

  Tv({
    this.id,
    this.rating,
    this.name,
    this.backdrop,
    this.poster,
    this.overview,
  });

  factory Tv.fromJson(Map<String, dynamic> json) => Tv(
        id: json["id"],
        rating: json["vote_average"].toDouble(),
        name: json["name"],
        backdrop: json["backdrop_path"],
        poster: json["poster_path"],
        overview: json["oveview"],
      );
}

class TvModel {
  final List<Tv>? tv;
  final String? error;
  TvModel({this.error, this.tv});

  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
        tv: (json["results"] as List) // Converting the results into list
            .map((data) => Tv.fromJson(data))
            .toList(),
        error: "",
      );
  // In case error is returned
  factory TvModel.withError(String error) => TvModel(
        tv: [],
        error: error,
      );
}
