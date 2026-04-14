import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPwController = TextEditingController();
  final TextEditingController newPwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  bool _isCurrentVisible = false;
  bool _isNewVisible = false;
  bool _isConfirmVisible = false;

  final Color classicBlue = const Color(0xFF004680);

  InputDecoration _buildAppleInput(String label, bool isVisible, VoidCallback toggle) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[50],
      prefixIcon: const Icon(CupertinoIcons.lock, size: 20),
      suffixIcon: IconButton(
        icon: Icon(isVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash, size: 20),
        onPressed: toggle,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('비밀번호 변경', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildPasswordField("현재 비밀번호", currentPwController, _isCurrentVisible, () => setState(() => _isCurrentVisible = !_isCurrentVisible)),
            const SizedBox(height: 16),
            const Divider(height: 40),
            _buildPasswordField("새 비밀번호", newPwController, _isNewVisible, () => setState(() => _isNewVisible = !_isNewVisible)),
            const SizedBox(height: 16),
            _buildPasswordField("새 비밀번호 확인", confirmPwController, _isConfirmVisible, () => setState(() => _isConfirmVisible = !_isConfirmVisible)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // 여기서 로직 체크 (새 비번이 일치하는지 등)
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: classicBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('비밀번호 변경 완료', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool visible, VoidCallback toggle) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      decoration: _buildAppleInput(label, visible, toggle),
    );
  }
}