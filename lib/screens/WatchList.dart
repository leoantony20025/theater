import 'package:flutter/material.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  List<Movie> watchlist = getWatchhList();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(top: 30, left: 20, bottom: 0, right: 20),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: isDesktop ? Alignment.centerLeft : Alignment.topCenter,
              end: isDesktop ? Alignment.centerRight : Alignment.bottomCenter,
              colors: const [Color.fromARGB(255, 17, 0, 17), Colors.black])),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
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
            watchlist.isNotEmpty
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Wrap(
                      runSpacing: isDesktop ? 50 : 20,
                      spacing: isDesktop ? 50 : 20,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: watchlist.map((movie) {
                        return SizedBox(
                          width: isDesktop
                              ? 350
                              : (MediaQuery.of(context).size.width / 2) - 30,
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
                                    : (MediaQuery.of(context).size.width / 2) -
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color.fromARGB(70, 66, 0, 97),
                                            Color.fromARGB(255, 19, 0, 21)
                                          ])),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  movie.language,
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          73, 255, 255, 255),
                                                      fontSize: 10),
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  movie.year,
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          73, 255, 255, 255),
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
                                List<Movie> updatedWishlist = getWatchhList();
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
                                      color:
                                          const Color.fromARGB(95, 29, 0, 33),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 48, 0, 62),
                                          width: 1)),
                                  child: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Color.fromARGB(87, 249, 131, 255),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        );
                      }).toList(),
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
                          style: TextStyle(
                              color: Color.fromARGB(75, 235, 199, 255)),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
