import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:theater/AppColors.dart';

class VideoPlayer extends StatefulWidget {
  String url;
  VideoPlayer({super.key, required this.url});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  int currentServerIndex = 0;
  late FocusNode fnPlayer;
  late FocusNode fnPlayPauseButton;
  late FocusNode fnFullscreenButton;
  late Player player;
  late VideoController controller;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    player = Player();
    controller = VideoController(player);
    fnPlayer = FocusNode();
    player.open(Media(widget.url));
    fnPlayPauseButton = FocusNode();
    fnFullscreenButton = FocusNode();
  }

  @override
  void dispose() {
    fnPlayer.dispose();
    fnPlayPauseButton.dispose();
    fnFullscreenButton.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // enterFullscreen(context);
    void togglePlayPause() {
      if (player.state.playing) {
        player.pause();
      } else {
        player.play();
      }
    }

    return Scaffold(
      body: Container(
          // width: MediaQuery.of(context).size.width,
          alignment: Alignment.topLeft,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                // Focus(
                // onKeyEvent: (node, event) {
                //   if (event.logicalKey == LogicalKeyboardKey.select ||
                //       event.logicalKey == LogicalKeyboardKey.enter) {
                //     togglePlayPause();
                //     return KeyEventResult.handled;
                //   }
                //   return KeyEventResult.ignored;
                // },
                InkWell(
                  onFocusChange: (value) => setState(() {}),
                  onTap: () {
                    togglePlayPause();
                  },
                  onDoubleTap: () {
                    // toggleFullscreen(context);
                  },
                  child: Container(
                    // decoration: BoxDecoration(
                    //   border: fnPlayer.hasFocus
                    //       ? Border.all(width: 2, color: AppColors.borderTV)
                    //       : Border.all(width: 0, color: Colors.transparent),
                    // ),
                    child: Video(
                      controller: controller,
                      fit: BoxFit.cover,
                      fill: const Color.fromARGB(255, 20, 0, 22),
                      controls: MaterialVideoControls,
                    ),
                  ),
                ),
                // ),
              ],
            ),
          )),
    );
  }
}
