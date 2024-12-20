import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:theater/screens/Play.dart';
import 'package:theater/screens/PlaySeriesTV.dart';
import 'package:theater/screens/PlayTV.dart';
import 'package:theater/services/appService.dart';
import 'package:theater/utils/NoScrollBehavior.dart';

class HorizontalScrollList extends StatefulWidget {
  List<Movie?> currentContents;
  bool isLoading;
  final Function(bool) setIsLoading;

  HorizontalScrollList(
      {super.key,
      required this.currentContents,
      required this.isLoading,
      required this.setIsLoading});

  @override
  State<HorizontalScrollList> createState() => _HorizontalScrollListState();
}

class _HorizontalScrollListState extends State<HorizontalScrollList> {
  int? activeIndex;
  late List<FocusNode> list1FocusNodes;
  final ScrollController scrollController = ScrollController();

  moveLeft() {
    scrollController.jumpTo(
      scrollController.offset - 200,
    );
  }

  moveRight() {
    scrollController.jumpTo(
      scrollController.offset + 200,
    );
  }

  @override
  void initState() {
    super.initState();
    list1FocusNodes = List.generate(50, (index) => FocusNode());
  }

  @override
  void dispose() {
    super.dispose();
    for (var node in list1FocusNodes) {
      node.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;
    bool isTV =
        screenWidth > 800 && defaultTargetPlatform == TargetPlatform.android;

    fetchContent(Movie movie) async {
      widget.setIsLoading(true);
      Map<String, dynamic> content = movie.isMovie
          ? await fetchMovieContent(movie.url)
          : await fetchSeriesContent(movie.url);
      var data = {
        'name': movie.name,
        'desc': movie.description,
        'photo': movie.photo,
        'url': movie.url,
        'year': movie.year,
        'duration': movie.duration,
        'language': movie.language,
        ...content
      };
      widget.setIsLoading(false);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => movie.isMovie
              ? isTV
                  ? PlayTV(
                      content: data,
                    )
                  : Play(
                      content: data,
                    )
              : PlaySeriesTV(
                  content: data,
                )));
    }

    return Stack(children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ScrollConfiguration(
          behavior: NoScrollBehavior(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Row(
                children:
                    widget.currentContents.asMap().entries.map<Widget>((entry) {
                  Movie? movie = entry.value;
                  int index = entry.key;
                  movie?.description = movie.description.trimLeft();
                  bool isWatchList = checkMovieInWatchList(movie?.name ?? "");

                  return movie?.photo != ""
                      ? Focus(
                          onKeyEvent: (node, event) {
                            if (event is KeyDownEvent) {
                              if (event.logicalKey ==
                                  LogicalKeyboardKey.arrowLeft) {
                                moveLeft();
                                list1FocusNodes[index - 1].requestFocus();
                                return KeyEventResult.handled;
                              }
                              if (event.logicalKey ==
                                  LogicalKeyboardKey.arrowRight) {
                                if (!scrollController.position.outOfRange) {
                                  moveRight();
                                  list1FocusNodes[index + 1].requestFocus();
                                }
                                return KeyEventResult.handled;
                              }
                            }
                            return KeyEventResult.ignored;
                          },
                          child: InkWell(
                            focusNode: list1FocusNodes[index],
                            onFocusChange: (value) {
                              setState(() {});
                            },
                            // autofocus: index == 0 ? true : false,
                            onTap: () {
                              fetchContent(movie!);
                            },
                            child: MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  activeIndex = index;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  activeIndex = null;
                                });
                              },
                              onHover: (event) {
                                setState(() {
                                  activeIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.only(right: 20),
                                margin:
                                    EdgeInsets.only(left: index == 0 ? 15 : 0),
                                width: list1FocusNodes[index].hasFocus ||
                                        activeIndex == index
                                    ? isDesktop
                                        ? 500
                                        : 300
                                    : isDesktop
                                        ? 200
                                        : 150,
                                height: isDesktop ? 270 : 200,
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: movie?.photo ?? "",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        direction: ShimmerDirection.ltr,
                                        enabled: true,
                                        loop: 5,
                                        baseColor: const Color.fromARGB(
                                            71, 224, 224, 224),
                                        highlightColor: const Color.fromARGB(
                                            70, 245, 245, 245),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.7,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                    if (list1FocusNodes[index].hasFocus ||
                                        activeIndex == index)
                                      Positioned(
                                        bottom: 0,
                                        width:
                                            list1FocusNodes[index].hasFocus ||
                                                    activeIndex == index
                                                ? isDesktop
                                                    ? 480
                                                    : 280
                                                : isDesktop
                                                    ? 200
                                                    : 150,
                                        height: isDesktop ? 270 : 200,
                                        child: Container(
                                          alignment: Alignment.bottomLeft,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              border: Border.all(
                                                  color: AppColors.borderTV,
                                                  width: 3),
                                              gradient: const LinearGradient(
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 34, 0, 39),
                                                    Color.fromARGB(
                                                        219, 34, 0, 39),
                                                    Color.fromARGB(
                                                        166, 32, 0, 32)
                                                  ])),
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: isDesktop ? 350 : 250,
                                                child: Text(
                                                  movie?.name ?? "",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        isDesktop ? 20 : 16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                width: isDesktop ? 350 : 250,
                                                padding:
                                                    const EdgeInsets.only(),
                                                child: Text(
                                                  movie?.description ?? "",
                                                  style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              181,
                                                              255,
                                                              255,
                                                              255),
                                                      fontSize:
                                                          isDesktop ? 15 : 12,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    movie?.year ?? "",
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 128, 128, 128),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  const Text(
                                                    "•",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 128, 128, 128),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  Text(
                                                    movie?.duration ?? "",
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 128, 128, 128),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  const Text(
                                                    "•",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 128, 128, 128),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  Text(
                                                    movie?.language ?? "",
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 128, 128, 128),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              defaultTargetPlatform ==
                                                      TargetPlatform.windows
                                                  ? Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (movie?.url !=
                                                                null) {
                                                              await fetchContent(
                                                                  movie!);
                                                            }
                                                          },
                                                          child: Container(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 13,
                                                                  horizontal:
                                                                      13),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          const BorderRadius.all(Radius.circular(
                                                                              50)),
                                                                      border:
                                                                          Border
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
                                                                      color: const Color.fromARGB(
                                                                          113,
                                                                          59,
                                                                          0,
                                                                          67)),
                                                              child: const HugeIcon(
                                                                  icon: HugeIcons
                                                                      .strokeRoundedPlay,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          163,
                                                                          0,
                                                                          175))),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        !isWatchList
                                                            ? GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  await addToWatchhList(
                                                                      movie!);
                                                                  setState(() {
                                                                    isWatchList =
                                                                        true;
                                                                  });
                                                                },
                                                                child: Container(
                                                                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                                        border: Border.all(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              52,
                                                                              137,
                                                                              0,
                                                                              158),
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        color: const Color.fromARGB(113, 59, 0, 67)),
                                                                    child: const HugeIcon(icon: HugeIcons.strokeRoundedPlayListAdd, color: Color.fromARGB(255, 163, 0, 175))),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    )
                                                  : const SizedBox()
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox();
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      Positioned(
          left: 0,
          child: Container(
            width: 120,
            height: 280,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [AppColors.bg2, Colors.transparent])),
          )),
    ]);
  }
}
