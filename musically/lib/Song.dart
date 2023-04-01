import "package:flutter/material.dart";
import "package:just_audio/just_audio.dart";
import "package:musically/main.dart";
import "package:on_audio_query/on_audio_query.dart";
import "new_box.dart";
import 'package:google_fonts/google_fonts.dart';
import "package:percent_indicator/linear_percent_indicator.dart";

class Song extends StatefulWidget {
  Sample model;
  Song({required this.model});
  @override
  State<Song> createState() => _SongState();
}

class _SongState extends State<Song> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    playsound(widget.model.model.uri.toString(), _audioPlayer);
    _audioPlayer.play();
    widget.model.playing = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(children: [
        // app bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 70, 20, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _audioPlayer.pause();
                  Navigator.pop(context);
                },
                child: neuBox(
                  child: Container(
                    child: Icon(Icons.arrow_back_ios_new_rounded),
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
              Text(
                "P L A Y L I S T",
                style: GoogleFonts.oxygen(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ),
              GestureDetector(
                onTap: () {},
                child: neuBox(
                  child: Container(
                    child: Icon(Icons.menu_rounded),
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
            ],
          ),
        ),

        // image
        Container(
          child: neuBox(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 230,
                      width: 280,
                      child: QueryArtworkWidget(
                        id: widget.model.model.id,
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 200,
                              child: Text(
                                widget.model.model.title,
                                overflow: TextOverflow.ellipsis,
                              )),
                          Text(widget.model.model.artist.toString()),
                        ],
                      ),
                      Icon(Icons.favorite_border_rounded)
                    ],
                  ),
                )
              ],
            ),
          ),
          width: 300,
          height: 300,
        ),
        SizedBox(height: 25),

        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("00:00"),
                Icon(Icons.shuffle),
                Icon(Icons.repeat),
                Text("04:22"),
              ],
            ),
            SizedBox(height: 25),
            //process bar
            neuBox(
              child: Container(
                width: 340,
                height: 20,
                child: LinearPercentIndicator(
                  lineHeight: 10,
                  percent: 0.8,
                  backgroundColor: Colors.transparent,
                  barRadius: Radius.circular(8),
                  progressColor: Colors.pink,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 50),
        // pause previous next buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Expanded(
                    child: Container(
                      child: neuBox(
                        child: Icon(Icons.skip_previous_rounded, size: 40),
                      ),
                      height: 100,
                      width: 70,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.model.playing = !widget.model.playing;
                    });
                    widget.model.playing
                        ? _audioPlayer.play()
                        : _audioPlayer.pause();
                  },
                  child: Expanded(
                    child: Container(
                      child: neuBox(
                        child: Icon(
                            widget.model.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 40),
                      ),
                      height: 100,
                      width: 160,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Expanded(
                    child: Container(
                      child: neuBox(
                        child: Icon(Icons.skip_next_rounded, size: 40),
                      ),
                      height: 100,
                      width: 70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
