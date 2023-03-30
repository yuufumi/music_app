import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
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

final player = AudioPlayer();
void playsound(String url) async {
  try {
    player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    //player.play();
  } on Exception {
    log("Error parsing song");
    // TODO
  }
}

class Sample extends StatelessWidget {
  const Sample();
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
        height: 100,
        width: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade500,
                  offset: Offset(4, 4),
                  blurRadius: 15,
                  spreadRadius: 1),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 5,
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              "1",
              style: GoogleFonts.oxygen(
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const VerticalDivider(
              width: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.grey,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Title of sample",
                  style: GoogleFonts.oxygen(
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Text(
                  "Song category - duration",
                  style: GoogleFonts.oxygen(
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w200)),
                ),
              ],
            ),
            MaterialButton(
              onPressed: () {
                playsound("ohgihiu");
              },
              elevation: 0.5,
              height: 60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: Icon(
                Icons.play_circle_fill_rounded,
                size: 60,
                color: Colors.cyan[900],
              ),
            )
          ],
        ));
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
                    future: _audioQuery.querySongs(
                      sortType: null,
                      orderType: OrderType.ASC_OR_SMALLER,
                      uriType: UriType.EXTERNAL,
                      ignoreCase: true,
                    ),
                    builder: (context, item) {
                      if (item.data == null)
                        return const CircularProgressIndicator();
                      if (item.data!.isEmpty)
                        return const Text("Nothing found!");
                      return ListView.builder(
                        itemCount: item.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
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
                          );
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
