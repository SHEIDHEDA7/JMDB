class Trailer {
  String? id;
  String? key;
  String? site;
  String? type;
  String? name;
  Trailer({
    this.id,
    this.name,
    this.key,
    this.site,
    this.type,
  });

  factory Trailer.fromJson(Map<String, dynamic> json) => Trailer(
        id: json['id'],
        name: json['name'],
        key: json['key'],
        site: json['site'],
        type: json['type'],
      );
}

class TrailerModel {
  final List<Trailer>? trailers;
  final String? error;

  TrailerModel({this.trailers, this.error});

  factory TrailerModel.fromJson(Map<String, dynamic> json) => TrailerModel(
        trailers: (json['results'] as List)
            .map((trailer) => Trailer.fromJson(trailer))
            .toList(),
        error: "",
      );
  factory TrailerModel.withError(String error) => TrailerModel(
        trailers: [],
        error: error,
      );
}
