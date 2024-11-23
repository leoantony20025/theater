import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/providers/AppProvider.dart';
import 'package:provider/provider.dart';
import 'package:theater/screens/Play.dart';
import 'package:theater/screens/PlayTV.dart';
import 'package:theater/services/appService.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:theater/utils/NoScrollBehavior.dart';

class AllMovies extends StatefulWidget {
  const AllMovies({super.key});

  @override
  State<AllMovies> createState() => _AllMoviesState();
}

class _AllMoviesState extends State<AllMovies> {
  late List<FocusNode> focusNodes;
  late FocusNode fnBackButton;
  int offset = 2;
  List<Movie?>? allMovies = [];
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool isMoreLoading = false;
  int lang = 0;

  Future loadMoreData() async {
    int existingLength = allMovies!.length;
    setState(() {
      isMoreLoading = true;
    });
    List<Movie> movies = await loadMoreMovies(offset, lang);
    setState(() {
      allMovies = [...?allMovies, ...movies];
      focusNodes = List.generate(allMovies!.length, (index) => FocusNode());
      focusNodes[existingLength - 1].requestFocus();
      offset += 1;
      isMoreLoading = false;
    });
  }

  void scrollToSection(double offset) {
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  moveTop() {
    scrollController.animateTo(scrollController.offset - 150,
        curve: Curves.easeInOut, duration: const Duration(milliseconds: 300));
  }

  moveDown() {
    scrollController.animateTo(scrollController.offset + 150,
        curve: Curves.easeInOut, duration: const Duration(milliseconds: 300));
  }

  @override
  void initState() {
    focusNodes = List.generate(50, (index) => FocusNode());
    fnBackButton = FocusNode();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMoreData();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    fnBackButton.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: true);
    List<Movie?>? movies = appProvider.currentContents['movies'];
    lang = appProvider.lang!;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;

    if (offset == 2) {
      setState(() {
        allMovies = movies;
      });
    }

    fetchContent(Movie movie) async {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> content = await fetchMovieContent(movie.url);
      setState(() {
        isLoading = false;
      });
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

    return Scaffold(
      body: FocusTraversalGroup(
        policy: ReadingOrderTraversalPolicy(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 16, 0, 43),
                      Color.fromARGB(255, 29, 0, 36)
                    ]),
              ),
              child: Scrollbar(
                controller: scrollController,
                trackVisibility: false,
                thumbVisibility: false,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onFocusChange: (value) {
                              if (value) {
                                scrollToSection(0);
                              }
                            },
                            focusNode: fnBackButton,
                            focusColor: Colors.white,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.all(isDesktop ? 40 : 20),
                              decoration: BoxDecoration(
                                border: fnBackButton.hasFocus
                                    ? Border.all(
                                        width: 2, color: AppColors.borderTV)
                                    : Border.all(
                                        width: 0, color: Colors.transparent),
                                color: const Color.fromARGB(23, 200, 0, 210),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                              ),
                              child: const HugeIcon(
                                  icon: HugeIcons.strokeRoundedArrowLeft01,
                                  color: Color.fromARGB(255, 240, 108, 255)),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "All Movies",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Wrap(
                          children: allMovies!.asMap().entries.map((movie) {
                            return Focus(
                              focusNode: focusNodes[movie.key],
                              onFocusChange: (value) {
                                setState(() {});
                              },
                              child: InkWell(
                                onTap: () {
                                  fetchContent(movie.value!);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: !isDesktop
                                      ? 150
                                      : focusNodes[movie.key].hasFocus
                                          ? 260
                                          : 240,
                                  margin: EdgeInsets.all(!isDesktop
                                      ? 7
                                      : focusNodes[movie.key].hasFocus
                                          ? 10
                                          : 20),
                                  height: !isDesktop
                                      ? 200
                                      : focusNodes[movie.key].hasFocus
                                          ? 320
                                          : 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: focusNodes[movie.key].hasFocus
                                          ? [
                                              const BoxShadow(
                                                  blurRadius: 60,
                                                  offset: Offset(-10, -20),
                                                  spreadRadius: -5,
                                                  color: Color.fromARGB(
                                                      183, 44, 1, 104)),
                                              const BoxShadow(
                                                  blurRadius: 60,
                                                  offset: Offset(10, 20),
                                                  spreadRadius: -5,
                                                  color: Color.fromARGB(
                                                      184, 66, 1, 101))
                                            ]
                                          : [],
                                      border: focusNodes[movie.key].hasFocus
                                          ? Border.all(
                                              color: const Color.fromARGB(
                                                  255, 64, 1, 131),
                                              width: 0)
                                          : Border.all(
                                              width: 0,
                                              color: Colors.transparent)),
                                  child: CachedNetworkImage(
                                    imageUrl: movie.value?.photo ?? "",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            opacity:
                                                focusNodes[movie.key].hasFocus
                                                    ? 1
                                                    : 0.7),
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
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.7,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      isMoreLoading
                          ? Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(
                                "lib/assets/images/loader.gif",
                                width: 100,
                              ),
                            )
                          : const SizedBox(
                              height: 100,
                            ),
                      Focus(
                          onFocusChange: (value) {
                            setState(() {});
                          },
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            isLoading
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
      ),
    );
  }
}
