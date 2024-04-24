// ignore_for_file: constant_identifier_names
import 'package:dio/dio.dart';
import 'package:imdb_app/models/genre_model.dart';
import 'package:imdb_app/models/movie/movie_detail_model.dart';
import 'package:imdb_app/models/movie/movie_model.dart';
import 'package:imdb_app/models/trailer_model.dart';
import 'package:imdb_app/models/tv/tv_detail_model.dart';
import 'package:imdb_app/models/tv/tv_model.dart';

class HttpRequest {
  static const String apiKey = "04bf30f6ade39247ceeed6a558540c98";
  static final Dio dio = Dio();
  static const String mainUrl = "https://api.themoviedb.org/3";
  static const String genreUrl = "$mainUrl/genre";
  static const String discoverUrl = "$mainUrl/discover";
  static const String MovieUrl = "$mainUrl/movie";
  static const String tvUrl = "$mainUrl/tv";

  // Getting genres
  // Show indicates either Movie or Tv
  static Future<GenreModel> getGenres(String show) async {
    var params = {
      "api_key": apiKey,
      "langauge": "en-us",
      "page": 1,
    };
    try {
      Response response =
          await dio.get('$genreUrl/$show/list', queryParameters: params);
      return GenreModel.fromJson(response.data);
    } catch (error) {
      return GenreModel.withError("$error");
    }
  }

  // Getting trailer
  static Future<TrailerModel> getTrailer(String show, int id) async {
    var params = {
      "api_key": apiKey,
      "langauge": "en-us",
      "page": 1,
    };
    try {
      Response response =
          await dio.get('$mainUrl/$show/$id/videos', queryParameters: params);
      return TrailerModel.fromJson(response.data);
    } catch (error) {
      return TrailerModel.withError("$error");
    }
  }

  // Getting similar movies
  static Future<MovieModel> getSimilarMovies(int id) async {
    var params = {
      "api_key": apiKey,
      "langauge": "en-us",
      "page": 1,
    };
    try {
      Response response =
          await dio.get('$MovieUrl/$id/similar', queryParameters: params);
      return MovieModel.fromJson(response.data);
    } catch (error) {
      return MovieModel.withError("$error");
    }
  }

  // Getting similar tv shows
  static Future<TvModel> getSimilarTvs(int id) async {
    var params = {
      "api_key": apiKey,
      "langauge": "en-us",
      "page": 1,
    };
    try {
      Response response =
          await dio.get('$tvUrl/$id/similar', queryParameters: params);
      return TvModel.fromJson(response.data);
    } catch (error) {
      return TvModel.withError("$error");
    }
  }

  // Discover movies
  static Future<MovieModel> discoverMovie(int id) async {
    var params = {
      "api_key": apiKey,
      "langauge": "en-us",
      "page": 1,
      "with_genres": id,
    };
    try {
      Response response =
          await dio.get('$discoverUrl/movie', queryParameters: params);
      return MovieModel.fromJson(response.data);
    } catch (error) {
      return MovieModel.withError("$error");
    }
  }

  // Discover Series
  static Future<TvModel> discoverTv(int id) async {
    var params = {
      "api_key": apiKey,
      "langauge": "en-us",
      "page": 1,
      "with_genres": id,
    };
    try {
      Response response =
          await dio.get('$discoverUrl/tv', queryParameters: params);
      return TvModel.fromJson(response.data);
    } catch (error) {
      return TvModel.withError("$error");
    }
  }

  // Get particular movie details
  static Future<MovieDetailModel> movieDetails(int id) async {
    var params = {
      "api_key": apiKey,
      "langauge": "en-us",
    };
    try {
      Response response =
          await dio.get('$MovieUrl/$id', queryParameters: params);
      return MovieDetailModel.fromJson(response.data);
    } catch (error) {
      return MovieDetailModel.withError("$error");
    }
  }

  // Get particular tv show details
  static Future<TvDetailModel> tvDetails(int id) async {
    var params = {
      "api_key": apiKey,
      "langauge": "en-us",
    };
    try {
      Response response = await dio.get('$tvUrl/$id', queryParameters: params);
      return TvDetailModel.fromJson(response.data);
    } catch (error) {
      return TvDetailModel.withError("$error");
    }
  }

  // Other functionalities such as now playing, most popular, top rated, upcoming based on request
  // Movie
  static Future<MovieModel> getMovie(String request) async {
    var params = {
      "api_key": apiKey,
      "langauge": "en-us",
    };
    try {
      Response response =
          await dio.get('$MovieUrl/$request', queryParameters: params);
      return MovieModel.fromJson(response.data);
    } catch (error) {
      return MovieModel.withError("$error");
    }
  }

  // Tv shows
  static Future<TvModel> getTv(String request) async {
    var params = {
      "api_key": apiKey,
      "langauge": "en-us",
    };
    try {
      Response response =
          await dio.get('$tvUrl/$request', queryParameters: params);
      return TvModel.fromJson(response.data);
    } catch (error) {
      return TvModel.withError("$error");
    }
  }
}
