// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/screens/movies.dart';
import 'package:imdb_app/screens/tvshows.dart';
import 'package:imdb_app/screens/watchlist.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Index of page
  int _curIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Page change controller
    PageController _controller = PageController();

    // Animation of page
    void onTap(int index) {
      _controller.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }

    // For dimensions
    var val = MediaQuery.of(context).size.width;

    // Scaffold
    return Scaffold(
      // Appbar
      appBar: _curIndex != 3
          ? AppBar(
              // backgroundColor: Colors.transparent,
              title: _dynamicAppBar(_curIndex),
            )
          : null,

      // Page view
      body: PageView(
        // scrollDirection: Axis.vertical,
        controller: _controller,
        children: const [
          MovieScreen(),
          TvScreen(),
          WatchListScreen(),
        ],
        onPageChanged: (value) {
          setState(() {
            _curIndex = value;
          });
        },
      ),
      // Bottom nav bar
      bottomNavigationBar: Container(
        color: itemColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: val * 0.05),
          child: GNav(
            onTabChange: onTap,
            selectedIndex: _curIndex,
            color: textColor,
            activeColor: secondaryColor,
            iconSize: 30,
            gap: 8,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            tabs: const [
              GButton(
                icon: Icons.movie_creation_outlined,
                text: "Movies",
              ),
              GButton(
                icon: Icons.tv,
                text: "Shows",
              ),
              GButton(
                icon: Icons.list,
                text: "Watch List",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Appbar name changes depending on page
_dynamicAppBar(int index) {
  switch (index) {
    case 0:
      return const Text("M O V I E S");
    case 1:
      return const Text("T V    S H O W S");
    default:
      return const Text("");
  }
}

// Widget _contentWidget(MovieModel? movies) {
//   return Container(
//     child: Center(
//       child: Text(""
//           // "${movies?.movies![0].title}",
//           // style: mediumText,
//           ),
//     ),
//   );
// }
