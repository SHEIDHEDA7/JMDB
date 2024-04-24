import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/tv/tv_model.dart';
import 'package:imdb_app/service/http_requests.dart';
import 'package:page_indicator/page_indicator.dart';

class NowPlayingTv extends StatefulWidget {
  const NowPlayingTv({super.key});

  @override
  State<NowPlayingTv> createState() => _NowPlayingTvState();
}

class _NowPlayingTvState extends State<NowPlayingTv> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TvModel>(
      future: HttpRequest.getTv("on_the_air"),
      builder: (context, AsyncSnapshot<TvModel> snapshot) {
        if (snapshot.hasData) {
          // If error data is returned
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _errorWidget(snapshot.data!.error);
          }
          return _nowPlayingTv(snapshot.data!);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingWidget();
        } else {
          return _errorWidget(snapshot.error);
        }
      },
    );
  }

  // All the widgets
  Widget _nowPlayingTv(TvModel data) {
    List<Tv>? shows = data.tv;

    if (shows!.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: const Text(
          "NO SHOWS FOUND",
          style: largeText,
        ),
      );
    }
    // Here using the page indicator for shows
    else {
      return SizedBox(
        height: 220,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          indicatorSpace: 8,
          indicatorSelectorColor: secondaryColor,
          indicatorColor: textColor,
          padding: const EdgeInsets.all(5),
          length: shows.take(5).length,
          shape: IndicatorShape.circle(size: 10),
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: shows.take(5).length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  // Image of Show
                  Container(
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://image.tmdb.org/t/p/original${shows[index].backdrop!}",
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
                  // Name of Show
                  Positioned(
                    bottom: 35,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        shows[index].name!,
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
