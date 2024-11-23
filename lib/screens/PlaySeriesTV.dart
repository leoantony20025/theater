import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/components/GradientText.dart';
import 'package:theater/components/VideoPlayer.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:shimmer/shimmer.dart';
import 'package:theater/services/appService.dart';

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
  late List<FocusNode> fnEpisodes;
  late FocusNode fnWatchList;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    fnWatchNow = FocusNode();
    fnBackButton = FocusNode();
    fnEpisodes =
        List.generate(widget.content['episodes'].length, (_) => FocusNode());
    fnWatchList = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    fnWatchNow.dispose();
    fnBackButton.dispose();
    for (var focusNode in fnEpisodes) {
      focusNode.dispose();
    }
    fnWatchList.dispose();
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
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.only(left: 10, right: 20),
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                            fadeInCurve: Curves.bounceIn,
                            scale: 0.7,
                            imageUrl: widget.content['photo']),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        // width: MediaQuery.of(context).size.width / 3,
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
                                        focusNode: fnWatchList,
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
                                                border: fnWatchList.hasFocus
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
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    // width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Episodes",
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: episodes.map<Widget>(
                              (e) {
                                String? photo =
                                    e['photo'].toString().contains("noimg")
                                        ? e['photo']
                                        : "https:${e['photo']}";
                                int index = int.parse(e['eno'].toString()) - 1;
                                return Focus(
                                    child: InkWell(
                                  focusNode: fnEpisodes[index],
                                  onFocusChange: (value) {},
                                  onTap: () async {
                                    List videos = await fetchEpisodeVideos(
                                        e['url'].toString());
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => VideoPlayer(
                                                  url: videos[0],
                                                )));
                                  },
                                  child: Container(
                                    width: 280,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 280,
                                          height: 230,
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.topStart,
                                            children: [
                                              Text(
                                                e['eno'].toString(),
                                                style: const TextStyle(
                                                    fontSize: 100,
                                                    fontFamily: "Impact",
                                                    color: Color.fromARGB(
                                                        26, 177, 109, 255)),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Container(
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          shape: BoxShape
                                                              .rectangle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 30,
                                                                spreadRadius:
                                                                    -10,
                                                                offset: Offset(
                                                                    -10, -10),
                                                                color: Color
                                                                    .fromARGB(
                                                                        37,
                                                                        228,
                                                                        205,
                                                                        255)),
                                                            BoxShadow(
                                                                blurRadius: 30,
                                                                offset: Offset(
                                                                    10, 20),
                                                                color: Color
                                                                    .fromARGB(
                                                                        211,
                                                                        16,
                                                                        0,
                                                                        23))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          40))),
                                                  child: CachedNetworkImage(
                                                    width: fnEpisodes[index]
                                                            .hasFocus
                                                        ? 300
                                                        : 280,
                                                    height: fnEpisodes[index]
                                                            .hasFocus
                                                        ? 170
                                                        : 150,
                                                    fit: BoxFit.cover,
                                                    imageUrl: photo ?? "",
                                                    placeholder:
                                                        (context, url) =>
                                                            Shimmer.fromColors(
                                                      direction:
                                                          ShimmerDirection.ltr,
                                                      enabled: true,
                                                      loop: 5,
                                                      baseColor:
                                                          const Color.fromARGB(
                                                              71,
                                                              224,
                                                              224,
                                                              224),
                                                      highlightColor:
                                                          const Color.fromARGB(
                                                              70,
                                                              245,
                                                              245,
                                                              245),
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
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          e['title'].toString(),
                                          style:
                                              TextStyle(color: Colors.white60),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
