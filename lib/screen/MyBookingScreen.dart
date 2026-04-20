import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_trip_project/airport/screen/my_reservation_screen.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  // ✅ 원본 방식 유지 - 모달창으로 열기
  void _openDialog(BuildContext context, BookingType type) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '닫기',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
      pageBuilder: (_, __, ___) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: MyReservationScreen(type: type, isModal: true,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          '내 예약 내역',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '카테고리를 선택하세요',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
                children: [
                  // ── 항공 ────────────────────────────────
                  _CategoryCard(
                    label: '항공',
                    subtitle: '국내선 항공 예약',
                    icon: CupertinoIcons.airplane,
                    color: const Color(0xFF3B6FE8),
                    bgColor: const Color(0xFFEEF4FF),
                    onTap: () => _openDialog(context, BookingType.flight),
                  ),
                  // ── 숙소 ────────────────────────────────
                  _CategoryCard(
                    label: '숙소',
                    subtitle: '호텔/펜션 예약',
                    icon: CupertinoIcons.bed_double_fill,
                    color: const Color(0xFF1D9E75),
                    bgColor: const Color(0xFFEDFAF5),
                    onTap: () => _openDialog(context, BookingType.hotel),
                  ),
                  // ── 렌터카 ──────────────────────────────
                  _CategoryCard(
                    label: '렌터카',
                    subtitle: '차량 렌탈 예약',
                    icon: CupertinoIcons.car_fill,
                    color: const Color(0xFFEF9F27),
                    bgColor: const Color(0xFFFFF8ED),
                    onTap: () => _openDialog(context, BookingType.rental),
                  ),
                  // ── 패키지 ──────────────────────────────
                  // TODO: 패키지 담당자 - my_reservation_screen.dart 의 _packageBody() 교체
                  _CategoryCard(
                    label: '패키지',
                    subtitle: '여행 패키지 예약',
                    icon: CupertinoIcons.gift_fill,
                    color: const Color(0xFF7F77DD),
                    bgColor: const Color(0xFFF3F0FF),
                    onTap: () => _openDialog(context, BookingType.package),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 카테고리 카드 위젯 ────────────────────────────────────
class _CategoryCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── 아이콘 영역 ──────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                color: bgColor,
                child: Icon(icon, size: 36, color: color),
              ),

              // ── 텍스트 영역 ──────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // 제목 + 부제목
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      // ── 예약 내역 보기 + 화살표 ─────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '예약 내역 보기',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: color,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.chevron_forward,
                            size: 14,
                            color: color,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}