import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/genre_model.dart';
import 'package:imdb_app/movie_widgets/genre_movies.dart';

class GenreList extends StatefulWidget {
  final List<Genre> genres;
  const GenreList({super.key, required this.genres});

  @override
  State<GenreList> createState() => _GenreListState();
}

class _GenreListState extends State<GenreList>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.genres.length, vsync: this);
    _tabController!.addListener(() {});
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var valH = MediaQuery.of(context).size.height;
    return SizedBox(
      height: valH * 0.35,
      child: DefaultTabController(
        length: widget.genres.length,
        child: Scaffold(
          // Genre list which is horizontally scrollable
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: AppBar(
              bottom: TabBar(
                controller: _tabController,
                labelPadding: const EdgeInsets.all(7),
                indicatorColor: secondaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                tabAlignment: TabAlignment.start,
                unselectedLabelColor: textColor,
                labelColor: Colors.white,
                isScrollable: true,
                // labelPadding: EdgeInsets.all(),
                tabs: widget.genres.map((Genre genre) {
                  return Text(
                    genre.name!.toUpperCase(),
                    style:
                        mediumSmallText.copyWith(fontWeight: FontWeight.bold),
                  );
                }).toList(),
              ),
            ),
          ),
          // Movies based on Genre
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.genres.map((Genre genre) {
              return GenreMovie(genreId: genre.id!);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
