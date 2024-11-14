import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/components/GradientText.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';

class BannerSearch extends StatefulWidget {
  final Function fetchContent;
  final Movie? movie;
  const BannerSearch(
      {super.key, required this.fetchContent, required this.movie});

  @override
  State<BannerSearch> createState() => _BannerSearchState();
}

class _BannerSearchState extends State<BannerSearch> {
  FocusNode fnWatchNow = FocusNode();
  bool ifWatchNow = false;
  FocusNode fnAdd = FocusNode();
  bool ifAdd = false;

  @override
  void dispose() {
    super.dispose();
    fnAdd.dispose();
    fnWatchNow.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;
    bool isWatchList = checkMovieInWatchList(widget.movie!.name);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isDesktop
          ? MediaQuery.of(context).size.width / 1.25
          : MediaQuery.of(context).size.width - 40,
      height: 300,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        boxShadow: ifWatchNow
            ? [
                const BoxShadow(
                    blurRadius: 50,
                    blurStyle: BlurStyle.normal,
                    spreadRadius: 2,
                    color: Color.fromARGB(65, 141, 2, 151))
              ]
            : [],
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          CachedNetworkImage(
            imageUrl: widget.movie?.photo ?? "",
            width: isDesktop
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width,
            height: isDesktop
                ? MediaQuery.of(context).size.height / 1.3
                : MediaQuery.of(context).size.height / 1.7,
            fit: BoxFit.fitWidth,
            // alignment: Alignment.topRight,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: const Color.fromARGB(71, 224, 224, 224),
              highlightColor: const Color.fromARGB(70, 245, 245, 245),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.7,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: isDesktop
                ? MediaQuery.of(context).size.height / 1.3
                : MediaQuery.of(context).size.height / 1.7,
            decoration: BoxDecoration(
                gradient: isDesktop
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                            Color.fromARGB(255, 22, 0, 23),
                            Color.fromARGB(210, 11, 0, 11),
                            Color.fromARGB(0, 0, 0, 0),
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
            width: MediaQuery.of(context).size.width,
            height: isDesktop
                ? MediaQuery.of(context).size.height / 1.3
                : MediaQuery.of(context).size.height / 1.7,
            decoration: BoxDecoration(
                gradient: isDesktop
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                            AppColors.bg1,
                            Color.fromARGB(168, 9, 0, 10),
                            Color.fromARGB(0, 13, 0, 13),
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
            width: isDesktop
                ? MediaQuery.of(context).size.width / 2 + 40
                : MediaQuery.of(context).size.width - 40,
            height: isDesktop
                ? MediaQuery.of(context).size.height / 1.3
                : MediaQuery.of(context).size.height / 1.7,
            decoration: BoxDecoration(
                gradient: isDesktop
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                            Color.fromARGB(255, 16, 0, 17),
                            Color.fromARGB(0, 12, 0, 12),
                          ])
                    : const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                            Color.fromARGB(0, 30, 0, 31),
                            Color.fromARGB(18, 52, 0, 56),
                            Color.fromARGB(38, 25, 0, 23),
                          ])),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: isDesktop
                ? MediaQuery.of(context).size.height / 1.3 + 5
                : MediaQuery.of(context).size.height / 1.7,
            decoration: BoxDecoration(
                gradient: isDesktop
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                            Color.fromARGB(0, 7, 0, 7),
                            AppColors.bg1,
                          ])
                    : const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                            Color.fromARGB(0, 17, 0, 17),
                            AppColors.bg2,
                          ])),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1.7,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(widget.movie?.name ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 32 : 26,
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
                Container(
                  padding: const EdgeInsets.only(),
                  child: GradientText(
                    widget.movie?.description ?? "",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 254, 245, 255),
                      Color.fromARGB(255, 120, 82, 125)
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      widget.movie?.year ?? "",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 74, 74, 74),
                          fontSize: 11,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    const Text(
                      "•",
                      style: TextStyle(
                          color: Color.fromARGB(255, 74, 74, 74),
                          fontSize: 11,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      widget.movie?.duration ?? "",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 74, 74, 74),
                          fontSize: 11,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    const Text(
                      "•",
                      style: TextStyle(
                          color: Color.fromARGB(255, 74, 74, 74),
                          fontSize: 11,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      widget.movie?.language ?? "",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 74, 74, 74),
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    AnimatedContainer(
                      margin: const EdgeInsets.all(8),
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                          border: ifWatchNow
                              ? Border.all(
                                  color: AppColors.borderTV,
                                  width: 2.0,
                                )
                              : Border.all(
                                  color: Colors.transparent,
                                  width: 0.0,
                                ),
                          boxShadow: ifWatchNow
                              ? [
                                  const BoxShadow(
                                      blurRadius: 50,
                                      blurStyle: BlurStyle.normal,
                                      spreadRadius: 2,
                                      color: Color.fromARGB(65, 121, 1, 130))
                                ]
                              : [],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 158, 0, 164),
                                Color.fromARGB(255, 48, 0, 63)
                              ])),
                      child: Material(
                        color: const Color.fromARGB(0, 0, 0, 0),
                        child: InkWell(
                          key: const Key("watch"),
                          focusNode: fnWatchNow,
                          autofocus: true,
                          onFocusChange: (value) {
                            setState(() {
                              ifWatchNow = value;
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          // focusColor:
                          //     const Color.fromARGB(
                          //         32, 252, 198, 255),
                          onTap: () {
                            widget.fetchContent(widget.movie!);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 130,
                            height: 50,
                            color: Colors.transparent,
                            child: const GradientText(
                              "Watch Now",
                              style: TextStyle(fontWeight: FontWeight.w600),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 254, 245, 255),
                                    Color.fromARGB(153, 120, 82, 125)
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    !isWatchList
                        ? Focus(
                            key: const Key("add"),
                            focusNode: fnAdd,
                            onFocusChange: (value) {
                              setState(() {
                                ifAdd = value;
                              });
                            },
                            child: InkWell(
                              onTap: () async {
                                await addToWatchhList(widget.movie!);
                                setState(() {
                                  isWatchList = true;
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 13, horizontal: 13),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50)),
                                      border: ifAdd
                                          ? Border.all(
                                              color: const Color.fromARGB(
                                                  255, 173, 0, 226),
                                              width: 2,
                                            )
                                          : Border.all(
                                              color: const Color.fromARGB(
                                                  52, 137, 0, 158),
                                              width: 1,
                                            ),
                                      color:
                                          const Color.fromARGB(70, 83, 2, 117)),
                                  child: const HugeIcon(
                                      icon: HugeIcons.strokeRoundedPlayListAdd,
                                      color: Color.fromARGB(255, 140, 0, 175))),
                            ),
                          )
                        : const SizedBox()
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
