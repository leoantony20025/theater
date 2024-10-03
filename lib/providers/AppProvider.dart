import 'package:flutter/material.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:theater/services/appService.dart';

class AppProvider extends ChangeNotifier {
  int? lang = 1;
  Map<String, List<Movie?>> currentContents = {};
  Map<String, List<Movie?>> latestContents = {};
  Map<String, List<Movie?>> tamilContents = {};
  Map<String, List<Movie?>> englishContents = {};
  Map<String, List<Movie?>> malayalamContents = {};
  Map<String, List<Movie?>> teluguContents = {};
  Map<String, List<Movie?>> kannadaContents = {};
  Map<String, List<Movie?>> hindiContents = {};

  AppProvider() {
    getAndSetLang();
    getAndsetContents();
  }

  void getAndSetLang() {
    lang = prefs.getInt("lang");
  }

  void getAndsetContents() async {
    tamilContents =
        tamilContents.isNotEmpty ? tamilContents : await fetchContents(1);
    englishContents =
        englishContents.isNotEmpty ? englishContents : await fetchContents(2);
    malayalamContents = malayalamContents.isNotEmpty
        ? malayalamContents
        : await fetchContents(3);
    teluguContents =
        teluguContents.isNotEmpty ? teluguContents : await fetchContents(4);
    kannadaContents =
        kannadaContents.isNotEmpty ? kannadaContents : await fetchContents(5);
    hindiContents =
        hindiContents.isNotEmpty ? hindiContents : await fetchContents(6);
    await getCurrentContents();
    latestContents = latestContents.isNotEmpty
        ? latestContents
        : await fetchLatestContents();
  }

  Future<Map<String, List<Movie?>>> getCurrentContents() async {
    if (lang == 1) {
      currentContents = tamilContents;
    } else if (lang == 2) {
      currentContents = englishContents;
    } else if (lang == 3) {
      currentContents = malayalamContents;
    } else if (lang == 4) {
      currentContents = teluguContents;
    } else if (lang == 5) {
      currentContents = kannadaContents;
    } else if (lang == 6) {
      currentContents = hindiContents;
    }
    notifyListeners();
    return currentContents;
  }

  void updateLang(int language) {
    prefs.setInt("lang", language);
    lang = language;
    getCurrentContents();
    notifyListeners();
  }

  void getLatestContents() async {
    latestContents = await fetchLatestContents();
    notifyListeners();
  }

  void getTamilContents() async {
    tamilContents = await fetchContents(1);
    notifyListeners();
  }

  void getEnglishContents() async {
    englishContents = await fetchContents(2);
    notifyListeners();
  }

  void getMalayalamContents() async {
    malayalamContents = await fetchContents(3);
    notifyListeners();
  }

  void getTeluguContents() async {
    teluguContents = await fetchContents(4);
    notifyListeners();
  }

  void getKannadaContents() async {
    kannadaContents = await fetchContents(5);
    notifyListeners();
  }

  void getHindiContents() async {
    hindiContents = await fetchContents(6);
    notifyListeners();
  }
}
