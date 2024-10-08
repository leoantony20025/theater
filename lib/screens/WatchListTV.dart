import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/components/GradientText.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:theater/screens/Play.dart';
import 'package:theater/screens/PlayTV.dart';
import 'package:theater/services/appService.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:theater/utils/NoScrollBehavior.dart';

class WatchListTV extends StatefulWidget {
  const WatchListTV({super.key});

  @override
  State<WatchListTV> createState() => _WatchListTVState();
}

class _WatchListTVState extends State<WatchListTV> {
  List<Movie> watchlist = getWatchhList();
  late List<FocusNode> focusNodes;
  late List<FocusNode> fnRemove;
  late FocusNode fnWatch;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();

  void scrollToSection(double offset) {
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(watchlist.length, (_) => FocusNode());
    fnRemove = List.generate(watchlist.length, (_) => FocusNode());
    fnWatch = FocusNode();
  }

  @override
  void dispose() {
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    for (var focusNode in fnRemove) {
      focusNode.dispose();
    }
    fnWatch.dispose();
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
      // padding: const EdgeInsets.only(top: 30, left: 10),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: isDesktop ? Alignment.centerLeft : Alignment.topCenter,
              end: isDesktop ? Alignment.centerRight : Alignment.bottomCenter,
              colors: const [Color.fromARGB(255, 17, 0, 17), Colors.black])),
      child: Focus(
        skipTraversal: true,
        child: SingleChildScrollView(
          child: Stack(children: [
            Column(
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
                    ? Stack(
                        children: [
                          ScrollConfiguration(
                            behavior: NoScrollBehavior(),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              padding:
                                  const EdgeInsets.only(bottom: 40, left: 20),
                              scrollDirection: Axis.horizontal,
                              child: FocusTraversalGroup(
                                policy: OrderedTraversalPolicy(),
                                child: Row(
                                  children: watchlist.map((movie) {
                                    // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                    // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                    // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                    // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                    // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                    // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                    // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

                                    int index = watchlist.indexOf(movie);
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      // width: focusNodes[index].hasFocus
                                      //     ? (MediaQuery.of(context).size.width / 2)
                                      //     : (MediaQuery.of(context).size.width / 3) -
                                      //         50,
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  3) -
                                              50,
                                      margin: EdgeInsets.only(
                                          right: 40, left: index == 0 ? 20 : 0),
                                      height: 400,
                                      decoration: BoxDecoration(
                                        boxShadow: focusNodes[index].hasFocus ||
                                                fnRemove[index].hasFocus
                                            ? [
                                                const BoxShadow(
                                                    color: Color.fromARGB(
                                                        255, 36, 0, 36),
                                                    blurRadius: 30,
                                                    offset: Offset(4, 10))
                                              ]
                                            : [],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(35)),
                                        image: DecorationImage(
                                            image: NetworkImage(movie.photo),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter),
                                      ),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        padding: const EdgeInsets.all(15),
                                        alignment: Alignment.bottomCenter,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(35)),
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color.fromARGB(70, 66, 0, 97),
                                                  Color.fromARGB(
                                                      114, 19, 0, 21),
                                                  Color.fromARGB(255, 19, 0, 21)
                                                ])),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: isDesktop ? 300 : 100,
                                              child: Text(
                                                movie.name,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  movie.language,
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          73, 255, 255, 255),
                                                      fontSize: 10),
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  movie.year,
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          73, 255, 255, 255),
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: focusNodes[index]
                                                          .hasFocus ||
                                                      fnRemove[index].hasFocus
                                                  ? 130
                                                  : 0,
                                              child: Column(
                                                children: [
                                                  AnimatedContainer(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    decoration: BoxDecoration(
                                                        border: focusNodes[
                                                                    index]
                                                                .hasFocus
                                                            ? Border.all(
                                                                color: AppColors
                                                                    .borderTV,
                                                                width: 2.0,
                                                              )
                                                            : Border.all(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 0.0,
                                                              ),
                                                        boxShadow:
                                                            focusNodes[index]
                                                                    .hasFocus
                                                                ? [
                                                                    const BoxShadow(
                                                                        blurRadius:
                                                                            50,
                                                                        blurStyle:
                                                                            BlurStyle
                                                                                .normal,
                                                                        spreadRadius:
                                                                            2,
                                                                        color: Color.fromARGB(
                                                                            65,
                                                                            222,
                                                                            0,
                                                                            238))
                                                                  ]
                                                                : [],
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(Radius
                                                                    .circular(
                                                                        25)),
                                                        gradient:
                                                            const LinearGradient(
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                                colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  158,
                                                                  0,
                                                                  164),
                                                              Color.fromARGB(
                                                                  255,
                                                                  48,
                                                                  0,
                                                                  63)
                                                            ])),
                                                    child: Material(
                                                      color:
                                                          const Color.fromARGB(
                                                              0, 0, 0, 0),
                                                      child: InkWell(
                                                        key: const Key("watch"),
                                                        focusNode:
                                                            focusNodes[index],
                                                        autofocus: true,
                                                        onFocusChange: (value) {
                                                          if (focusNodes[index]
                                                              .hasFocus) {
                                                            // scrollToSection(0);
                                                          }
                                                          setState(() {});
                                                        },
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    25)),
                                                        onTap: () {
                                                          fetchContent(movie);
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 50,
                                                          color: Colors
                                                              .transparent,
                                                          child:
                                                              const GradientText(
                                                            "Watch Now",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                                colors: [
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          254,
                                                                          245,
                                                                          255),
                                                                  Color
                                                                      .fromARGB(
                                                                          153,
                                                                          120,
                                                                          82,
                                                                          125)
                                                                ]),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Focus(
                                                    key: const Key("remove"),
                                                    focusNode: fnRemove[index],
                                                    onFocusChange: (value) {
                                                      setState(() {});
                                                    },
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await removeFromWatchhList(
                                                            movie);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 13,
                                                                horizontal: 13),
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            25)),
                                                                border: fnRemove[
                                                                            index]
                                                                        .hasFocus
                                                                    ? Border
                                                                        .all(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            173,
                                                                            0,
                                                                            226),
                                                                        width:
                                                                            2,
                                                                      )
                                                                    : Border
                                                                        .all(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            52,
                                                                            137,
                                                                            0,
                                                                            158),
                                                                        width:
                                                                            1,
                                                                      ),
                                                                color: const Color
                                                                    .fromARGB(
                                                                    70,
                                                                    83,
                                                                    2,
                                                                    117)),
                                                        child: const Row(
                                                          children: [
                                                            HugeIcon(
                                                                icon: HugeIcons
                                                                    .strokeRoundedPlayListRemove,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        140,
                                                                        0,
                                                                        175)),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "Remove from Watchlist",
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          140,
                                                                          0,
                                                                          175)),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              left: 0,
                              child: Container(
                                width: 120,
                                height: 480,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                  AppColors.bg2,
                                  Colors.transparent
                                ])),
                              )),
                        ],
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
        ),
      ),
    );
  }
}
