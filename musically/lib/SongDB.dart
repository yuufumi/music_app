import 'package:on_audio_query/on_audio_query.dart';
import 'dart:async';

final OnAudioQuery _audioQuery = OnAudioQuery();
Future<List<SongModel>> songs = _audioQuery.querySongs(
  sortType: null,
  orderType: OrderType.ASC_OR_SMALLER,
  uriType: UriType.EXTERNAL,
  ignoreCase: true,
);
