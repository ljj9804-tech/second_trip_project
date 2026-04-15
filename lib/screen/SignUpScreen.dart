import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // ⭐ 비밀번호 보이기 상태 관리 변수 추가
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;

  final Color classicBlue = const Color(0xFF004680);

  // 애플 스타일 텍스트 필드 장식 함수 (눈 아이콘 버튼 추가)
  InputDecoration _buildAppleInputDecoration(
      String labelText,
      IconData icon, {
        Widget? suffixIcon, // 눈 아이콘을 넣기 위한 매개변수 추가
      }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
      suffixIcon: suffixIcon, // 오른쪽에 아이콘 배치
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
        title: const Text('회원가입',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text('필수 정보 입력',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3)),
                const SizedBox(height: 12),
                Text('All-In-One 트래픽 플랫폼 서비스를 시작해보세요.',
                    style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                const SizedBox(height: 40),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildAppleInputDecoration('이메일(아이디)', CupertinoIcons.mail),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: classicBlue),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          foregroundColor: classicBlue,
                        ),
                        child: const Text('중복확인', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                TextField(
                  controller: nameController,
                  decoration: _buildAppleInputDecoration('이름', CupertinoIcons.person),
                ),
                const SizedBox(height: 18),

                // ⭐ 패스워드 입력 (눈 아이콘 적용)
                TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible, // 상태에 따라 보이기/숨기기
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
                const SizedBox(height: 18),

                // ⭐ 패스워드 확인 입력 (눈 아이콘 적용)
                TextField(
                  controller: passwordConfirmController,
                  obscureText: !_isPasswordConfirmVisible, // 상태에 따라 보이기/숨기기
                  decoration: _buildAppleInputDecoration(
                    '패스워드 확인',
                    CupertinoIcons.lock_shield,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordConfirmVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildAppleInputDecoration('전화번호', CupertinoIcons.phone),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: classicBlue,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('가입하기'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}