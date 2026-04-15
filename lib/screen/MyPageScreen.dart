import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  final Color classicBlue = const Color(0xFF004680);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // 배경은 아주 연한 그레이
      appBar: AppBar(
        title: const Text('마이페이지', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // 메인급 화면이라 백버튼 자동생성 방지
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. 프로필 섹션
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: classicBlue.withOpacity(0.1),
                    child: Icon(CupertinoIcons.person_fill, size: 40, color: classicBlue),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('박금동', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('jihyo@travelhub.com', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(CupertinoIcons.settings, color: Colors.grey),
                    onPressed: () {
                      // ⭐ 설정 페이지(회원 정보 수정)로 이동!
                      Navigator.pushNamed(context, '/edit_profile');
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 2. 활동 요약 섹션 (예약 / 리뷰 / 찜)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('내 예약', '3'),
                  _buildStatLine(),
                  _buildStatItem('내 리뷰', '12'),
                  _buildStatLine(),
                  _buildStatItem('찜 목록', '25'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 3. 메뉴 리스트 섹션
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  // ⭐ 내 게시글 관리 연결
                  _buildMenuItem(
                    CupertinoIcons.doc_text,
                    '내 게시글 관리',
                    onTap: () => Navigator.pushNamed(context, '/my_posts'),
                  ),
                  _buildMenuItem(
                    CupertinoIcons.chat_bubble_2,
                    '1:1 문의 내역',
                    onTap: () {Navigator.pushNamed(context, '/inquiry');}, // 나중에 기능 추가!
                  ),
                  _buildMenuItem(
                    CupertinoIcons.info_circle,
                    '고객센터',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    CupertinoIcons.square_arrow_right,
                    '로그아웃',
                    isLast: true,
                    textColor: Colors.red,
                    onTap: () {
                      // 로그아웃 시 로그인 화면으로 이동
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 통계 아이템 위젯
  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: classicBlue)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  // 구분선
  Widget _buildStatLine() {
    return Container(width: 1, height: 30, color: Colors.grey[200]);
  }

  // 메뉴 아이템 위젯 (onTap 추가됨!)
  Widget _buildMenuItem(IconData icon, String title, {bool isLast = false, Color? textColor, VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: textColor ?? Colors.black87, size: 22),
          title: Text(title, style: TextStyle(fontSize: 15, color: textColor ?? Colors.black87, fontWeight: FontWeight.w500)),
          trailing: const Icon(CupertinoIcons.chevron_forward, size: 16, color: Colors.grey),
          onTap: onTap, // ⭐ 여기서 전달받은 함수를 실행해!
        ),
        if (!isLast) Divider(indent: 56, height: 1, color: Colors.grey[100]),
      ],
    );
  }
}