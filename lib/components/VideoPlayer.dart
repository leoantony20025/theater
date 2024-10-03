import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:hugeicons/hugeicons.dart';

class VideoPlayer extends StatefulWidget {
  String url;
  VideoPlayer({super.key, required this.url});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late Player player;
  late VideoController controller;
  bool isShowControls = false;
  late FocusNode fnPlayer;
  bool isDragging = false;
  double dragValue = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    player = Player();
    controller = VideoController(player);
    player.open(Media(widget.url));

    fnPlayer = FocusNode();

    // Listen to state changes to trigger UI updates
    player.streams.position.listen((_) {
      if (player.state.position > Duration.zero && isLoading) {
        setState(() {
          isLoading = false; // Loading complete once video starts playing
        });
      }
      if (!isDragging) setState(() {});
    });
    player.streams.duration.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    fnPlayer.dispose();
    player.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    if (player.state.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void showControls() async {
    setState(() {
      isShowControls = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isShowControls = false;
    });
  }

  void seekBy(Duration offset) {
    final newPosition = player.state.position + offset;
    if (newPosition > Duration.zero && newPosition < player.state.duration) {
      player.seek(newPosition);
    }
  }

  void seekTo(double value) {
    final newPosition = Duration(
        milliseconds: (value * player.state.duration.inMilliseconds).toInt());
    player.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    double progress = player.state.duration.inMilliseconds > 0
        ? player.state.position.inMilliseconds /
            player.state.duration.inMilliseconds
        : 0.0;

    return Scaffold(
      body: Focus(
        autofocus: true,
        focusNode: fnPlayer,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter) {
              togglePlayPause();
              showControls();
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              seekBy(const Duration(seconds: -15)); // Seek backward
              showControls();
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              seekBy(const Duration(seconds: 15)); // Seek forward
              showControls();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: InkWell(
          onTap: () {
            showControls();
          },
          child: Stack(
            children: [
              // Video Player
              Video(
                controller: controller,
                fit: BoxFit.cover,
                fill: const Color.fromARGB(255, 20, 0, 22),
                controls: null,
              ),

              // Controls (shown when isShowControls is true)
              if (isShowControls)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(), // Top part can be for other controls if needed
                        // Play/Pause button
                        Center(
                          child: InkWell(
                            onTap: togglePlayPause,
                            child: ClipOval(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                child: Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 63, 0, 86)
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  child: HugeIcon(
                                    size: 40,
                                    icon: player.state.playing
                                        ? HugeIcons.strokeRoundedPause
                                        : HugeIcons.strokeRoundedPlay,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Progress bar and duration
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                              child: Container(
                                color: const Color.fromARGB(255, 63, 0, 86)
                                    .withOpacity(0.3),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 25),
                                child: Row(
                                  children: [
                                    // Current position
                                    Text(
                                      player.state.position
                                          .toString()
                                          .split('.')
                                          .first,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(width: 10),
                                    // Progress bar with Slider
                                    Expanded(
                                      child: Slider(
                                        inactiveColor: const Color.fromARGB(
                                            233, 255, 255, 255),
                                        thumbColor: const Color.fromARGB(
                                            255, 92, 0, 132),
                                        activeColor: const Color.fromARGB(
                                            255, 117, 1, 159),
                                        value:
                                            isDragging ? dragValue : progress,
                                        onChanged: (value) {
                                          setState(() {
                                            isDragging = true;
                                            dragValue = value;
                                          });
                                        },
                                        onChangeEnd: (value) {
                                          setState(() {
                                            isDragging = false;
                                            seekTo(value);
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Total duration
                                    Text(
                                      player.state.duration
                                          .toString()
                                          .split('.')
                                          .first,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 123, 2, 154)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
