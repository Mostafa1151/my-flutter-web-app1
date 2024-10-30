import 'dart:convert';

import 'package:dashboard_quality_team/HomePage.dart';
import 'package:dashboard_quality_team/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int failedAttempts = 0;
  var password_;
  var email_;

  Future<void> Login_() async {
    final RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (_usernameController.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(" ", "",
            titleText: Text(
              "خطا",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontFamily: "Arfont",
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            messageText: Text(
              "يرجى إدخال البريد الإلكتروني، لا يمكن تركه فارغًا",
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: "Arfont", color: Colors.white),
            ),
            backgroundColor: Colors.red);
      });
      return;
    }
    if (_passwordController.text.length == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(" ", "",
            titleText: Text(
              "خطا",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontFamily: "Arfont",
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            messageText: Text(
              "يرجى كتابة كلمة المرور",
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: "Arfont", color: Colors.white),
            ),
            backgroundColor: Colors.red);
      });
      return;
    }
    if (_passwordController.text.length < 8) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(" ", "",
            titleText: Text(
              "خطا",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontFamily: "Arfont",
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            messageText: Text(
              "لا يجوز أن تكون كلمة المرور أقل من 8 أحرف أو أرقام",
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: "Arfont", color: Colors.white),
            ),
            backgroundColor: Colors.red);
      });
      return;
    }

    if (!emailRegExp.hasMatch(_usernameController.text)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(" ", "",
            titleText: Text(
              "خطا",
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontFamily: "Arfont",
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            messageText: Text(
              "يجب أن يكون البريد الإلكتروني صالحًا",
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: "Arfont", color: Colors.white),
            ),
            backgroundColor: Colors.red);
      });
      return;
    }
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.black,
                  size: 50,
                ),
              ),
            );
          });

      final respones = await http.post(
          headers: {"x-api-key": "gfjvbrjrs2z5fa0lsjmtenumv1a99k"},
          Uri.parse("https://quality-ad-api.onrender.com/api/v1/auth/login"),
          body: {
            "username": _usernameController.text,
            "password": _passwordController.text,
          });
      var responesbody = jsonDecode(respones.body);
      if (respones.statusCode == 200) {
        if (responesbody['status'] == 'success') {
          if (responesbody['data']['user']['role'] == 'admin') {
            await prefs.setString(
                "UserId", responesbody['data']['user']['_id']);
            await prefs.setString("token", responesbody['token']);
            Get.off(HomePage());
          }
          if (responesbody['data']['user']['role'] == 'user') {
            Navigator.of(context).pop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.snackbar(" ", "",
                  titleText: Text(
                    "خطأ",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontFamily: "Arfont",
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  messageText: Text(
                    "عذرًا، المستخدم الذي ادخلته ليس له الصلاحية للوصول الى لوحة التحكم",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontFamily: "Arfont", color: Colors.white),
                  ),
                  backgroundColor: Colors.red);
            });
          }
        }

        print(responesbody);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(" ", "",
              titleText: Text(
                "خطأ",
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: "Arfont",
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              messageText: Text(
                "عذرًا، البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى التحقق والمحاولة مرة أخرى.",
                textAlign: TextAlign.right,
                style: TextStyle(fontFamily: "Arfont", color: Colors.white),
              ),
              backgroundColor: Colors.red);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  bool _obscureText = true;
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.black,
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  child: Image.asset("images/لوكو-111111.png"),
                ),
              ),
            ),
            Text(
              "تسجيل دخول لوحة التحكم \n Quality team في تطبيق ",
              style: TextStyle(
                  fontFamily: "Arfont",
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.013,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.3),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "البريد الالكتروني",
                        style: TextStyle(
                            fontFamily: "Arfont",
                            color: Color(0xffA6A6A6),
                            fontSize: MediaQuery.of(context).size.width * 0.01,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontFamily: "Arfont",
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Color(0xffA6A6A6)),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 17.0,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "كلمة المرور",
                        style: TextStyle(
                            fontFamily: "Arfont",
                            color: Color(0xffA6A6A6),
                            fontSize: MediaQuery.of(context).size.width * 0.01,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: "Arfont",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Color(0xffA6A6A6)),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 17.0,
                        horizontal: MediaQuery.of(context).size.width * 0.01,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      prefixIcon: MaterialButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Text(
                          _obscureText ? "إظهار" : "إخفاء",
                          style: TextStyle(
                              fontFamily: "Arfont",
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17)),
                        backgroundColor: Colors.black,
                        fixedSize: Size(280, 50)),
                    onPressed: () {
                      Login_();
                    },
                    child: Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Arfont",
                          fontWeight: FontWeight.bold),
                    ),
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
