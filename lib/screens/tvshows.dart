import 'package:flutter/material.dart';
import 'package:imdb_app/tv_widgets/display_genres.dart';
import 'package:imdb_app/tv_widgets/now_playing_tv.dart';
import 'package:imdb_app/tv_widgets/tv_widget.dart';

import '../constants.dart';

class TvScreen extends StatefulWidget {
  const TvScreen({super.key});

  @override
  State<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        // Now playing
        NowPlayingTv(),
        SizedBox(
          height: 5,
        ),

        // Genre List
        Row(
          children: [
            Icon(
              Icons.blur_on_sharp,
              color: secondaryColor,
              size: 25,
            ),
            Text(
              "Browse By Genre",
              style: mediumText,
            )
          ],
        ),
        DisplayTvGenre(),

        // Top rated
        TvWidget(
          request: "top_rated",
          title: "Top Rated",
          icon: Icons.star_outlined,
        ),

        // Popular
        TvWidget(
          request: "popular",
          title: "Popular",
          icon: Icons.trending_up_rounded,
        ),

        // Upcoming
        TvWidget(
          request: "on_the_air",
          title: "Airing in a week",
          icon: Icons.calendar_month_outlined,
        ),
      ],
    );
  }
}
