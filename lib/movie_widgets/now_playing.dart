import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/movie/movie_model.dart';
import 'package:imdb_app/service/http_requests.dart';
import 'package:page_indicator/page_indicator.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieModel>(
      future: HttpRequest.getMovie("now_playing"),
      builder: (context, AsyncSnapshot<MovieModel> snapshot) {
        if (snapshot.hasData) {
          // If error data is returned
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _errorWidget(snapshot.data!.error);
          }
          return _nowPlaying(snapshot.data!);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingWidget();
        } else {
          return _errorWidget(snapshot.error);
        }
      },
    );
  }

  // All the widgets
  Widget _nowPlaying(MovieModel data) {
    List<Movie>? movies = data.movies;

    if (movies!.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: const Text(
          "NO MOVIES FOUND",
          style: largeText,
        ),
      );
    }
    // Here using the page indicator show movies
    else {
      return SizedBox(
        height: 220,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          indicatorSpace: 8,
          indicatorSelectorColor: secondaryColor,
          indicatorColor: textColor,
          padding: const EdgeInsets.all(5),
          length: movies.take(5).length,
          shape: IndicatorShape.circle(size: 10),
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  // Image of movie
                  Container(
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://image.tmdb.org/t/p/original${movies[index].backdrop!}",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          scaffoldColor.withOpacity(0.5),
                          scaffoldColor.withOpacity(0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0, 0.9],
                      ),
                    ),
                  ),
                  // Name of movie
                  Positioned(
                    bottom: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        movies[index].title!,
                        style: mediumSmallText,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
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
