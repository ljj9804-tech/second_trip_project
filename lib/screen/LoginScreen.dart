import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. 컨트롤러 선언
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 비밀번호 보이기 상태 관리
  bool _isPasswordVisible = false;

  // 포인트 컬러: 클래식 블루
  final Color classicBlue = const Color(0xFF004680);

  // 애플 스타일 입력창 장식 함수 (재사용)
  InputDecoration _buildAppleInputDecoration(String labelText, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
      suffixIcon: suffixIcon,
      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      filled: true,
      fillColor: Colors.grey[50],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: classicBlue, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 로그인 첫 화면이므로 leading(뒤로가기)은 제거하거나 필요시 유지
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // --- 상단 로고 & 타이틀 ---
                Center(
                  child: Column(
                    children: [
                      Icon(CupertinoIcons.paperplane_fill, size: 80, color: classicBlue),
                      const SizedBox(height: 16),
                      const Text(
                        'Travel-Hub',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -1),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '스마트 통합 여행 매니지먼트',
                        style: TextStyle(color: Colors.grey[500], fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                // --- 이메일 입력 ---
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildAppleInputDecoration('이메일', CupertinoIcons.mail),
                ),
                const SizedBox(height: 16),

                // --- 패스워드 입력 ---
                TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: _buildAppleInputDecoration(
                    '패스워드',
                    CupertinoIcons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('비밀번호를 잊으셨나요?', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 30),

                // --- 로그인 버튼 ---
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('로그인 정보'),
                          content: Text('아이디: ${emailController.text}\n로그인을 시도합니다.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인')),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: classicBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('로그인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 24),

                // --- 회원가입 유도 (이동 로직 추가!) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('아직 회원이 아니신가요?', style: TextStyle(color: Colors.grey[600])),
                    TextButton(
                      onPressed: () {
                        // ⭐ main.dart에 설정한 '/signup' 경로로 이동!
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text('회원가입',
                          style: TextStyle(color: classicBlue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}