import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController(text: "박금동");
  final TextEditingController phoneController = TextEditingController(text: "010-1234-5678");
  final Color classicBlue = const Color(0xFF004680);

  // 회원 탈퇴 확인 다이얼로그 함수
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('회원 탈퇴', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('정말로 탈퇴하시겠습니까?\n탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.'),
          actions: [
            // 취소: 창 닫기
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소', style: TextStyle(color: Colors.grey)),
            ),
            // 탈퇴하기: 로그인 화면으로 이동
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                // 모든 화면 기록을 지우고 로그인 화면으로 이동
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('회원 탈퇴가 완료되었습니다.')),
                );
              },
              child: const Text('탈퇴하기', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('회원 정보 수정', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('완료', style: TextStyle(color: Color(0xFF004680), fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 프로필 사진 변경 섹션
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[100],
                    child: Icon(CupertinoIcons.person_fill, size: 50, color: classicBlue),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: 이미지 선택 로직 (필요 시)
                    },
                    child: const Text('프로필 사진 변경', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 정보 수정 입력창들
            _buildEditField('이름', nameController, CupertinoIcons.person),
            const SizedBox(height: 20),
            _buildEditField('전화번호', phoneController, CupertinoIcons.phone),
            const SizedBox(height: 40),

            // 비밀번호 변경 메뉴
            ListTile(
              title: const Text('비밀번호 변경'),
              subtitle: const Text('보안을 위해 주기적으로 변경해주세요', style: TextStyle(fontSize: 12)),
              trailing: const Icon(CupertinoIcons.chevron_forward, size: 18),
              onTap: () {
                Navigator.pushNamed(context, '/change_password');
              },
            ),
            const Divider(),

            // 회원 탈퇴 메뉴
            ListTile(
              title: const Text('회원 탈퇴', style: TextStyle(color: Colors.red)),
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 공통 입력 필드 위젯
  Widget _buildEditField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}