import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/tv/tv_model.dart';
import 'package:imdb_app/screens/tvshow_details.dart';
import 'package:imdb_app/service/http_requests.dart';

class GenreShows extends StatefulWidget {
  final int genreId;
  const GenreShows({super.key, required this.genreId});

  @override
  State<GenreShows> createState() => _GenreShowsState();
}

class _GenreShowsState extends State<GenreShows> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TvModel>(
      future: HttpRequest.discoverTv(widget.genreId),
      builder: (context, AsyncSnapshot<TvModel> snapshot) {
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
  _genreRow(TvModel data) {
    List<Tv>? shows = data.tv;

    if (shows!.isEmpty) {
      return const SizedBox(
        child: Text(
          "NO SHOWS FOUND",
          style: mediumText,
        ),
      );
    }
    // Movie Container
    else {
      return SizedBox(
        height: 250,
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
