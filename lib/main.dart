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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  // runApp(const MyApp());
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => RentCompController(),
          ),
          ChangeNotifierProvider(
            create: (_) => CalendarController(),
          ),
        ],
        child: const RoutingScreen(),
      )
  );
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
        '/car_rent': (context) => const TableCalendarScreen(),
        '/car_rent_home': (context) => const CarRentHomeScreen(),
      },
    );
  }
}