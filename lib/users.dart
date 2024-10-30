import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dashboard_quality_team/Banners.dart';
import 'package:dashboard_quality_team/HomePage.dart';
import 'package:dashboard_quality_team/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class users extends StatefulWidget {
  const users({super.key});

  @override
  State<users> createState() => _usersState();
}

class _usersState extends State<users> {
  @override
  void initState() {
    // loadUserData();
    fetchUsers();
    super.initState();
  }

  List<dynamic> UserList = [];

  Future<void> fetchUsers() async {
    var UserToken = prefs.getString("token");
    try {
      final response = await http.get(
        Uri.parse("https://quality-ad-api.onrender.com/api/v1/users"),
        headers: {
          "x-api-key": "gfjvbrjrs2z5fa0lsjmtenumv1a99k",
          "Authorization": "Bearer $UserToken",
        },
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        List<dynamic> newData = responseBody['data']['docs'];

        // مقارنة البيانات المخزنة مع البيانات الجديدة
        if (UserList.toString() != newData.toString()) {
          setState(() {
            UserList = newData; // تحديث البيانات
          });
          // await prefs.setString(
          //     'usersData', jsonEncode(UserList)); // تخزين البيانات الجديدة
        }
        print(newData);
        print(UserList);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  // Future<void> loadUserData() async {
  //   String? userDataString = prefs.getString('usersData');

  //   if (userDataString != null) {
  //     setState(() {
  //       UserList = jsonDecode(userDataString); // تفكيك البيانات المخزنة
  //     });
  //   }
  // }

// دالة لتحديد اتجاه النص
  MainAxisAlignment _getTextAlignment(String text) {
    // إذا كانت الحروف الأولى عربية
    if (RegExp(r'^[\u0600-\u06FF]').hasMatch(text)) {
      return MainAxisAlignment.end; // عرض من اليمين إلى اليسار
    } else {
      return MainAxisAlignment.start; // عرض من اليسار إلى اليمين
    }
  }

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
      body: Row(
        children: [
          Container(
            width: 300,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "لوحة التحكم",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.02,
                        fontFamily: "Arfont",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  label: "الرئيسية",
                  icon: "images/house.svg",
                  onTap: () {
                    Get.off(HomePage());
                  },
                ),
                _buildMenuItem(
                  context,
                  label: "المستخدمين",
                  icon: "images/users.svg",
                  onTap: () {
                    // Get.off(users());
                  },
                ),
                _buildMenuItem(
                  context,
                  label: "لافتات",
                  icon: "images/users.svg",
                  onTap: () {
                    Get.off(Banners());
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              child: SizedBox(
                child: UserList.isEmpty
                    ? Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.black,
                        size: 100,
                      ))
                    : ListView.builder(
                        itemCount: UserList.length,
                        itemBuilder: (context, index) {
                          var user = UserList[index];
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserDetails(
                                      User: user,
                                    ),
                                  ),
                                );
                                print(UserList[index]['_id']);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(19),
                                    color: const Color(0xffD9D9D9)),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: SvgPicture.asset(
                                            "images/pencil (1).svg")),
                                    Expanded(
                                        child: ListTile(
                                            title: Text(
                                              textAlign: TextAlign.right,
                                              "نوع الاشتراك",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Arfont",
                                                  color: Color(0xff949494)),
                                            ),
                                            subtitle: Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: UserList[index]
                                                              ['bundles']
                                                          .isEmpty
                                                      ? Color.fromARGB(
                                                          255, 131, 71, 10)
                                                      : Color.fromARGB(
                                                          255, 6, 135, 17),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8,
                                                          bottom: 8,
                                                          right: 20),
                                                  child: Text(
                                                    textAlign: TextAlign.right,
                                                    UserList[index]['bundles']
                                                            .isEmpty
                                                        ? "غير مشترك"
                                                        : "مشترك",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Arfont",
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ))),
                                    Expanded(
                                        child: ListTile(
                                      title: Text(
                                        textAlign: TextAlign.right,
                                        "الايميل",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Arfont",
                                            color: Color(0xff949494)),
                                      ),
                                      subtitle: Text(
                                        UserList[index]['username'],
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontFamily: "Arfont",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    )),
                                    Expanded(
                                        child: ListTile(
                                            title: Text(
                                              textAlign: TextAlign.right,
                                              "الاسم",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Arfont",
                                                  color: Color(0xff949494)),
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  _getTextAlignment(
                                                      UserList[index]
                                                          ['firstName']),
                                              children: [
                                                Text(
                                                  "${UserList[index]['firstName']}",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontFamily: "Arfont",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        8), // إضافة مسافة صغيرة بين الاسمين
                                                Text(
                                                  "${UserList[index]['lastName']}",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontFamily: "Arfont",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ))),
                                    Expanded(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        maxRadius: 30,
                                        child: ClipOval(
                                          child: Image.network(
                                            "${UserList[index]['profile']}",
                                            fit: BoxFit
                                                .cover, // لجعل الصورة تغطي كامل المساحة
                                            width:
                                                60, // نفس القطر الخاص بـ CircleAvatar
                                            height:
                                                60, // نفس القطر الخاص بـ CircleAvatar
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String label,
      required String icon,
      required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.width * 0.004),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.002),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: "Arfont",
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 30,
                  child: SvgPicture.asset(
                    icon,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserDetails extends StatefulWidget {
  final Map<String, dynamic> User;

  UserDetails({required this.User});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  var clientsList;

  Future<void> fetchclients() async {
    var UserToken = prefs.getString("token");
    try {
      final response = await http.get(
        Uri.parse(
            "https://quality-ad-api.onrender.com/api/v1/users/${widget.User['_id']}/clients"),
        headers: {
          "x-api-key": "gfjvbrjrs2z5fa0lsjmtenumv1a99k",
          "Authorization": "Bearer $UserToken",
        },
      );
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          clientsList = responseBody;
        });

        print("clientsList :${clientsList}");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  var UserToken = prefs.getString("token");
  var Accsept;
  Future<void> _Accsept() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Column(
                children: [
                  Text(
                    "جاري الموافقة على طلب الاشتراك",
                    style: TextStyle(fontFamily: "Arfont", color: Colors.black),
                  ),
                  Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          );
        });

    var userId = widget.User["_id"];
    print(' UserId ============================== ${userId}');
    try {
      final response = await http.patch(
          Uri.parse(
              "https://quality-ad-api.onrender.com/api/v1/requests/${subscriptionDetails['_id']}"),
          headers: {
            "x-api-key": "gfjvbrjrs2z5fa0lsjmtenumv1a99k",
            "Authorization": "Bearer $UserToken",
          },
          body: {
            'approve': Accsept.toString()
          });

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "تمت الموافقة بنجاح",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Arfont",
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(child: Image.asset(width: 50, "images/yes.png")),
                    ],
                  ),
                ),
              );
            });
        await Future.delayed(Duration(seconds: 1));
        subscriptionDetails_();
        contentes_();
        Navigator.of(context).pop();
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Map<String, String> subscriptionDetails = {};

  Future<void> subscriptionDetails_() async {
    try {
      final response = await http.get(
        Uri.parse("https://quality-ad-api.onrender.com/api/v1/requests/"),
        headers: {
          "x-api-key": "gfjvbrjrs2z5fa0lsjmtenumv1a99k",
          "Authorization": "Bearer $UserToken",
        },
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var docData = responseBody['data']['docs'];

        // تصفية البيانات
        var filteredData = docData
            .where((item) => item['user'] == widget.User['_id'])
            .toList();

        print("Filtered Data: $filteredData");

        // تأكد من أن filteredData ليس فارغًا
        if (filteredData.isNotEmpty) {
          setState(() {
            // تحويل العنصر الأول من filteredData إلى خريطة
            subscriptionDetails = {
              '_id': filteredData[0]['_id'] ?? '',
              'approve': filteredData[0]['approve'] ?? '',
              'user': filteredData[0]['user'] ?? '',
              'createdAt': filteredData[0]['createdAt'] ?? '',
              'updatedAt': filteredData[0]['updatedAt'] ?? '',
              'id': filteredData[0]['id'] ?? '',
            };
          });
        } else {
          print("No matching data found.");
        }

        print(subscriptionDetails);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  var contentId;
  Future<void> contentesDelete_() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Column(
                children: [
                  Text(
                    "جاري حذف المحتوى المحدد",
                    style: TextStyle(fontFamily: "Arfont", color: Colors.black),
                  ),
                  Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          );
        });

    var subscriptionsID = widget.User['bundles'][0]['_id'];
    final url =
        'https://quality-ad-api.onrender.com/api/v1/Bundles/${subscriptionsID}/contents/${contentId}';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "x-api-key": "gfjvbrjrs2z5fa0lsjmtenumv1a99k",
          "Authorization": "Bearer $UserToken",
        },
      );
      await contentes_();
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "تم حذف المحتوى المحدد بنجاح",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Arfont",
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(child: Image.asset(width: 50, "images/yes.png")),
                  ],
                ),
              ),
            );
          });
      await Future.delayed(Duration(seconds: 1));

      Navigator.of(context).pop();
    } catch (error) {
      print('حدث خطأ: $error');
    } finally {
      Navigator.of(context).pop();
    }
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _decorationController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  TextEditingController _PersentegController = TextEditingController();

  String _selectedValue = 'tvc';

  // القائمة التي تحتوي على الخيارات
  List<Map<String, String>> _options = [
    {'value': 'tvc', 'display': 'تصوير'},
    {'value': 'motion_graphic', 'display': 'موشن جرافيك'},
    {'value': 'graphic_design', 'display': 'تصميم'},
    {'value': 'copy_writing', 'display': 'كتابة محتوى'},
    {'value': 'marketing', 'display': 'اعلان'},
  ];

  TextEditingController _plancontroller = TextEditingController();
  TextEditingController _themecontroller = TextEditingController();
  TextEditingController _descriptioncontroller = TextEditingController();
  TextEditingController _introcontroller = TextEditingController();

  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _socialMediaLinkscontroller = TextEditingController();

  Future<void> AddUserDite() async {
    if (widget.User['bundles'].isEmpty) {
      print('لا توجد اشتراكات');
      return; // Exit the function if the list is empty
    }

    var bundlesID = widget.User['bundles'][0]['_id'];
    print(bundlesID);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Column(
                children: [
                  Text(
                    "جاري إضافة معلومات المستخدم",
                    style: TextStyle(fontFamily: "Arfont", color: Colors.black),
                  ),
                  Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          );
        });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "https://quality-ad-api.onrender.com/api/v1/users/${widget.User['_id']}/clients"),
      );

      request.headers['x-api-key'] = 'gfjvbrjrs2z5fa0lsjmtenumv1a99k';
      request.headers['Authorization'] = 'Bearer $UserToken';
      request.fields['plan'] = _plancontroller.text;
      request.fields['theme'] = _themecontroller.text;
      request.fields['description'] = _descriptioncontroller.text;
      request.fields['intro'] = _introcontroller.text;
      request.fields['name'] = _namecontroller.text;
      request.fields['socialMediaLinks'] = _socialMediaLinkscontroller.text;

      if (_image2 != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            _image2!.path,
          ),
        );
      }

      print(_image2!.path);

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await contentes_();
        var responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
        var decodedResponse = jsonDecode(responseBody);
        Navigator.of(context).pop(); // Close the loading dialog
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "تم إضافة معلومات المستخدم بنجاح",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Arfont",
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(child: Image.asset("images/yes.png", width: 50)),
                    ],
                  ),
                ),
              );
            });

        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pop(); // Close the success dialog
        print(decodedResponse);
      } else {
        var responseBody = await response.stream.bytesToString();
        print('Error: ${response.statusCode}, Body: $responseBody');
      }
    } catch (e) {
      print("$e");
    } finally {
      _plancontroller.clear();
      _themecontroller.clear();
      _descriptioncontroller.clear();
      _introcontroller.clear();
      _namecontroller.clear();
      removeImage2();
    }
  }

  void removeImage2() {
    setState(() {
      _image2 = null;
    });
  }

  File? _image2;

  Future<void> _pickImage2() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image2 = File(pickedFile.path);
      });
    } else {
      print('لم يتم اختيار صورة.');
    }
  }

  Future<void> AddContent() async {
    if (widget.User['bundles'].isEmpty) {
      print('لا توجد اشتراكات');
      return;
    }

    var bundlesID = widget.User['bundles'][0]['_id'];
    print(bundlesID);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Column(
                children: [
                  Text(
                    "جاري إضافة المحتوى",
                    style: TextStyle(fontFamily: "Arfont", color: Colors.black),
                  ),
                  Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          );
        });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "https://quality-ad-api.onrender.com/api/v1/bundles/${bundlesID}/contents"),
      );

      request.headers['x-api-key'] = 'gfjvbrjrs2z5fa0lsjmtenumv1a99k';
      request.headers['Authorization'] = 'Bearer $UserToken';
      request.fields['name'] = _nameController.text;
      request.fields['type'] = _selectedValue.toString();
      request.fields['description'] = _decorationController.text;
      request.fields['link'] = _linkController.text;
      request.fields['progress'] = _PersentegController.text;
      if (_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            _image!.path,
          ),
        );
      }

      print(_image!.path);

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await contentes_();
        var responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');

        var decodedResponse = jsonDecode(responseBody);
        Navigator.of(context).pop(); // Close the loading dialog
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "تم إضافة المحتوى بنجاح",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Arfont",
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(child: Image.asset("images/yes.png", width: 50)),
                    ],
                  ),
                ),
              );
            });

        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pop(); // Close the success dialog
        print(decodedResponse);
      } else {
        var responseBody = await response.stream.bytesToString();
        print('Error: ${response.statusCode}, Body: $responseBody');
      }
    } catch (e) {
      print("$e");
    } finally {
      _nameController.clear();
      _decorationController.clear();
      _linkController.clear();
      _PersentegController.clear();
      removeImage1();
    }
  }

  void removeImage1() {
    setState(() {
      _image = null;
    });
  }

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('لم يتم اختيار صورة.');
    }
  }

  // api/v1/subscriptions/{id}/contents
  List<dynamic> packages = [];

  @override
  void initState() {
    fetchclients();
    contentes_();
    subscriptionDetails_();
    super.initState();
  }

  bool isLoading = true;
  bool isEmpty = false;

  Future<void> contentes_() async {
    if (widget.User['bundles'].isEmpty) {
      print('لا توجد اشتراكات');
      return; // Exit the function if the list is empty
    }
    var BundlesId = widget.User['bundles'][0]['_id'];
    print("=============================== $BundlesId");
    final url =
        'https://quality-ad-api.onrender.com/api/v1/bundles/${BundlesId}/contents';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "x-api-key": "gfjvbrjrs2z5fa0lsjmtenumv1a99k",
          "Authorization": "Bearer $UserToken",
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            packages = data['data']['contents'];
          });
          setState(() {
            // قم بتحديث قائمة packages هنا بعد التحميل
            if (packages.isEmpty) {
              isEmpty = true; // إذا كانت القائمة فارغة
            }
            isLoading = false; // انتهت حالة التحميل
          });

          print(' packages ==>  ${packages}');
        }
      } else {
        print('فشل في جلب البيانات: ${response.statusCode}');
      }
    } catch (error) {
      print('حدث خطأ: $error');
    }
  }

  // دالة لتحديد اتجاه النص
  MainAxisAlignment _getTextAlignment(String text) {
    // إذا كانت الحروف الأولى عربية
    if (RegExp(r'^[\u0600-\u06FF]').hasMatch(text)) {
      return MainAxisAlignment.end; // عرض من اليمين إلى اليسار
    } else {
      return MainAxisAlignment.start; // عرض من اليسار إلى اليمين
    }
  }

  String _getTypeText(String type) {
    switch (type) {
      case 'tvc':
        return 'تصوير';
      case 'motion_graphic':
        return 'موشن جرافيك';
      case 'graphic_design':
        return 'تصميم';
      case 'copy_writing':
        return 'كتابة محتوى';
      case 'marketing':
        return 'اعلان';
      default:
        return 'غير معروف';
    }
  }

  @override
  Widget build(BuildContext context) {
    print(" ============== ${widget.User} ============");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
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
                            MediaQuery.of(context).size.width * 0.01,
                          ),
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
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.01,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(180, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                backgroundColor: Color(0xff962525),
                              ),
                              onPressed: () {},
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "images/trash-2.svg",
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "حذف الحساب",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Arfont",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(180, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 37, 97, 150),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return AlertDialog(
                                          title: Column(
                                            children: [
                                              Text(
                                                "إضافة معلومات المستخدم",
                                                style: TextStyle(
                                                    fontFamily: "Arfont"),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: _namecontroller,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: "Arfont",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  hintText: "الاسم",
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffA6A6A6)),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 17.0,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: _introcontroller,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: "Arfont",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  hintText: "مقدمة",
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffA6A6A6)),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 17.0,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller:
                                                    _socialMediaLinkscontroller,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: "Arfont",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "روابط وسائل الاعلام",
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffA6A6A6)),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 17.0,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: _plancontroller,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: "Arfont",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  hintText: "الخطة",
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffA6A6A6)),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 17.0,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: _themecontroller,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: "Arfont",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  hintText: "ثيم",
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffA6A6A6)),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 17.0,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller:
                                                    _descriptioncontroller,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: "Arfont",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  hintText: "التفاصيل",
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffA6A6A6)),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 17.0,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, right: 10),
                                                child: _image2 == null
                                                    ? InkWell(
                                                        onTap: () async {
                                                          // قم بتحديث الصورة هنا
                                                          await _pickImage2();
                                                          // قم بإعادة بناء الـ Dialog لتحديث الصورة
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          width: 300,
                                                          height: 180,
                                                          child: Center(
                                                            child: Text(
                                                              "+ إضافة صورة",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Arfont",
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      107,
                                                                      106,
                                                                      106)),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 300,
                                                        height: 180,
                                                        child: Center(
                                                          child: Image.file(
                                                            _image2!,
                                                            fit: BoxFit.cover,
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
                                                          borderRadius:
                                                              BorderRadiusDirectional
                                                                  .circular(
                                                                      10)),
                                                      backgroundColor:
                                                          Colors.black),
                                                  onPressed: () async {
                                                    await AddUserDite();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "إضافة",
                                                    style: TextStyle(
                                                        fontFamily: "Arfont",
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          ),
                                        );
                                      });
                                    });
                              },
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "إضافة معلومات المستخدم",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Arfont",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          if (subscriptionDetails.isNotEmpty)
                            if (subscriptionDetails['approve'] != 'true' ||
                                subscriptionDetails['approve'] != 'fales' ||
                                subscriptionDetails['approve'] == null)
                              Expanded(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(180, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        backgroundColor:
                                            Color.fromARGB(255, 9, 202, 144)),
                                    onPressed: () {
                                      setState(() {
                                        Accsept = true;
                                      });
                                      _Accsept();
                                    },
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "قام المستخدم بطلب اشتراك | موافقة",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Arfont",
                                            color: Colors.white),
                                      ),
                                    )),
                              )
                          // ElevatedButton(
                          //     onPressed: () {
                          //       setState(() {
                          //         Accsept = false;
                          //       });
                          //       _Accsept();
                          //     },
                          //     child: Text("رفض")),
                          ,
                          SizedBox(
                            width: 100,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: _getTextAlignment(
                                        widget.User['firstName']),
                                    children: [
                                      Text(
                                        "${widget.User['firstName']}",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                          fontFamily: "Arfont",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              8), // إضافة مسافة صغيرة بين الاسمين
                                      Text(
                                        "${widget.User['lastName']}",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                          fontFamily: "Arfont",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    widget.User['username'],
                                    style: TextStyle(
                                      fontFamily: "Arfont",
                                      color: Color(0xffD1CECE),
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    widget.User['bundles'].isEmpty
                                        ? "غير مشترك"
                                        : "مشترك",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Arfont",
                                      color: widget.User['bundles'].isEmpty
                                          ? Color.fromARGB(255, 131, 10, 10)
                                          : Color.fromARGB(255, 6, 135, 17),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              maxRadius: 50,
                              child: ClipOval(
                                child: Image.network(
                                  "${widget.User['profile']}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                            width: 150, // العرض الذي تريده
                            height: double.infinity, // ملء الارتفاع المتاح
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: Column(
                                            children: [
                                              Text(
                                                "إضافة محتوى",
                                                style: TextStyle(
                                                  fontFamily: "Arfont",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: _nameController,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: "Arfont",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  hintText: "العنوان",
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffA6A6A6)),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 17.0,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Center(
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Color.fromARGB(
                                                              255,
                                                              135,
                                                              135,
                                                              135))),
                                                  child: Center(
                                                    child:
                                                        DropdownButton<String>(
                                                      hint: Text(
                                                          'اختر'), // النص التوضيحي قبل الاختيار
                                                      value:
                                                          _selectedValue, // القيمة المختارة حاليًا
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          _selectedValue =
                                                              newValue!;
                                                        });
                                                      },
                                                      items: _options.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (Map<String, String>
                                                              option) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value:
                                                              option['value'],
                                                          child: Text(
                                                            option['display']!,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Arfont"),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      underline: SizedBox
                                                          .shrink(), // إلغاء الخط أسفل القائمة
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                maxLines: 5,
                                                controller:
                                                    _decorationController,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: "Arfont",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  hintText: "تفاصيل",
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffA6A6A6)),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 17.0,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: _linkController,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: "Arfont",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  hintText: "رابط",
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffA6A6A6)),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 17.0,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller:
                                                    _PersentegController,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: "Arfont",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  hintText: "النسبة",
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffA6A6A6)),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 17.0,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, right: 10),
                                                child: _image == null
                                                    ? InkWell(
                                                        onTap: () async {
                                                          // قم بتحديث الصورة هنا
                                                          await _pickImage();
                                                          // قم بإعادة بناء الـ Dialog لتحديث الصورة
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          width: 300,
                                                          height: 180,
                                                          child: Center(
                                                            child: Text(
                                                              "+ إضافة صورة",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Arfont",
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      107,
                                                                      106,
                                                                      106)),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 300,
                                                        height: 180,
                                                        child: Center(
                                                          child: Image.file(
                                                            _image!,
                                                            fit: BoxFit.cover,
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
                                                          borderRadius:
                                                              BorderRadiusDirectional
                                                                  .circular(
                                                                      10)),
                                                      backgroundColor:
                                                          Colors.black),
                                                  onPressed: () async {
                                                    await AddContent();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "إضافة",
                                                    style: TextStyle(
                                                        fontFamily: "Arfont",
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "اضافة محتوى",
                                      style: TextStyle(
                                          fontFamily: "Arfont",
                                          color: const Color.fromARGB(
                                              255, 97, 97, 97)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Divider(
                                        color: Color.fromARGB(255, 97, 97, 97),
                                      ),
                                    ),
                                    Icon(
                                      Icons.add,
                                      color: Color.fromARGB(255, 97, 97, 97),
                                    )
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(width: 10),
                        Expanded(
                          child: widget.User['bundles'].isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "images/5822131.png",
                                        width: 200,
                                      ),
                                      Text(
                                        "المستخدم غير مشترك",
                                        style: TextStyle(
                                            fontFamily: "Arfont",
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.013),
                                      ),
                                    ],
                                  ),
                                )
                              : isLoading
                                  ? Center(
                                      child: LoadingAnimationWidget
                                          .fourRotatingDots(
                                        color: Colors.black,
                                        size: 100,
                                      ),
                                    )
                                  : isEmpty
                                      ? Center(
                                          child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "images/undraw_real_time_collaboration_c62i.png",
                                              width: 250,
                                            ),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "لا يوجد محتوى ،يمكنك اضافة محتوى جديد",
                                                style: TextStyle(
                                                    fontFamily: "Arfont",
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.013),
                                              ),
                                            ),
                                          ],
                                        )) // عرض رسالة البيانات الفارغة
                                      : GridView.builder(
                                          itemCount: packages.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                          ),
                                          itemBuilder: (context, index) {
                                            Color startColor;
                                            Color endColor;
                                            if (packages[index]['status'] ==
                                                'idle') {
                                              startColor = Color.fromARGB(
                                                  255, 150, 107, 20);
                                              endColor = Color(0xffFFBA31);
                                            } else if (packages[index]
                                                    ['status'] ==
                                                'approved') {
                                              startColor = const Color.fromARGB(
                                                  255, 54, 149, 244);
                                              endColor = Color(0xff2DFBCB);
                                            } else {
                                              startColor = const Color.fromARGB(
                                                  255, 54, 149, 244);
                                              endColor = Color(0xffF03139);
                                            }
                                            return InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    Color statusColor;
                                                    Color endColor;
                                                    if (packages[index]
                                                            ['status'] ==
                                                        'approved') {
                                                      statusColor =
                                                          Color(0xff2DFBCB);
                                                      endColor = Color.fromARGB(
                                                          255, 26, 159, 128);
                                                    } else if (packages[index]
                                                            ['status'] ==
                                                        'idle') {
                                                      statusColor =
                                                          Color(0xffF9A02B);
                                                      endColor = Color.fromARGB(
                                                          255, 118, 67, 1);
                                                    } else if (packages[index]
                                                            ['status'] ==
                                                        'rejected') {
                                                      statusColor =
                                                          Color(0xffF03139);
                                                      endColor = Color.fromARGB(
                                                          255, 120, 21, 26);
                                                    } else {
                                                      statusColor =
                                                          Colors.black;
                                                      endColor = Colors.black;
                                                    }

                                                    return Container(
                                                      // padding: EdgeInsets.only(
                                                      //     bottom:
                                                      //         MediaQuery.of(context)
                                                      //                 .size
                                                      //                 .height *
                                                      //             0.05),

                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .bottomCenter, // يبدأ التدرج من الأسفل
                                                          end: Alignment
                                                              .topCenter, // ينتهي التدرج إلى الأعلى
                                                          colors: [
                                                            endColor, // أسود في الأسفل
                                                            statusColor, // اللون الذي يتغير حسب الحالة (أخضر، برتقالي، أحمر)
                                                          ],
                                                        ),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child:
                                                                Image.network(
                                                              packages[index][
                                                                  'photo'], // الصورة المرتبطة بهذا الفهرس
                                                              fit: BoxFit.fill,
                                                              errorBuilder: (context,
                                                                      error,
                                                                      stackTrace) =>
                                                                  Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  10), // مسافة بين الصورة والنص
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    if (packages[index]
                                                                            [
                                                                            'status'] ==
                                                                        'approved')
                                                                      CircleAvatar(
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            235,
                                                                            235,
                                                                            235),
                                                                        maxRadius:
                                                                            15,
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          width:
                                                                              14,
                                                                          "images/check-mark-line-icon.svg",
                                                                        ),
                                                                      ),
                                                                    if (packages[index]
                                                                            [
                                                                            'status'] ==
                                                                        'idle')
                                                                      CircleAvatar(
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            235,
                                                                            235,
                                                                            235),
                                                                        maxRadius:
                                                                            15,
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          width:
                                                                              14,
                                                                          "images/clock-line-icon.svg",
                                                                        ),
                                                                      ),
                                                                    if (packages[index]
                                                                            [
                                                                            'status'] ==
                                                                        'rejected')
                                                                      CircleAvatar(
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            235,
                                                                            235,
                                                                            235),
                                                                        maxRadius:
                                                                            15,
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          width:
                                                                              14,
                                                                          "images/close-line-icon.svg",
                                                                        ),
                                                                      ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            187,
                                                                            86,
                                                                            4),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                10,
                                                                            horizontal:
                                                                                20),
                                                                        child:
                                                                            Text(
                                                                          packages[index]
                                                                              [
                                                                              'name'], // النص المرتبط بهذا الفهرس
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontFamily:
                                                                                "Arfont",
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        _getTypeText(packages[index]
                                                                            [
                                                                            'type']),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontFamily:
                                                                              "Arfont",
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                packages[index][
                                                                            'description'] !=
                                                                        null
                                                                    ? Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.03),
                                                                        child:
                                                                            AutoSizeText(
                                                                          packages[index]['description']
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          textDirection:
                                                                              TextDirection.rtl,
                                                                          style: TextStyle(
                                                                              fontFamily: "Arfont",
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      )
                                                                    : SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                Row(
                                                                  children: [
                                                                    if (packages[index]
                                                                            [
                                                                            'progress'] !=
                                                                        null)
                                                                      Container(
                                                                        width:
                                                                            65,
                                                                        height:
                                                                            65,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(5)),
                                                                        child:
                                                                            Center(
                                                                          child: CircularPercentIndicator(
                                                                              radius: 30.0, // حجم الدائرة
                                                                              lineWidth: 10.0, // سمك الخط
                                                                              animation: true,
                                                                              percent: packages[index]['progress'] / 100,
                                                                              center: Text(
                                                                                packages[index]['progress'].toString(), // عرض الرقم
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                                                              ),
                                                                              progressColor: endColor),
                                                                        ),
                                                                      ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    if (packages[index]
                                                                            [
                                                                            'link'] !=
                                                                        null)
                                                                      InkWell(
                                                                          onTap:
                                                                              () {
                                                                            launch("${packages[index]['link']}");
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                65,
                                                                            height:
                                                                                65,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                                                            child:
                                                                                Center(
                                                                              child: SvgPicture.asset(width: 25, "images/link-hyperlink-color-icon.svg"),
                                                                            ),
                                                                          )),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          255,
                                                          166,
                                                          166,
                                                          166), // لون الظل
                                                      spreadRadius:
                                                          1, // مدى انتشارة الظل
                                                      blurRadius:
                                                          1, // مقدار تمييع الظل
                                                      offset: Offset(0,
                                                          3), // اتجاه الظل (الافتراضي هو الأسفل)
                                                    ),
                                                  ],
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      startColor,
                                                      endColor
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                        horizontal:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.01,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          if (packages[index]
                                                                  ['status'] ==
                                                              'approved')
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          235,
                                                                          235,
                                                                          235),
                                                              maxRadius: 15,
                                                              child: SvgPicture
                                                                  .asset(
                                                                width: 14,
                                                                "images/check-mark-line-icon.svg",
                                                              ),
                                                            ),
                                                          if (packages[index]
                                                                  ['status'] ==
                                                              'idle')
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          235,
                                                                          235,
                                                                          235),
                                                              maxRadius: 15,
                                                              child: SvgPicture
                                                                  .asset(
                                                                width: 14,
                                                                "images/clock-line-icon.svg",
                                                              ),
                                                            ),
                                                          if (packages[index]
                                                                  ['status'] ==
                                                              'rejected')
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          235,
                                                                          235,
                                                                          235),
                                                              maxRadius: 15,
                                                              child: SvgPicture
                                                                  .asset(
                                                                width: 14,
                                                                "images/close-line-icon.svg",
                                                              ),
                                                            ),
                                                          SizedBox(width: 10),
                                                          FittedBox(
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            child: Text(
                                                              packages[index]
                                                                  ['name'],
                                                              style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.01,
                                                                fontFamily:
                                                                    "Arfont",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Stack(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 10),
                                                              child: packages[index]
                                                                          [
                                                                          'photo'] !=
                                                                      null
                                                                  ? ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        bottomLeft:
                                                                            Radius.circular(20),
                                                                        bottomRight:
                                                                            Radius.circular(20),
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        "${packages[index]['photo'].toString()}",
                                                                      ),
                                                                    )
                                                                  : SizedBox(),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            right: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.02,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.2),
                                                                          spreadRadius:
                                                                              1,
                                                                          blurRadius:
                                                                              10,
                                                                          offset: Offset(
                                                                              0,
                                                                              5),
                                                                        ),
                                                                      ],
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          240,
                                                                          240,
                                                                          240),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    height: 35,
                                                                    width: 100,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            5.0),
                                                                        child:
                                                                            FittedBox(
                                                                          fit: BoxFit
                                                                              .scaleDown,
                                                                          child:
                                                                              Text(
                                                                            _getTypeText(packages[index]['type']),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                              fontFamily: "Arfont",
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                            textDirection:
                                                                                TextDirection.rtl,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: MediaQuery.of(context).size.height *
                                                                            0.13,
                                                                        top: MediaQuery.of(context).size.height *
                                                                            0.19),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return AlertDialog(
                                                                                title: Center(
                                                                                  child: Text(
                                                                                    "تاكيد الحذف",
                                                                                    style: TextStyle(
                                                                                      fontFamily: "Arfont",
                                                                                      color: Color.fromARGB(255, 121, 25, 18),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                content: Text(
                                                                                  "هل انت متاكد من  حذف هذا المحتوى ؟",
                                                                                  style: TextStyle(fontFamily: "Arfont", color: Colors.black),
                                                                                ),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        contentId = packages[index]["_id"];
                                                                                      });

                                                                                      print(contentId);
                                                                                      contentesDelete_();
                                                                                    },
                                                                                    child: Text(
                                                                                      "حذف",
                                                                                      style: TextStyle(
                                                                                        fontFamily: "Arfont",
                                                                                        color: Color.fromARGB(255, 121, 25, 18),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                      child: Text(
                                                                                        "رجوع",
                                                                                        style: TextStyle(fontFamily: "Arfont", color: Colors.black),
                                                                                      ))
                                                                                ],
                                                                              );
                                                                            });
                                                                      },
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            121,
                                                                            25,
                                                                            18),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Icon(
                                                                            Icons.delete,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String label,
      required String icon,
      required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.width * 0.004),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.002),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: "Arfont",
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 30,
                  child: SvgPicture.asset(
                    icon,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
