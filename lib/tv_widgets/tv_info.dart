import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/tv/tv_detail_model.dart';
import 'package:imdb_app/models/tv/tv_model.dart';
import 'package:imdb_app/screens/trailers.dart';
import 'package:imdb_app/service/http_requests.dart';

class TvInfo extends StatefulWidget {
  final int id;
  final Tv show;
  const TvInfo({super.key, required this.id, required this.show});

  @override
  State<TvInfo> createState() => _TvInfoState();
}

class _TvInfoState extends State<TvInfo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TvDetailModel>(
      future: HttpRequest.tvDetails(widget.id),
      builder: (context, AsyncSnapshot<TvDetailModel> snapshot) {
        if (snapshot.hasData) {
          // If error data is returned
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _errorWidget(snapshot.data!.error);
          }
          return _infoWidget(snapshot.data!, context);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingWidget();
        } else {
          return _errorWidget(snapshot.error);
        }
      },
    );
  }

  _infoWidget(TvDetailModel data, BuildContext context) {
    TvDetails detail = data.details!;
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
                      detail.name!,
                      style: mediumText,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) =>
                              Trailers(id: widget.show.id!, shows: "tv"),
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

          // Episodes + Number of seasons + Air date
          const SizedBox(height: 30),
          Row(
            children: [
              // Episodes
              detailColumn("Episodes", detail.numberOfEpisodes.toString()),
              configWidth(valW, 0.1, 0),

              // Seasons
              detailColumn("Seasons", detail.numberOfSeasons.toString()),
              configWidth(valW, 0.1, 0),

              // Air date
              detailColumn("Air Date", detail.firstAirDate!),
            ],
          ),

          // Genre Row
          const SizedBox(height: 20),
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
                              color: Colors.white54,
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

          const SizedBox(height: 10),
          // Overview
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
