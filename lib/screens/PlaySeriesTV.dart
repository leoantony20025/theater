import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/components/GradientText.dart';
import 'package:theater/components/VideoPlayer.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:shimmer/shimmer.dart';

class PlaySeriesTV extends StatefulWidget {
  Map<String, dynamic> content;
  PlaySeriesTV({super.key, required this.content});

  @override
  State<PlaySeriesTV> createState() => _PlaySeriesTVState();
}

class _PlaySeriesTVState extends State<PlaySeriesTV> {
  int currentServerIndex = 0;
  late FocusNode fnWatchNow;
  late FocusNode fnBackButton;
  late List<FocusNode> fnEpisodeButtons;
  late FocusNode fnPlayPauseButton;
  late FocusNode fnFullscreenButton;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    fnWatchNow = FocusNode();
    fnBackButton = FocusNode();
    fnEpisodeButtons =
        List.generate(widget.content['episodes'].length, (_) => FocusNode());
    fnPlayPauseButton = FocusNode();
    fnFullscreenButton = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    fnWatchNow.dispose();
    fnBackButton.dispose();
    for (var focusNode in fnEpisodeButtons) {
      focusNode.dispose();
    }
    fnPlayPauseButton.dispose();
    fnFullscreenButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;
    bool isWatchList = checkMovieInWatchList(widget.content['name'] ?? "");
    Iterable<Map<String, String?>> cast = widget.content['cast'];
    Iterable<Map<String, String?>> episodes = widget.content['episodes'];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 0, 17),
      body: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: SingleChildScrollView(
          child: Stack(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: CachedNetworkImage(
                imageUrl: widget.content['photo'],
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color.fromARGB(162, 30, 0, 31),
                    Color.fromARGB(140, 52, 0, 56),
                    Color.fromARGB(188, 25, 0, 23),
                    Color.fromARGB(255, 17, 0, 17)
                  ])),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color.fromARGB(0, 17, 0, 17),
                    Color.fromARGB(255, 17, 0, 17),
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    focusNode: fnBackButton,
                    focusColor: Colors.white,
                    // onKeyEvent: (node, event) {
                    //   if (event.logicalKey == LogicalKeyboardKey.select ||
                    //       event.logicalKey == LogicalKeyboardKey.enter) {
                    //     Navigator.pop(context);
                    //     return KeyEventResult.handled;
                    //   }
                    //   return KeyEventResult.ignored;
                    // },
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                border: fnBackButton.hasFocus
                                    ? Border.all(
                                        width: 2, color: AppColors.borderTV)
                                    : Border.all(
                                        width: 0, color: Colors.transparent),
                                color: const Color.fromARGB(23, 200, 0, 210),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                              )),
                          const HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowLeft01,
                              color: Color.fromARGB(255, 240, 108, 255)),
                        ]),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.only(left: 10, right: 20),
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                            fadeInCurve: Curves.bounceIn,
                            scale: 0.9,
                            imageUrl: widget.content['photo']),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GradientText(widget.content['name'] ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isDesktop ? 40 : 26,
                                  fontWeight: FontWeight.bold,
                                ),
                                gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromARGB(255, 116, 0, 205),
                                      Color.fromARGB(255, 165, 0, 174)
                                    ])),
                            const SizedBox(
                              height: 10,
                            ),
                            GradientText(
                              widget.content['description'].toString().trim(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 254, 245, 255),
                                Color.fromARGB(255, 120, 82, 125)
                              ]),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.content['language'] ?? "",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 74, 74, 74),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                // InkWell(
                                //   canRequestFocus: true,
                                //   focusNode: fnWatchNow,
                                //   focusColor: Colors.transparent,
                                //   highlightColor: Colors.transparent,
                                //   splashColor: Colors.transparent,
                                //   onFocusChange: (value) {
                                //     setState(() {});
                                //   },
                                //   onTap: () {
                                //     Navigator.of(context)
                                //         .push(MaterialPageRoute(
                                //             builder: (context) => VideoPlayer(
                                //                   url: widget.content['servers']
                                //                       [currentServerIndex],
                                //                 )));
                                //   },
                                //   child: AnimatedContainer(
                                //     duration: const Duration(milliseconds: 300),
                                //     alignment: Alignment.center,
                                //     width: 130,
                                //     height: 50,
                                //     margin: const EdgeInsets.only(right: 10),
                                //     decoration: BoxDecoration(
                                //         border: fnWatchNow.hasFocus
                                //             ? Border.all(
                                //                 color: AppColors.borderTV,
                                //                 width: 3.0,
                                //               )
                                //             : Border.all(
                                //                 color: Colors.transparent,
                                //                 width: 0.0,
                                //               ),
                                //         boxShadow: fnWatchNow.hasFocus
                                //             ? [
                                //                 const BoxShadow(
                                //                     blurRadius: 50,
                                //                     blurStyle: BlurStyle.normal,
                                //                     spreadRadius: 2,
                                //                     color: Color.fromARGB(
                                //                         98, 222, 0, 238))
                                //               ]
                                //             : [],
                                //         borderRadius: const BorderRadius.all(
                                //             Radius.circular(15)),
                                //         gradient: const LinearGradient(
                                //             begin: Alignment.topLeft,
                                //             end: Alignment.bottomRight,
                                //             colors: [
                                //               Color.fromARGB(255, 158, 0, 164),
                                //               Color.fromARGB(255, 48, 0, 63)
                                //             ])),
                                //     child: const GradientText(
                                //       "Watch Now",
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.w600),
                                //       gradient: LinearGradient(
                                //           begin: Alignment.topLeft,
                                //           end: Alignment.bottomRight,
                                //           colors: [
                                //             Color.fromARGB(255, 254, 245, 255),
                                //             Color.fromARGB(153, 120, 82, 125)
                                //           ]),
                                //     ),
                                //   ),
                                // ),
                                !isWatchList
                                    ? InkWell(
                                        focusNode: fnPlayPauseButton,
                                        onFocusChange: (value) {
                                          setState(() {});
                                        },
                                        onTap: () async {
                                          await addToWatchhList(Movie(
                                              name: widget.content['name'],
                                              description:
                                                  widget.content['desc'],
                                              photo: widget.content['photo'],
                                              language:
                                                  widget.content['language'],
                                              url: widget.content['url'],
                                              duration: "",
                                              year: "",
                                              isMovie:
                                                  widget.content['isMovie']));
                                          setState(() {
                                            isWatchList = true;
                                          });
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                border: fnPlayPauseButton
                                                        .hasFocus
                                                    ? Border.all(
                                                        color:
                                                            AppColors.borderTV,
                                                        width: 3.0,
                                                      )
                                                    : Border.all(
                                                        color: const Color
                                                            .fromARGB(
                                                            52, 137, 0, 158),
                                                        width: 1,
                                                      ),
                                                color: const Color.fromARGB(
                                                    70, 83, 2, 117)),
                                            child: const Row(
                                              children: [
                                                HugeIcon(
                                                    icon: HugeIcons
                                                        .strokeRoundedPlusSign,
                                                    color: Color.fromARGB(
                                                        255, 140, 0, 175)),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  "Add to Watchlist",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 157, 0, 196)),
                                                ),
                                              ],
                                            )),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Cast",
                              style: TextStyle(
                                  color: Color.fromARGB(117, 192, 192, 192),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SingleChildScrollView(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: cast.map(
                                  (e) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https:${e['photo']!}"),
                                              fit: BoxFit.cover)),
                                    );
                                  },
                                ).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                        width: 150,
                        height: 300,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: episodes.map<Widget>(
                              (e) {
                                String? photo =
                                    e['photo'].toString().contains("noimg")
                                        ? e['photo']
                                        : "https:${e['photo']}";
                                return Focus(
                                    child: InkWell(
                                  child: Container(
                                    margin: EdgeInsets.all(8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl: photo ?? "",
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.7,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                              },
                            ).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
