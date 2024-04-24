import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/tv/tv_model.dart';
import 'package:imdb_app/screens/tvshow_details.dart';
import 'package:imdb_app/service/http_requests.dart';

class TvWidget extends StatefulWidget {
  final String request;
  final String title;
  final IconData icon;
  const TvWidget({
    super.key,
    required this.request,
    required this.title,
    required this.icon,
  });

  @override
  State<TvWidget> createState() => _TvWidgetState();
}

class _TvWidgetState extends State<TvWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        Row(
          children: [
            Icon(
              widget.icon,
              color: secondaryColor,
              size: 25,
            ),
            const SizedBox(width: 5),
            Text(
              widget.title,
              style: mediumText,
            ),
          ],
        ),
        const SizedBox(height: 5),
        // Row of Shows
        FutureBuilder<TvModel>(
          future: HttpRequest.getTv(widget.request),
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

    // Show Container
    if (shows!.isEmpty) {
      return const SizedBox(
        child: Text(
          "NO MOVIES FOUND",
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
            // Shows
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
                        // Poster of Show
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
                    // Name of Show
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
