// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/trailer_model.dart';
import 'package:imdb_app/service/http_requests.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Trailers extends StatefulWidget {
  final String shows;
  final int id;
  const Trailers({
    super.key,
    required this.id,
    required this.shows,
  });

  @override
  State<Trailers> createState() => _TrailersState();
}

class _TrailersState extends State<Trailers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TrailerModel>(
        future: HttpRequest.getTrailer(widget.shows, widget.id),
        builder: (context, AsyncSnapshot<TrailerModel> snapshot) {
          if (snapshot.hasData) {
            // If error data is returned
            if (snapshot.data!.error != null &&
                snapshot.data!.error!.isNotEmpty) {
              return _errorWidget(snapshot.data!.error);
            }
            return _trailerWidget(snapshot.data!);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return _loadingWidget();
          } else {
            return _errorWidget(snapshot.error);
          }
        },
      ),
    );
  }

  _trailerWidget(TrailerModel data) {
    List<Trailer>? trailer = data.trailers;
    return Stack(
      children: [
        Center(
          child: YoutubePlayer(
            controller: YoutubePlayerController(
                initialVideoId: trailer![1].key!,
                flags: const YoutubePlayerFlags(
                  hideControls: false,
                  autoPlay: true,
                )),
          ),
        ),

        // Close button
        Positioned(
          top: 80,
          right: 10,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: textColor,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        )
      ],
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
    // print(error);
    return Center(
      child: Text("Something is wrong : $error"),
    );
  }
}
