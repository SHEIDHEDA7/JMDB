import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imdb_app/constants.dart';
import 'package:imdb_app/models/hive_tv_model.dart';

class TvWL extends StatefulWidget {
  const TvWL({super.key});

  @override
  State<TvWL> createState() => _TvWLState();
}

class _TvWLState extends State<TvWL> {
  late Box<HiveTvModel> _tvWl;

  @override
  void initState() {
    super.initState();
    _tvWl = Hive.box<HiveTvModel>('tv_list');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _tvWl.isEmpty
          ? Center(
              child: Text(
                "No shows added to watch list",
                style: mediumText.copyWith(color: Color(0xFF586067)),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _tvWl.listenable(),
                    builder: (context, Box<HiveTvModel> item, _) {
                      List<int> keys =
                          item.keys.cast<int>().toList(); // Gets keys from hive
                      return ListView.builder(
                        itemCount: keys.length, // Number of items
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // Getting particular key
                          final key = keys[index];

                          // Getting key specific item
                          final HiveTvModel? _item = item.get(key);

                          // Single movie added
                          return GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5,
                              ),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    _item!.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle:
                                      Text(_item.rating.toStringAsFixed(1)),
                                  leading: Image(
                                    height: 100,
                                    image: NetworkImage(
                                        "https://image.tmdb.org/t/p/original${_item.poster}"),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _tvWl.deleteAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
