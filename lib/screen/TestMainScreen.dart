import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestMainScreen extends StatelessWidget {
  const TestMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('메인 화면')),
      body: SafeArea(
        child: ListView (
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Center(child: FlutterLogo(size: 100)),
            Center(
              // child: FlutterLogo(size: 100)
              child: Image.asset(
                'assets/images/bug.jpg',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/mypage'),
              child: const Text('mypage'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/edit_profile'),
              child: const Text('edit_profile'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/change_password'),
              child: const Text('change_password'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/my_posts'),
              child: const Text('my_posts'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/inquiry'),
              child: const Text('inquiry'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/car_rent'),
              child: const Text('car_rent'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/car_rent_home'),
              child: const Text('car_rent_home'),
            ),
          ],
        ),
      ),
    );
  }
}