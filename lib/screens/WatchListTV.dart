import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:theater/screens/Play.dart';
import 'package:theater/screens/PlayTV.dart';
import 'package:theater/services/appService.dart';

class WatchListTV extends StatefulWidget {
  const WatchListTV({super.key});

  @override
  State<WatchListTV> createState() => _WatchListTVState();
}

class _WatchListTVState extends State<WatchListTV> {
  List<Movie> watchlist = getWatchhList();
  late List<FocusNode> focusNodes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(watchlist.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;

    void setIsLoading(bool load) {
      setState(() {
        isLoading = load;
      });
    }

    fetchContent(Movie movie) async {
      setIsLoading(true);
      Map<String, dynamic> content = await fetchMovieContent(movie.url);
      setIsLoading(false);
      if (isDesktop) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => defaultTargetPlatform == TargetPlatform.android
              ? PlayTV(
                  content: {
                    'name': movie.name,
                    'desc': movie.description,
                    'photo': movie.photo,
                    'url': movie.url,
                    'year': movie.year,
                    'duration': movie.duration,
                    'language': movie.language,
                    ...content
                  },
                )
              : Play(
                  content: {
                    'name': movie.name,
                    'desc': movie.description,
                    'photo': movie.photo,
                    'url': movie.url,
                    'year': movie.year,
                    'duration': movie.duration,
                    'language': movie.language,
                    ...content
                  },
                ),
        ));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Play(
            content: {
              'name': movie.name,
              'desc': movie.description,
              'photo': movie.photo,
              'url': movie.url,
              'year': movie.year,
              'duration': movie.duration,
              'language': movie.language,
              ...content
            },
          ),
        ));
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(top: 30, left: 20, bottom: 0, right: 20),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: isDesktop ? Alignment.centerLeft : Alignment.topCenter,
              end: isDesktop ? Alignment.centerRight : Alignment.bottomCenter,
              colors: const [Color.fromARGB(255, 17, 0, 17), Colors.black])),
      child: Stack(children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Watchlist",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              watchlist.isNotEmpty
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          // runSpacing: isDesktop ? 30 : 20,
                          // spacing: isDesktop ? 30 : 20,
                          // alignment: WrapAlignment.center,
                          // runAlignment: WrapAlignment.center,
                          // crossAxisAlignment: WrapCrossAlignment.center,
                          children: watchlist.map((movie) {
                            int index = watchlist.indexOf(movie);
                            return Container(
                              width:
                                  (MediaQuery.of(context).size.width / 3) - 50,
                              height: 400,
                              margin: EdgeInsets.only(right: 40),
                              child: Stack(children: [
                                Focus(
                                  focusNode: focusNodes[index],
                                  onFocusChange: (value) {
                                    setState(() {});
                                  },
                                  child: InkWell(
                                    onTap: () {
                                      fetchContent(movie);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  3) -
                                              50,
                                      height: 400,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                            image: NetworkImage(movie.photo),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter),
                                      ),
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        decoration: BoxDecoration(
                                            border: focusNodes[index].hasFocus
                                                ? Border.all(
                                                    color: AppColors.borderTV,
                                                    width: 3)
                                                : Border.all(
                                                    color: const Color.fromARGB(
                                                        0, 0, 0, 0),
                                                    width: 0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                            gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color.fromARGB(70, 66, 0, 97),
                                                  Color.fromARGB(255, 19, 0, 21)
                                                ])),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        isDesktop ? 300 : 100,
                                                    child: Text(
                                                      movie.name,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        movie.language,
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    73,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontSize: 10),
                                                      ),
                                                      const SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        movie.year,
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    73,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 200,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "lib/assets/images/wish.png",
                            opacity: const AlwaysStoppedAnimation(.8),
                          ),
                          const Text(
                            "Add movies to your watchlist",
                            style: TextStyle(
                                color: Color.fromARGB(75, 235, 199, 255)),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
        isLoading
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: const CircularProgressIndicator(
                    color: Color.fromARGB(255, 146, 0, 159),
                  ),
                ),
              )
            : const SizedBox()
      ]),
    );
  }
}
