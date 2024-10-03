import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  String word = "";
  final ScrollController scrollController = ScrollController();

  void scrollToSection(double offset) {
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;
    // bool isWatchList = checkMovieInWatchList(banner?.name ?? "");
    final appProvider = Provider.of<AppProvider>(context, listen: true);
    Map<String, List<Movie?>> latestContents = appProvider.latestContents;
    // Map<String, List<Movie?>> tamilContents = appProvider.tamilContents;
    // Map<String, List<Movie?>> englishContents = appProvider.englishContents;
    // Map<String, List<Movie?>> malayalamContents = appProvider.malayalamContents;
    // Map<String, List<Movie?>> teluguContents = appProvider.teluguContents;
    // Map<String, List<Movie?>> kannadaContents = appProvider.kannadaContents;
    // Map<String, List<Movie?>> hindiContents = appProvider.hindiContents;

    // Map<String, Map<String, List<Movie?>>> contents = {
    //   "Latest": appProvider.latestContents,
    //   "Tamil": appProvider.latestContents,
    //   "English": appProvider.latestContents,
    //   "Tamil": appProvider.latestContents,
    //   "Tamil": appProvider.latestContents,
    //   "Tamil": appProvider.latestContents,
    // };

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
      backgroundColor: AppColors.bg3,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: AppColors.bg3,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.bg2, AppColors.bg3])),
          child: ScrollConfiguration(
              behavior: NoScrollBehavior(),
              child: latestContents.isNotEmpty
                  ? SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          Focus(
                            skipTraversal: true,
                            onFocusChange: (value) {
                              if (value) {
                                scrollToSection(0);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              margin: const EdgeInsets.all(30),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: AppColors.bg1,
                                  border: Border.all(
                                      color: AppColors.bg1, width: 1),
                                  borderRadius: BorderRadius.circular(50)),
                              child: TextField(
                                controller: textEditingController,
                                canRequestFocus: false,
                                decoration: const InputDecoration(
                                    focusColor: AppColors.bg2,
                                    hintText: "Find your movies...",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(57, 158, 158, 158)),
                                    contentPadding:
                                        EdgeInsetsDirectional.symmetric(
                                            horizontal: 20),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          Focus(
                            skipTraversal: true,
                            onFocusChange: (value) {
                              if (value) {
                                scrollToSection(0);
                              }
                            },
                            child: BannerSearch(
                              fetchContent: fetchContent,
                              movie: latestContents['movies']![0],
                            ),
                          ),
                          latestContents['movies']!.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          latestContents['series']!.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          latestContents['series']!,
                                      isLoading: isLoading,
                                      setIsLoading: setIsLoading,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    )
                  : const SizedBox()),
        ),
      ),
    );
  }
}
