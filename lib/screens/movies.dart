import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/movie_widgets/display_genre.dart';
import 'package:imdb_app/movie_widgets/movie_widgets.dart';
import 'package:imdb_app/movie_widgets/now_playing.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        // Now Playing area
        NowPlaying(),
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
        DisplayMovieGenres(),

        // Top Rated area
        MovieWidget(
          request: "top_rated",
          title: "Top Rated",
          icon: Icons.star_outlined,
        ),

        // Popular area
        MovieWidget(
          request: "popular",
          title: "Popular",
          icon: Icons.trending_up_rounded,
        ),

        // Upcoming area
        MovieWidget(
          request: "upcoming",
          title: "Upcoming",
          icon: Icons.calendar_month_outlined,
        ),
      ],
    );
  }
}
