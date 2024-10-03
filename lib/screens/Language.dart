import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:theater/AppColors.dart';
import 'package:theater/providers/AppProvider.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  late List<FocusNode> list1FocusNodes;

  @override
  void initState() {
    super.initState();
    list1FocusNodes = List.generate(50, (index) => FocusNode());
  }

  @override
  void dispose() {
    super.dispose();
    for (var node in list1FocusNodes) {
      node.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    // int? lang = prefs.getInt("lang") ?? 1;
    final appProvider = Provider.of<AppProvider>(context);
    int? lang = appProvider.lang;

    List languages = [
      {
        "name": "Tamil",
        "isSelected": lang == 1,
        "value": 1,
        "path": "/category/tamil-movies"
      },
      {
        "name": "English",
        "isSelected": lang == 2,
        "value": 2,
        "path": "/category/english-movies"
      },
      {
        "name": "Malayalam",
        "isSelected": lang == 3,
        "value": 3,
        "path": "/category/malayalam-movies"
      },
      {
        "name": "Telugu",
        "isSelected": lang == 4,
        "value": 4,
        "path": "/category/telugu-movies"
      },
      {
        "name": "kannada",
        "isSelected": lang == 5,
        "value": 5,
        "path": "/category/kannada-movies"
      },
      {
        "name": "Hindi",
        "isSelected": lang == 6,
        "value": 6,
        "path": "/category/hindi-movies"
      }
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.topLeft,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color.fromARGB(255, 23, 0, 28), Colors.black])),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Choose Language",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: languages.map((e) {
                      int index = languages.indexOf(e);
                      return Focus(
                        focusNode: list1FocusNodes[index],
                        onKeyEvent: (node, event) {
                          if (event.logicalKey == LogicalKeyboardKey.select ||
                              event.logicalKey == LogicalKeyboardKey.enter) {
                            if (!e['isSelected']) {
                              appProvider.updateLang(e['value']);
                            }
                            setState(() {});
                            return KeyEventResult.handled;
                          }
                          return KeyEventResult.ignored;
                        },
                        child: InkWell(
                          onTap: () {
                            if (!e['isSelected']) {
                              appProvider.updateLang(e['value']);
                              Navigator.pushNamed(context, "/main");
                            }
                          },
                          child: Container(
                            height: 110,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: list1FocusNodes[index].hasFocus
                                    ? Border.all(
                                        color: AppColors.borderTV, width: 2)
                                    : Border.all(
                                        width: 0, color: Colors.transparent),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                gradient: e['isSelected']
                                    ? const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                            Color.fromARGB(70, 86, 0, 198),
                                            Color.fromARGB(217, 134, 0, 151)
                                          ])
                                    : const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                            Color.fromARGB(70, 42, 0, 97),
                                            Color.fromARGB(217, 31, 0, 35)
                                          ])),
                            child: Text(
                              e['name'],
                              style: TextStyle(
                                color: e['isSelected']
                                    ? Colors.white
                                    : const Color.fromARGB(140, 182, 144, 247),
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  // Focus(
                  //   child: InkWell(
                  //     onTap: () {
                  //       appProvider.updateLang(lang!);
                  //       Navigator.pushNamed(context, "/main");
                  //     },
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width,
                  //       alignment: Alignment.centerRight,
                  //       child: Container(
                  //         width: 120,
                  //         height: 50,
                  //         alignment: Alignment.center,
                  //         margin: const EdgeInsets.symmetric(vertical: 10),
                  //         decoration: const BoxDecoration(
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(10)),
                  //             boxShadow: [
                  //               BoxShadow(
                  //                   blurRadius: 30,
                  //                   color: Color.fromARGB(61, 185, 0, 222),
                  //                   offset: Offset(5, 10))
                  //             ],
                  //             gradient: LinearGradient(
                  //                 begin: Alignment.topLeft,
                  //                 end: Alignment.bottomCenter,
                  //                 colors: [
                  //                   Color.fromARGB(255, 86, 2, 101),
                  //                   Color.fromARGB(255, 66, 0, 75)
                  //                 ])),
                  //         child: const Text(
                  //           'Start Now',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w500,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            )),
      ),
    );
  }
}
