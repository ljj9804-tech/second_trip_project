import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:second_trip_project/car/controller/rent_comp_controller.dart';
import 'package:second_trip_project/car/screen/car_rent_home_screen.dart';
import 'package:second_trip_project/car/screen/car_rent_screen.dart';
import 'package:second_trip_project/car/screen/table_calendar_screen.dart';
import 'package:second_trip_project/screen/ChangePasswordScreen.dart';
import 'package:second_trip_project/screen/InquiryScreen.dart';
import 'package:second_trip_project/screen/MyPageScreen.dart';
import 'package:second_trip_project/screen/EditProfileScreen.dart';
import 'package:second_trip_project/screen/MyPostsScreen.dart';
import 'package:second_trip_project/screen/RoutingScreen.dart';

import 'car/controller/calendar_controller.dart';
import 'basic2-miniproject/MainScreen.dart';
import 'basic2-miniproject/SplashScreen.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: '.env');
//   // runApp(const MyApp());
//   runApp(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(
//             create: (_) => RentCompController(),
//           ),
//           ChangeNotifierProvider(
//             create: (_) => CalendarController(),
//           ),
//         ],
//         child: const RoutingScreen(),
//       )
//   );
// }

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
          // 2. 성규님 작업 (깔끔하게 정리)
          '/': (context) => const SplashScreen(), // 스플래시 화면
          '/main': (context) => const MainScreen(), // 메인 화면

          // --- 메인 화면 버튼 라우트 ---
          '/login': (context) =>
          const Scaffold(body: Center(child: Text('로그인 화면'))),
          '/signup': (context) =>
          const Scaffold(body: Center(child: Text('회원가입 화면'))),

          // --- 연습용 및 숙소 카테고리 라우트 ---
          '/publicDataTest': (context) =>
          const Scaffold(body: Center(child: Text('공공데이터 테스트'))),
          '/mapBasic1': (context) =>
          const Scaffold(body: Center(child: Text('지도 서비스 테스트'))),
          '/dbTest2': (context) =>
          const Scaffold(body: Center(child: Text('DB ORM 테스트'))),
          '/todosMain': (context) =>
          const Scaffold(body: Center(child: Text('스프링 연결 연습'))),
          '/hotel': (context) =>
          const Scaffold(body: Center(child: Text('호텔·리조트 화면'))),
          '/motel': (context) =>
          const Scaffold(body: Center(child: Text('모텔 화면'))),
        }, // routes 맵 닫기
    ); // <- 여기에 소괄호 ')'를 넣어서 MaterialApp 위젯을 닫아주세요!
  }
}