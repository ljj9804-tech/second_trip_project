import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_trip_project/screen/ChangePasswordScreen.dart';
import 'package:second_trip_project/screen/InquiryScreen.dart';
import 'package:second_trip_project/screen/MyPageScreen.dart';
import 'package:second_trip_project/screen/EditProfileScreen.dart';
import 'package:second_trip_project/screen/MyPostsScreen.dart';

import 'basic2-miniproject/MainScreen.dart';
import 'basic2-miniproject/SplashScreen.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Yeogiyeoddae Clone',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      // 앱 실행 시 처음 보여줄 화면 (스플래시 화면)
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), // 스플래시 화면
        '/main': (context) => const MainScreen(), // 메인 화면

        // --- 메인 화면의 메뉴 및 버튼 라우트들 ---
        '/login': (context) => const Scaffold(body: Center(child: Text('로그인 화면'))),
        '/signup': (context) => const Scaffold(body: Center(child: Text('회원가입 화면'))),

        // 연습용 메뉴 라우트 (기존 코드 벤치마킹)
        '/publicDataTest': (context) => const Scaffold(body: Center(child: Text('공공데이터 테스트'))),
        '/mapBasic1': (context) => const Scaffold(body: Center(child: Text('지도 서비스 테스트'))),
        '/dbTest2': (context) => const Scaffold(body: Center(child: Text('DB ORM 테스트'))),
        '/todosMain': (context) => const Scaffold(body: Center(child: Text('스프링 연결 연습'))),

        // 숙소 카테고리 라우트
        '/hotel': (context) => const Scaffold(body: Center(child: Text('호텔·리조트 화면'))),
        '/motel': (context) => const Scaffold(body: Center(child: Text('모텔 화면'))),
        // ... 필요한 만큼 추가 가능
      },
    );
  }
}