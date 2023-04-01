import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musically/new_box.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import "Song.dart";
import 'dart:async';
import "SongDB.dart";
import 'dart:developer';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
          useMaterial3: true,
        ),
        home: const AllSongsPage());
  }
}

class Playlist extends StatelessWidget {
  const Playlist();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          height: 130,
          width: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[400],
          ),
        ),
      ],
    ));
    ;
  }
}

//final player = AudioPlayer();
void playsound(String url, AudioPlayer player) async {
  try {
    player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    //player.play();
  } on Exception {
    log("Error parsing song");
    // TODO
  }
}

AudioPlayer player = AudioPlayer();

class Sample extends StatelessWidget {
  SongModel model;
  bool playing = false;
  int id;
  AudioPlayer player;
  Sample({required this.model, required this.id, required this.player});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Song(
                      model: this,
                    )));
      },
      child: Column(
        children: [
          neuBox(
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                height: 80,
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      this.id.toString(),
                      style: GoogleFonts.oxygen(
                          textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink)),
                    ),
                    const VerticalDivider(
                      width: 20,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                      color: Colors.pink,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            model.title,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: GoogleFonts.oxygen(
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "${model.artist}  - ${model.duration}",
                            style: GoogleFonts.oxygen(
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w200)),
                          ),
                        ),
                      ],
                    ),
                    MaterialButton(
                      onPressed: () {
                        playing = !playing;
                        playsound(model.uri.toString(), player);
                        print(playing);
                        playing ? player.play() : player.pause();
                      },
                      elevation: 0.5,
                      height: 60,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: Icon(
                        playing
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_fill_rounded,
                        size: 60,
                        color: Colors.pink,
                      ),
                    )
                  ],
                )),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class AllSongsPage extends StatefulWidget {
  const AllSongsPage();

  @override
  State<AllSongsPage> createState() => _AllSongsPageState();
}

class _AllSongsPageState extends State<AllSongsPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _playing = false;

  void _isPlaying() {
    setState(() {
      _playing = !_playing;
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Musically",
          style: GoogleFonts.oxygen(
              textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Icon(
              Icons.notifications_outlined,
              size: 32,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // recently played list
          SizedBox(height: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "Playlists",
                  style: GoogleFonts.oxygen(
                    textStyle:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                ),
                Icon(
                  Icons.add_box_rounded,
                  size: 26,
                )
              ]),
              SizedBox(height: 30),
              Container(
                height: 150,
                child: ListView.builder(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: ((context, index) => Playlist())),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "Your Songs",
                  style: GoogleFonts.oxygen(
                      textStyle:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                ),
                Icon(Icons.sort_rounded, size: 26)
              ]),
              SizedBox(height: 26),
              Container(
                height: 373,
                child: FutureBuilder<List<SongModel>>(
                    future: songs,
                    /*_audioQuery.querySongs(
                      sortType: null,
                      orderType: OrderType.ASC_OR_SMALLER,
                      uriType: UriType.EXTERNAL,
                      ignoreCase: true,
                    ),*/
                    builder: (context, item) {
                      if (item.data == null)
                        return const CircularProgressIndicator();
                      if (item.data!.isEmpty)
                        return const Text("Nothing found!");
                      return ListView.builder(
                        itemCount: item.data!.length,
                        itemBuilder: (context, index) {
                          return Sample(
                            model: item.data![index],
                            id: index + 1,
                            player: player,
                          ) /*ListTile(
                            title: Text(item.data![index].title),
                            subtitle:
                                Text(item.data![index].artist ?? "No Artist"),
                            trailing: GestureDetector(
                              onTap: () {
                                playsound(item.data![index].uri.toString());
                                setState(() {
                                  _playing = !_playing;
                                });
                                _playing ? player.play() : player.pause();
                              },
                              child: Icon(
                                _playing
                                    ? Icons.pause
                                    : Icons.play_arrow_rounded,
                                size: 30,
                              ),
                            ),
                            // This Widget will query/load image. Just add the id and type.
                            // You can use/create your own widget/method using [queryArtwork].
                            leading: QueryArtworkWidget(
                              id: item.data![index].id,
                              type: ArtworkType.AUDIO,
                            ),
                          )*/
                              ;
                        },
                      );
                    }),
              ),
            ],
          ),

          //playlists list

          //For you list
        ]),
      ),
    );
  }
}
