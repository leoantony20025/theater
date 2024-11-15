import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/components/GradientText.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:theater/screens/Play.dart';
import 'package:theater/screens/PlayTV.dart';
import 'package:theater/services/appService.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  List<Movie> watchlist = getWatchhList();
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();
  var activeIndex = null;

  @override
  void initState() {
    super.initState();
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
      alignment: Alignment.topLeft,
      color: AppColors.bg2,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: watchlist.isNotEmpty
            ? isDesktop
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    // padding: const EdgeInsets.only(top: 30, left: 10),
                    alignment: Alignment.topLeft,

                    child: SingleChildScrollView(
                        child: Stack(alignment: Alignment.topRight, children: [
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
                        height: MediaQuery.of(context).size.height / 1.3,
                        decoration: BoxDecoration(
                            gradient: isDesktop
                                ? const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                        AppColors.bg2,
                                        AppColors.bg2,
                                        Color.fromARGB(27, 30, 0, 31),
                                      ])
                                : const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                        Color.fromARGB(162, 30, 0, 31),
                                        Color.fromARGB(140, 52, 0, 56),
                                        Color.fromARGB(193, 25, 0, 23),
                                        AppColors.bg2
                                      ])),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 1.3,
                        decoration: BoxDecoration(
                            gradient: isDesktop
                                ? const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                        AppColors.bg2,
                                        Color.fromARGB(217, 30, 0, 31),
                                        Color.fromARGB(0, 30, 0, 31),
                                      ])
                                : const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                        Color.fromARGB(162, 30, 0, 31),
                                        Color.fromARGB(140, 52, 0, 56),
                                        Color.fromARGB(233, 25, 0, 23),
                                        AppColors.bg2
                                      ])),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.3 + 5,
                        decoration: BoxDecoration(
                            gradient: isDesktop
                                ? const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                        Color.fromARGB(71, 17, 0, 17),
                                        AppColors.bg2,
                                      ])
                                : const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                        Color.fromARGB(0, 17, 0, 17),
                                        AppColors.bg2,
                                      ])),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 200,
                          ),
                          // const Text(
                          //   "Watchlist",
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 22,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 30,
                          // ),

                          Stack(
                            children: [
                              ScrollConfiguration(
                                behavior: const MaterialScrollBehavior(),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.only(
                                      bottom: 40, left: 20),
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: watchlist.map((movie) {
                                        // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                        // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                        // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                        // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                        // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                        // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                                        // aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

                                        int index = watchlist.indexOf(movie);
                                        return MouseRegion(
                                          onEnter: (event) {
                                            setState(() {
                                              activeIndex = index;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 300),
                                            // width: focusNodes[index].hasFocus
                                            //     ? (MediaQuery.of(context).size.width / 2)
                                            //     : (MediaQuery.of(context).size.width / 3) -
                                            //         50,
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3) -
                                                50,
                                            margin: EdgeInsets.only(
                                                right: 40,
                                                left: index == 0 ? 20 : 0),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                300,
                                            decoration: BoxDecoration(
                                              boxShadow: activeIndex == index
                                                  ? [
                                                      const BoxShadow(
                                                          color: Color.fromARGB(
                                                              255, 36, 0, 36),
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
                                                  alignment:
                                                      Alignment.topCenter),
                                            ),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              padding: const EdgeInsets.all(30),
                                              alignment: Alignment.bottomCenter,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(35)),
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
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
                                                  ),
                                                  SizedBox(
                                                    height: activeIndex == index
                                                        ? 180
                                                        : 0,
                                                    child: Column(
                                                      children: [
                                                        AnimatedContainer(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 15),
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          decoration:
                                                              BoxDecoration(
                                                                  boxShadow:
                                                                      activeIndex ==
                                                                              index
                                                                          ? [
                                                                              const BoxShadow(blurRadius: 50, blurStyle: BlurStyle.normal, spreadRadius: 2, color: Color.fromARGB(65, 222, 0, 238))
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
                                                          child: InkWell(
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
                                                              height: 70,
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
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
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
                                                                        17,
                                                                    horizontal:
                                                                        20),
                                                            decoration: const BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            25)),
                                                                color: Color
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
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
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
                                    height: MediaQuery.of(context).size.height -
                                        200,
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
                      isLoading
                          ? BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.transparent,
                                child: const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 146, 0, 159),
                                ),
                              ),
                            )
                          : const SizedBox()
                    ])),
                  )
                : Container(
                    padding: const EdgeInsets.only(
                        top: 30, left: 20, bottom: 0, right: 20),
                    width: MediaQuery.of(context).size.width,
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
                        Wrap(
                          runSpacing: isDesktop ? 50 : 20,
                          spacing: isDesktop ? 50 : 20,
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: watchlist.map((movie) {
                            return SizedBox(
                              width: isDesktop
                                  ? 350
                                  : (MediaQuery.of(context).size.width / 2) -
                                      30,
                              height: 250,
                              child: Stack(children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    width: isDesktop
                                        ? 350
                                        : (MediaQuery.of(context).size.width /
                                                2) -
                                            30,
                                    height: 250,
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
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          gradient: LinearGradient(
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await removeFromWatchhList(movie);
                                    List<Movie> updatedWishlist =
                                        getWatchhList();
                                    setState(() {
                                      watchlist = updatedWishlist;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      margin: const EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          color: const Color.fromARGB(
                                              95, 29, 0, 33),
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 48, 0, 62),
                                              width: 1)),
                                      child: const Icon(
                                        Icons.delete_outline_rounded,
                                        color:
                                            Color.fromARGB(87, 249, 131, 255),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                            );
                          }).toList(),
                        ),
                      ],
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
                      style:
                          TextStyle(color: Color.fromARGB(75, 235, 199, 255)),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
