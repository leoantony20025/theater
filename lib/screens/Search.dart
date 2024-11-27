import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/components/BannerSearch.dart';
import 'package:theater/components/HorizontalScrollList.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/providers/AppProvider.dart';
import 'package:theater/screens/Play.dart';
import 'package:theater/screens/PlayTV.dart';
import 'package:theater/services/appService.dart';
import 'package:provider/provider.dart';
import 'package:theater/utils/NoScrollBehavior.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  bool isError = false;
  String word = "";
  final ScrollController scrollController = ScrollController();
  bool isRequestSearch = false;
  late FocusNode fnSearch;
  List<Movie?> searchContents = [];
  late List<FocusNode> focusNodes;

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
    focusNodes = List.generate(50, (index) => FocusNode());
    fnSearch = FocusNode();
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    fnSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;

    final appProvider = Provider.of<AppProvider>(context, listen: true);
    Map<String, List<Movie?>> latestContents = appProvider.latestContents;
    if (latestContents['movies'] != null) {
      if (latestContents['movies']!.length > 20) {
        latestContents['movies']!.removeWhere((i) => i?.description == "d");
      }
    }

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

    search() async {
      setIsLoading(true);
      setState(() {
        isError = false;
      });
      List<Movie?>? content = await fetchSearchContents(word);
      if (content != null) {
        if (content.isNotEmpty) {
          setState(() {
            searchContents = content;
          });
        } else {
          setState(() {
            isError = true;
          });
        }
      } else {
        setState(() {
          isError = true;
        });
      }
      setIsLoading(false);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.topCenter,
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Focus(
                      focusNode: fnSearch,
                      onFocusChange: (isFocused) {
                        setState(() {
                          // isRequestSearch = isFocused;
                        });
                      },
                      onKeyEvent: (node, event) {
                        if (event is KeyDownEvent) {
                          if (event.logicalKey == LogicalKeyboardKey.select ||
                              event.logicalKey == LogicalKeyboardKey.enter) {
                            setState(() {
                              isRequestSearch = false;
                              word = textEditingController.text;
                            });
                            FocusScope.of(context).unfocus();
                            search();
                            return KeyEventResult.handled;
                          }
                          if (event.logicalKey == LogicalKeyboardKey.goBack) {
                            // setState(() {
                            //   isRequestSearch = false;
                            // });
                            fnSearch.unfocus();
                            return KeyEventResult.handled;
                          }
                        }
                        return KeyEventResult.ignored;
                      },
                      child: InkWell(
                        onTap: () {
                          fnSearch.requestFocus();
                          // SystemChannels.textInput.invokeMethod('TextInput.show');
                        },
                        child: const SizedBox(),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width:
                          isDesktop ? 300 : MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(30),
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: fnSearch.hasFocus
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                    Color.fromARGB(255, 51, 1, 92),
                                    Color.fromARGB(255, 48, 0, 63)
                                  ])
                            : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                    Color.fromARGB(176, 37, 0, 63),
                                    Color.fromARGB(175, 48, 0, 63)
                                  ]),
                        border: fnSearch.hasFocus
                            ? Border.all(
                                color: const Color.fromARGB(255, 134, 2, 190),
                                width: 2)
                            : Border.all(color: AppColors.bg1, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        maxLines: 1,
                        focusNode: fnSearch,
                        controller: textEditingController,
                        // canRequestFocus: isRequestSearch,
                        onEditingComplete: () {
                          setState(() {
                            isRequestSearch = false;
                            word = textEditingController.text;
                          });
                          FocusScope.of(context).unfocus();
                          search();
                        },
                        onSubmitted: (value) {
                          setState(() {
                            isRequestSearch = false;
                            word = textEditingController.text;
                          });
                          FocusScope.of(context).unfocus();
                          search();
                        },
                        onTap: () {
                          fnSearch.requestFocus();
                          setState(() {
                            isRequestSearch = true;
                          });
                        },
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Search movies...",
                          hintStyle: TextStyle(
                              color: Color.fromARGB(57, 158, 158, 158)),
                          contentPadding:
                              EdgeInsetsDirectional.symmetric(horizontal: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    !isError && latestContents.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Focus(
                                skipTraversal: true,
                                onFocusChange: (value) {
                                  if (value) {
                                    scrollToSection(0);
                                  }
                                },
                                child: latestContents.isNotEmpty ||
                                        searchContents.isNotEmpty
                                    ? BannerSearch(
                                        fetchContent: fetchContent,
                                        movie: searchContents.isNotEmpty
                                            ? searchContents[0]
                                            : latestContents['movies']![0],
                                      )
                                    : const SizedBox(),
                              ),
                              searchContents.isEmpty &
                                      latestContents['movies']!.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          child: Text(
                                            "Latest Movies",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                          ),
                                        ),
                                        HorizontalScrollList(
                                          currentContents:
                                              latestContents['movies']!,
                                          isLoading: isLoading,
                                          setIsLoading: setIsLoading,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              // searchContents.isEmpty & latestContents['series']!.isNotEmpty
                              //     ? Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           const Padding(
                              //             padding: EdgeInsets.symmetric(
                              //                 horizontal: 20, vertical: 20),
                              //             child: Text(
                              //               "Latest Series",
                              //               style: TextStyle(
                              //                   color: Colors.white,
                              //                   fontWeight: FontWeight.w500,
                              //                   fontSize: 20),
                              //             ),
                              //           ),
                              //           HorizontalScrollList(
                              //             currentContents: latestContents['series']!,
                              //             isLoading: isLoading,
                              //             setIsLoading: setIsLoading,
                              //           ),
                              //         ],
                              //       )
                              //     : const SizedBox(),
                              searchContents.isNotEmpty
                                  ? FocusTraversalGroup(
                                      policy: ReadingOrderTraversalPolicy(),
                                      child: Focus(
                                        skipTraversal: true,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 50),
                                          child: Wrap(
                                            spacing: 10,
                                            runSpacing: 10,
                                            children: searchContents
                                                .asMap()
                                                .entries
                                                .map((movie) {
                                              return Focus(
                                                canRequestFocus: true,
                                                focusNode:
                                                    focusNodes[movie.key],
                                                onFocusChange: (value) {
                                                  setState(() {});
                                                },
                                                child: InkWell(
                                                  canRequestFocus: true,
                                                  child: Container(
                                                    width:
                                                        isDesktop ? 240 : 150,
                                                    height:
                                                        isDesktop ? 300 : 200,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: focusNodes[
                                                                    movie.key]
                                                                .hasFocus
                                                            ? Border.all(
                                                                color: AppColors
                                                                    .borderTV,
                                                                width: 3)
                                                            : Border.all(
                                                                width: 0,
                                                                color: Colors
                                                                    .transparent)),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          movie.value?.photo ??
                                                              "",
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(20),
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      placeholder: (context,
                                                              url) =>
                                                          Shimmer.fromColors(
                                                        direction:
                                                            ShimmerDirection
                                                                .ltr,
                                                        enabled: true,
                                                        loop: 5,
                                                        baseColor: const Color
                                                            .fromARGB(
                                                            71, 224, 224, 224),
                                                        highlightColor:
                                                            const Color
                                                                .fromARGB(70,
                                                                245, 245, 245),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              1.7,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 0, 0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),

                              const SizedBox(
                                height: 100,
                              )
                            ],
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height - 200,
                            alignment: Alignment.center,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("lib/assets/images/wish.png"),
                                  const Text(
                                    "Found no movies!",
                                    style: TextStyle(color: Colors.white24),
                                  )
                                ]),
                          )
                  ],
                ),
              ),
            ),
          ),
          isLoading || latestContents.isEmpty
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Image.asset(
                        "lib/assets/images/loader.gif",
                        width: 100,
                      )),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
