import 'package:flutter/material.dart';
import 'package:second_trip_project/screen/ChangePasswordScreen.dart';
import 'package:second_trip_project/screen/InquiryScreen.dart';
import 'package:second_trip_project/screen/MyPageScreen.dart';
import 'package:second_trip_project/screen/EditProfileScreen.dart';
import 'package:second_trip_project/screen/MyPostsScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel-Hub Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF004680)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      // 1. 일단 마이페이지가 바로 뜨도록 설정
      home: const MyPageScreen(),

      // 2. 경로 등록 (이걸 해둬야 톱니바퀴 눌렀을 때 이동이 돼!)
      routes: {
        '/mypage': (context) => const MyPageScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/change_password': (context) => const ChangePasswordScreen(),
        '/my_posts': (context) => const MyPostsScreen(),
        '/inquiry': (context) => const InquiryScreen(),
      },
    );
  }
}