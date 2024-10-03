import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:theater/models/Movie.dart';

late SharedPreferences prefs;

initPref() async {
  prefs = await SharedPreferences.getInstance();
}

List<Movie> getWatchhList() {
  final String? jsonString = prefs.getString('watchhList');

  if (jsonString != null) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => Movie.fromJson(json as Map<String, dynamic>))
        .toList();
  } else {
    return [];
  }
}

bool checkMovieInWatchList(String name) {
  final List<Movie> watchList = getWatchhList();
  var movie = watchList.firstWhere((element) => element.name == name,
      orElse: () => Movie(
          name: "No",
          description: "description",
          photo: "photo",
          language: "language",
          url: "url",
          duration: "duration",
          year: "year",
          isMovie: true));
  print(movie.name);
  if (movie.name == "No") {
    return false;
  } else {
    return true;
  }
}

Future<void> saveWatchhList(List<Movie> watchhList) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<Map<String, dynamic>> jsonList =
      watchhList.map((movie) => movie.toJson()).toList();
  final String jsonString = jsonEncode(jsonList);
  await prefs.setString('watchhList', jsonString);
}

Future<void> addToWatchhList(Movie movie) async {
  final List<Movie> watchhList = getWatchhList();
  // if (!watchhList.any((m) => m.name == movie.name)) {
  watchhList.add(movie);
  await saveWatchhList(watchhList);
  // } else {
  //   print("serieeee NOOOOOOOOOOOOOO " + watchhList.length.toString());
  // }
}

Future<void> removeFromWatchhList(Movie movie) async {
  final List<Movie> watchhList = getWatchhList();
  watchhList.removeWhere((e) => e.url == movie.url);
  await saveWatchhList(watchhList);
}
