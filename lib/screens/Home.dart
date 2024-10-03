import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/components/BannerHome.dart';
import 'package:theater/components/HorizontalScrollList.dart';
import 'package:theater/models/Movie.dart';
// import 'package:theater/prefs.dart';
import 'package:theater/providers/AppProvider.dart';
import 'package:theater/screens/Play.dart';
import 'package:theater/screens/PlayTV.dart';
import 'package:theater/services/appService.dart';
import 'package:theater/utils/NoScrollBehavior.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  Random random = Random();
  late int randomIndex = 4;
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
    randomIndex = random.nextInt(4);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: true);
    Map<String, List<Movie?>> currentContents = appProvider.currentContents;
    // Movie? banner = currentContents['movies']?[randomIndex];
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;
    // bool isWatchList = checkMovieInWatchList(banner?.name ?? "");

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

    return Scaffold(
        body: Stack(children: [
      AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          color: AppColors.bg2,
          child: currentContents.isEmpty
              ? const CircularProgressIndicator(
                  color: Color.fromARGB(255, 123, 2, 154))
              : ScrollConfiguration(
                  behavior: NoScrollBehavior(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(bottom: 30),
                    controller: scrollController,
                    child: currentContents['movies']!.isNotEmpty
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
                                child: BannerHome(fetchContent: fetchContent),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Text(
                                  "Latest Movies",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Focus(
                                skipTraversal: true,
                                onFocusChange: (value) {
                                  if (value) {
                                    scrollToSection(300);
                                  }
                                },
                                child: HorizontalScrollList(
                                  currentContents: currentContents['movies']!,
                                  isLoading: isLoading,
                                  setIsLoading: setIsLoading,
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              currentContents['series']!.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          child: Text(
                                            "Latest Series",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                          ),
                                        ),
                                        HorizontalScrollList(
                                          currentContents:
                                              currentContents['series']!,
                                          isLoading: isLoading,
                                          setIsLoading: setIsLoading,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          )
                        : const SizedBox(),
                  ),
                )),
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
    ]));
  }
}
