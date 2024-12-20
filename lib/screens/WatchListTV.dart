import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/components/GradientText.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:theater/screens/Play.dart';
import 'package:theater/screens/PlayTV.dart';
import 'package:theater/services/appService.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

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
  var activeIndex = null;

  void scrollToSection(double offset) {
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  moveLeft() {
    scrollController.animateTo(scrollController.offset - 150,
        curve: Curves.easeInOut, duration: const Duration(milliseconds: 300));
  }

  moveRight() {
    scrollController.animateTo(scrollController.offset + 150,
        curve: Curves.easeInOut, duration: const Duration(milliseconds: 300));
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
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
            Color.fromARGB(255, 17, 0, 17),
            Color.fromARGB(255, 17, 0, 17),
          ])),
      child: Focus(
        skipTraversal: true,
        child: SingleChildScrollView(
            child: watchlist.isNotEmpty
                ? Stack(alignment: Alignment.topRight, children: [
                    activeIndex != null
                        ? CachedNetworkImage(
                            imageUrl: watchlist[activeIndex].photo,
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 1.3,
                            fit: BoxFit.fitWidth,
                            // alignment: Alignment.topRight,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor:
                                  const Color.fromARGB(71, 224, 224, 224),
                              highlightColor:
                                  const Color.fromARGB(70, 245, 245, 245),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height / 1.7,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                            AppColors.bg2,
                            AppColors.bg2,
                            AppColors.bg2t,
                          ])),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                            AppColors.bg2,
                            Color.fromARGB(195, 13, 0, 19),
                            AppColors.bg2t,
                          ])),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            AppColors.bg2t,
                            Color.fromARGB(242, 13, 0, 19),
                            AppColors.bg2,
                          ])),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              ScrollConfiguration(
                                behavior: const MaterialScrollBehavior(),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.only(
                                      bottom: 40, left: 20),
                                  scrollDirection: Axis.horizontal,
                                  child: FocusTraversalGroup(
                                    policy: OrderedTraversalPolicy(),
                                    child: Row(
                                      children: watchlist.map((movie) {
                                        int index = watchlist.indexOf(movie);
                                        return AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3) -
                                              50,
                                          margin: EdgeInsets.only(
                                              right: 40,
                                              left: index == 0 ? 20 : 0),
                                          height: 380,
                                          decoration: BoxDecoration(
                                            boxShadow: focusNodes[index]
                                                        .hasFocus ||
                                                    fnRemove[index].hasFocus
                                                ? [
                                                    const BoxShadow(
                                                        color: Color.fromARGB(
                                                            56, 36, 0, 36),
                                                        blurRadius: 30,
                                                        offset: Offset(4, 10))
                                                  ]
                                                : [],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(35)),
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(movie.photo),
                                                fit: BoxFit.cover,
                                                alignment: Alignment.topCenter),
                                          ),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            padding: const EdgeInsets.all(15),
                                            alignment: Alignment.bottomCenter,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(35)),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Color.fromARGB(
                                                          70, 66, 0, 97),
                                                      Color.fromARGB(
                                                          114, 19, 0, 21),
                                                      Color.fromARGB(
                                                          255, 19, 0, 21)
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
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      movie.language,
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
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
                                                          color: Color.fromARGB(
                                                              73,
                                                              255,
                                                              255,
                                                              255),
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: focusNodes[index]
                                                              .hasFocus ||
                                                          fnRemove[index]
                                                              .hasFocus
                                                      ? 130
                                                      : 0,
                                                  child: Column(
                                                    children: [
                                                      AnimatedContainer(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: focusNodes[
                                                                            index]
                                                                        .hasFocus
                                                                    ? Border
                                                                        .all(
                                                                        color: AppColors
                                                                            .borderTV,
                                                                        width:
                                                                            2.0,
                                                                      )
                                                                    : Border
                                                                        .all(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            0.0,
                                                                      ),
                                                                boxShadow: focusNodes[
                                                                            index]
                                                                        .hasFocus
                                                                    ? [
                                                                        const BoxShadow(
                                                                            blurRadius:
                                                                                30,
                                                                            blurStyle: BlurStyle
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
                                                                        .all(
                                                                        Radius.circular(
                                                                            25)),
                                                                gradient: const LinearGradient(
                                                                    begin: Alignment
                                                                        .topLeft,
                                                                    end: Alignment.bottomRight,
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
                                                        child: Focus(
                                                          onKeyEvent:
                                                              (node, event) {
                                                            if (event
                                                                is KeyDownEvent) {
                                                              // if (event.logicalKey == LogicalKeyboardKey.select ||
                                                              //     event.logicalKey == LogicalKeyboardKey.enter) {
                                                              //   return KeyEventResult.handled;
                                                              // }
                                                              if (event
                                                                      .logicalKey ==
                                                                  LogicalKeyboardKey
                                                                      .arrowLeft) {
                                                                // if (!scrollController
                                                                //     .position
                                                                //     .outOfRange) {
                                                                moveLeft();
                                                                focusNodes[
                                                                        index -
                                                                            1]
                                                                    .requestFocus();
                                                                // }
                                                                return KeyEventResult
                                                                    .handled;
                                                              }
                                                              if (event
                                                                      .logicalKey ==
                                                                  LogicalKeyboardKey
                                                                      .arrowRight) {
                                                                if (!scrollController
                                                                    .position
                                                                    .outOfRange) {
                                                                  moveRight();
                                                                  focusNodes[
                                                                          index +
                                                                              1]
                                                                      .requestFocus();
                                                                }
                                                                return KeyEventResult
                                                                    .handled;
                                                              }
                                                            }
                                                            return KeyEventResult
                                                                .ignored;
                                                          },
                                                          child: InkWell(
                                                            key: const Key(
                                                                "watch"),
                                                            focusNode:
                                                                focusNodes[
                                                                    index],
                                                            autofocus: true,
                                                            onFocusChange:
                                                                (value) {
                                                              setState(() {
                                                                activeIndex =
                                                                    index;
                                                              });
                                                              // scrollToSection(
                                                              //     scrollController
                                                              //             .offset +
                                                              //         30);
                                                              // if (focusNodes[index]
                                                              //     .hasFocus) {
                                                              //   if (index == 0) {
                                                              //     scrollToSection(
                                                              //         0);
                                                              //   }
                                                              //   if (index ==
                                                              //       watchlist
                                                              //               .length -
                                                              //           1) {
                                                              //     scrollToSection(
                                                              //         scrollController
                                                              //                 .offset +
                                                              //             30);
                                                              //   }
                                                              //   // scrollToSection(0);
                                                              // }
                                                              setState(() {});
                                                            },
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            25)),
                                                            onTap: () {
                                                              fetchContent(
                                                                  movie);
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
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
                                                                    end: Alignment.bottomRight,
                                                                    colors: [
                                                                      Color.fromARGB(
                                                                          255,
                                                                          254,
                                                                          245,
                                                                          255),
                                                                      Color.fromARGB(
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
                                                        key:
                                                            const Key("remove"),
                                                        focusNode:
                                                            fnRemove[index],
                                                        onFocusChange: (value) {
                                                          setState(() {});
                                                        },
                                                        child: InkWell(
                                                          onTap: () async {
                                                            await removeFromWatchhList(
                                                                movie);
                                                            setState(() {
                                                              watchlist =
                                                                  getWatchhList();
                                                            });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        13,
                                                                    horizontal:
                                                                        13),
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            25)),
                                                                    border: fnRemove[index]
                                                                            .hasFocus
                                                                        ? Border
                                                                            .all(
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                173,
                                                                                0,
                                                                                226),
                                                                            width:
                                                                                2,
                                                                          )
                                                                        : Border
                                                                            .all(
                                                                            color: const Color.fromARGB(
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
                                                                      color: Color.fromARGB(
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
                                    height: 380,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                      AppColors.bg2,
                                      Color.fromARGB(0, 17, 0, 17),
                                    ])),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                    isLoading
                        ? BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                alignment: Alignment.center,
                                color: Colors.transparent,
                                child: Image.asset(
                                  "lib/assets/images/loader.gif",
                                  width: 100,
                                )),
                          )
                        : const SizedBox()
                  ])
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
                  )),
      ),
    );
  }
}
