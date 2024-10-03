// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class VideoView extends StatefulWidget {
//   final String url;
//   final GlobalKey webViewKey;
//   const VideoView({super.key, required this.url, required this.webViewKey});

//   @override
//   State<VideoView> createState() => _VideoViewState();
// }

// class _VideoViewState extends State<VideoView> {
//   InAppWebViewController? webViewController;
//   bool isLoading = true;

//   @override
//   Widget build(BuildContext context) {
//     String videoData = '''
//       <!DOCTYPE html>
//         <html>
//           <head>
//               <meta charset="UTF-8">
//               <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
//               <meta http-equiv="X-UA-Compatible" content="ie=edge">
//               <title>Flutter InAppBrowser</title>
//           </head>
//           <style>
//             * {
//               margin: 0;
//             }
//             body {
//               background-color: black;
//               width: 100vw;
//               height: 100vh;
//               margin: 0;
//               padding: 0;
//               overflow: hidden;
//             }
//           </style>
//           <body>
//             <iframe id="videoFrame" style="border: none;" width="100%" height="100%" src="https://www.youtube.com/embed/wryC76__Aho?si=7Da21jb_qzrqVCvC" autoplay allowfullscreen></iframe>
//             <script src="assets/vendor/jwplayer/jwplayer.8.9.5.js"></script>
//             <script src="assets/js/player-v4.2.8.min.js"></script>
//             <script src="assets/js/player-v4.2.8.min.js"></script>
//           </body>
//           <script>
//             document.getElementById("videoFrame").requestFullscreen();

//               function requestFullScreen() {
//                 var iframe = document.getElementById("videoFrame");
//                 if (iframe.requestFullscreen) {
//                   iframe.requestFullscreen();
//                 } else if (iframe.mozRequestFullScreen) { // Firefox
//                   iframe.mozRequestFullScreen();
//                 } else if (iframe.webkitRequestFullscreen) { // Chrome, Safari, and Opera
//                   iframe.webkitRequestFullscreen();
//                 } else if (iframe.msRequestFullscreen) { // IE/Edge
//                   iframe.msRequestFullscreen();
//                 }
//               }

//               document.getElementById("videoFrame").addEventListener("click", function() {
//                 requestFullScreen();
//               });
//           </script>
//         </html>
//       ''';

//     return Container(
//       alignment: Alignment.center,
//       width: MediaQuery.of(context).size.width / 1.2,
//       height: 500,
//       child: Stack(
//         children: [
//           InAppWebView(
//             key: widget.webViewKey,
//             initialData: InAppWebViewInitialData(data: videoData),
//             initialSettings: InAppWebViewSettings(
//               allowBackgroundAudioPlaying: true,
//               allowsPictureInPictureMediaPlayback: true,
//               useOnLoadResource: true,
//               verticalScrollBarEnabled: false,
//               horizontalScrollBarEnabled: false,
//               iframeAllowFullscreen: true,
//               isTextInteractionEnabled: false,
//               hardwareAcceleration: true,
//               javaScriptEnabled: true,
//               mediaPlaybackRequiresUserGesture: false,
//             ),
//             onWebViewCreated: (controller) {
//               webViewController = controller;
//             },
//             onLoadStop: (controller, url) async {
//               // Ensure JavaScript runs after the page has loaded
//               await controller.evaluateJavascript(source: '''
//                   var iframe = document.getElementById("videoFrame");
//                   iframe.addEventListener("click", function() {
//                     var requestFullScreen = iframe.requestFullscreen || iframe.mozRequestFullScreen || iframe.webkitRequestFullscreen || iframe.msRequestFullscreen;
//                     if (requestFullScreen) {
//                       requestFullScreen.call(iframe);
//                     }
//                   });
//                 ''');
//             },
//             onEnterFullscreen: (controller) {
//               print("fullllllllll");
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
