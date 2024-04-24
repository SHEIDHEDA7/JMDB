import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/tv/tv_model.dart';
import 'package:imdb_app/screens/tvshow_details.dart';
import 'package:imdb_app/service/http_requests.dart';

class SimilarShows extends StatefulWidget {
  final int id;
  const SimilarShows({super.key, required this.id});

  @override
  State<SimilarShows> createState() => _SimilarShowsState();
}

class _SimilarShowsState extends State<SimilarShows> {
  @override
  Widget build(BuildContext context) {
    // Row of movies
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          "Similar Shows",
          style: mediumText,
        ),
        // Row of movies
        FutureBuilder<TvModel>(
          future: HttpRequest.getSimilarTvs(widget.id),
          builder: (context, AsyncSnapshot<TvModel> snapshot) {
            if (snapshot.hasData) {
              // If error data is returned
              if (snapshot.data!.error != null &&
                  snapshot.data!.error!.isNotEmpty) {
                return _errorWidget(snapshot.data!.error);
              }
              return _buildWidget(snapshot.data!);
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return _loadingWidget();
            } else {
              return _errorWidget(snapshot.error);
            }
          },
        ),
      ],
    );
  }

  _buildWidget(TvModel data) {
    List<Tv>? shows = data.tv;

    // Movie Container
    if (shows!.isEmpty) {
      return const SizedBox(
        child: Text(
          "NO SHOWS FOUND",
          style: mediumText,
        ),
      );
    } else {
      return SizedBox(
        height: 260,
        child: ListView.builder(
          itemCount: shows.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => TvDetailPage(show: shows[index])),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shows[index].poster == null
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
                        Container(
                            height: 180,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://image.tmdb.org/t/p/w200/${shows[index].poster!}"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Name of movie
                    SizedBox(
                      width: 100,
                      child: Text(
                        shows[index].name!,
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
                          shows[index].rating!.toStringAsFixed(1),
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
