import 'package:flutter/material.dart';
import 'package:second_trip_project/screen/LoginScreen.dart';  // 로그인 화면 파일
import 'package:second_trip_project/screen/SignUpScreen.dart'; // 회원가입 화면 파일

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel-Hub',
      debugShowCheckedModeBanner: false, // 오른쪽 상단 DEBUG 띠 제거
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF004680)), // 클래식 블루 기반
        useMaterial3: true,
      ),
      // 1. 처음 뜰 화면을 로그인 화면으로 설정
      home: const LoginScreen(),

      // 2. 화면 이동 경로(Route) 설정
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}

// 로그인, 회원가입 페이지