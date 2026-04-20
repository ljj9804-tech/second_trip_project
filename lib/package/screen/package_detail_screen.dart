import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../services/member_service.dart';
import '../model/package_item.dart';

class PackageDetailScreen extends StatefulWidget {
  static bool isTesting = false;
  final PackageItem item;
  final MemberService? memberService;

  const PackageDetailScreen({
    super.key,
    required this.item,
    this.memberService,
  });

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  final NumberFormat _numberFormat = NumberFormat('#,###');
  late final MemberService _memberService;
  int _selectedPeople = 1;

  @override
  void initState() {
    super.initState();
    _memberService = widget.memberService ?? MemberService();
  }

  // --- 1. 비즈니스 로직 ---

  Future<void> _processBooking(BuildContext context) async {
    if (PackageDetailScreen.isTesting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("테스트 패키지 예약이 완료되었습니다!")),
      );
      return;
    }

    // 로그인 상태 체크
    final bool isLoggedIn = await _memberService.checkLoginStatus();
    if (!isLoggedIn) {
      if (!context.mounted) return;
      _showLoginDialog(context);
      return;
    }

    // 예약 API 호출 로직
    try {
      final userInfo = await _memberService.getUserInfo();
      final String userEmail = userInfo['email'] ?? '';
      final String accessToken = await _memberService.getAccessToken() ?? '';
      final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';
      final int totalPrice = widget.item.price * _selectedPeople;

      final response = await http.post(
        Uri.parse('$baseUrl/api/reservations/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode({
          "memberId": userEmail,
          "packageId": widget.item.id,
          "reservationDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "peopleCount": _selectedPeople,
          "totalPrice": totalPrice,
        }),
      );

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${widget.item.title} $_selectedPeople명 예약 완료!")),
        );
      } else {
        throw Exception('서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("예약에 실패했습니다.")),
        );
      }
    }
  }

  // --- 2. UI 및 다이얼로그 ---

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("로그인 필요"),
        content: const Text("로그인 후 이용 가능한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소")
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
            },
            child: const Text("로그인하러 가기"),
          ),
        ],
      ),
    );
  }

  void _showReservationConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("예약 확인"),
        content: Text("총 $_selectedPeople명, ${_numberFormat.format(widget.item.price * _selectedPeople)}원을 예약하시겠습니까?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소")
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // 먼저 다이얼로그 닫기
              await _processBooking(context);
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.title)),
      bottomNavigationBar: _buildBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildThumbnail(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("${_numberFormat.format(widget.item.price)}원 / 1인", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  const SizedBox(height: 20),
                  _buildPeopleSelector(),
                  const Divider(height: 40),
                  _buildSectionTitle("포함사항"),
                  Text(widget.item.inclusions.join(", ")),
                  const SizedBox(height: 20),
                  _buildSectionTitle("여행 일정"),
                  ...widget.item.itinerary.map((day) => Text("Day ${day['day']}: ${day['activities'].join(", ")}")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea( // 💡 이 위젯을 추가하세요
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(vertical: 16)),
          onPressed: () {
            _memberService.checkLoginStatus().then((isLoggedIn) {
              if (!mounted) return;
              if (!isLoggedIn) {
                _showLoginDialog(context);
              } else {
                _showReservationConfirmDialog(context);
              }
            });
          },
          child: const Text("예약하기", style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildPeopleSelector() {
    return Row(
      children: [
        const Text("인원수: ", style: TextStyle(fontSize: 16)),
        IconButton(
          onPressed: () {
            if (_selectedPeople > widget.item.minPeople) {
              setState(() => _selectedPeople--);
            }
          },
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text("$_selectedPeople 명", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: () {
            if (_selectedPeople < widget.item.maxPeople) {
              setState(() => _selectedPeople++);
            }
          },
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  Widget _buildThumbnail() {
    return PackageDetailScreen.isTesting
        ? Container(height: 250, color: Colors.grey)
        : Image.network(widget.item.thumbnail, height: 250, width: double.infinity, fit: BoxFit.cover);
  }

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
}