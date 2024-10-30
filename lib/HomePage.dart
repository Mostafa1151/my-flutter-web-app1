import 'dart:convert';

import 'package:dashboard_quality_team/Banners.dart';
import 'package:dashboard_quality_team/Login.dart';
import 'package:dashboard_quality_team/main.dart';
import 'package:dashboard_quality_team/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.01),
                          child: Image.asset("images/لوكو-111111.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    "DashBoard Quality team",
                    style: TextStyle(
                      fontFamily: "Arfont",
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Divider(
                      color: Colors.black,
                    )),
                Expanded(
                    child: Center(
                  child: Text(
                    "لوحة التحكم",
                    style: TextStyle(
                        fontFamily: "Arfont",
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.02),
                  ),
                )),
                Expanded(
                    flex: 3,
                    child: Divider(
                      color: Colors.black,
                    )),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: InkWell(
                      onTap: () {
                        Get.off(users());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(
                                    255, 166, 166, 166), // لون الظل
                                spreadRadius: 1, // مدى انتشارة الظل
                                blurRadius: 1, // مقدار تمييع الظل
                                offset: Offset(
                                    0, 3), // اتجاه الظل (الافتراضي هو الأسفل)
                              ),
                            ],
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.width * 0.12,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                                child: SvgPicture.asset(
                              "images/users.svg",
                              width: 200,
                              color: Colors.white,
                            )),
                            Expanded(
                                child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "المستخدمين",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Arfont",
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.015),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: InkWell(
                      onTap: () {
                        Get.off(Banners());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(
                                    255, 166, 166, 166), // لون الظل
                                spreadRadius: 1, // مدى انتشارة الظل
                                blurRadius: 1, // مقدار تمييع الظل
                                offset: Offset(
                                    0, 3), // اتجاه الظل (الافتراضي هو الأسفل)
                              ),
                            ],
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.width * 0.12,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                                child: SvgPicture.asset(
                              "images/advertisement-banner-icon.svg",
                              width: 200,
                              color: Colors.white,
                            )),
                            Expanded(
                                child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "لافتات",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Arfont",
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.015),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "تسجيل الخروج",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontFamily: "Arfont",
                                      color: Color.fromARGB(255, 104, 10, 10)),
                                ),
                                content: Text(
                                  "هل انت متأكد من تسجيل الخروج ؟ ",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontFamily: "Arfont",
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "رجوع",
                                        style: TextStyle(
                                            fontFamily: "Arfont",
                                            color: Colors.black),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Center(
                                                  child: LoadingAnimationWidget
                                                      .fourRotatingDots(
                                                    color: Colors.black,
                                                    size: 50,
                                                  ),
                                                ),
                                              );
                                            });

                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        await prefs.remove("UserId");
                                        await prefs.remove("token");
                                        await Get.off(Login());
                                      },
                                      child: Text(
                                        "خروج",
                                        style: TextStyle(
                                            fontFamily: "Arfont",
                                            color: Color.fromARGB(
                                                255, 104, 10, 10)),
                                      ))
                                ],
                              );
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(
                                    255, 166, 166, 166), // لون الظل
                                spreadRadius: 1, // مدى انتشارة الظل
                                blurRadius: 1, // مقدار تمييع الظل
                                offset: Offset(
                                    0, 3), // اتجاه الظل (الافتراضي هو الأسفل)
                              ),
                            ],
                            color: const Color.fromARGB(255, 104, 10, 10),
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.width * 0.12,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                                child: SvgPicture.asset(
                              "images/exit-icon.svg",
                              width: 200,
                              color: Colors.white,
                            )),
                            Expanded(
                                child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "تسجيل الخروج",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Arfont",
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.015),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
