import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/genre_model.dart';
import 'package:imdb_app/tv_widgets/genre_shows.dart';

class GenreListTv extends StatefulWidget {
  final List<Genre> genres;
  const GenreListTv({super.key, required this.genres});

  @override
  State<GenreListTv> createState() => _GenreListTvState();
}

class _GenreListTvState extends State<GenreListTv>
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
    // TODO: implement dispose
    super.dispose();
    _tabController!.dispose();
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
                tabAlignment: TabAlignment.start,
                indicatorWeight: 2,
                unselectedLabelColor: textColor,
                labelColor: Colors.white,
                isScrollable: true,
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
              return GenreShows(genreId: genre.id!);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
