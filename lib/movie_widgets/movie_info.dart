import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/movie/movie_detail_model.dart';
import 'package:imdb_app/models/movie/movie_model.dart';
import 'package:imdb_app/screens/trailers.dart';
import 'package:imdb_app/service/http_requests.dart';

class MovieInfo extends StatefulWidget {
  final int id;
  final Movie movie;
  const MovieInfo({super.key, required this.id, required this.movie});

  @override
  State<MovieInfo> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieDetailModel>(
      future: HttpRequest.movieDetails(widget.id),
      builder: (context, AsyncSnapshot<MovieDetailModel> snapshot) {
        if (snapshot.hasData) {
          // If error data is returned
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _errorWidget(snapshot.data!.error);
          }
          return _infoWidget(snapshot.data!);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingWidget();
        } else {
          return _errorWidget(snapshot.error);
        }
      },
    );
  }

  _infoWidget(MovieDetailModel data) {
    MovieDetails detail = data.details!;
    var valW = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          // Top compartment
          const SizedBox(height: 20),
          Row(
            children: [
              // Left space
              configWidth(valW, 0.35, 0),

              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title area
                  SizedBox(
                    width: 200,
                    child: Text(
                      detail.title!,
                      style: mediumSmallText,
                      overflow: TextOverflow.clip,
                    ),
                  ),

                  // Rating area
                  Row(
                    children: [
                      const Text(
                        "Rating: ",
                        style: mediumText,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        detail.rating!.toStringAsFixed(1),
                        style: largeText.copyWith(fontSize: 40),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.star_outlined,
                        color: secondaryColor,
                        size: 40,
                      ),
                    ],
                  ),

                  // Watch trailer
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // print(widget.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) =>
                              Trailers(id: widget.movie.id!, shows: "movie"),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: valW * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red.shade300,
                      ),
                      child: const Center(
                        child: Text("Watch Trailer"),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),

          // Release Date + Duration
          const SizedBox(height: 30),
          Row(
            children: [
              // Release Date
              detailColumn("Duration", "${detail.runtime.toString()} mins"),

              configWidth(valW, 0.2, 0),
              // Duration
              detailColumn("Release Date", "${detail.releaseDate}"),
            ],
          ),

          // Genre Row
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Genres:",
                  style: mediumText,
                ),
                Container(
                  height: 35,
                  padding: const EdgeInsets.only(top: 3.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: detail.genre!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.white30,
                            ),
                          ),
                          child: Text(
                            detail.genre![index].name!,
                            style: mediumSmallText.copyWith(
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),

          // Overview
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: itemColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Overview:",
                    style: mediumText,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("${detail.overview}")
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
