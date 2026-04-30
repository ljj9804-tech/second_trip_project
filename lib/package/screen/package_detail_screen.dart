import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/package_item_dto.dart';
import '../../util/secure_storage_helper.dart';

class PackageDetailScreen extends StatefulWidget {
  final PackageItemDTO item;

  const PackageDetailScreen({super.key, required this.item});

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  final NumberFormat _numberFormat = NumberFormat('#,###');
  final _storage = SecureStorageHelper();
  int _selectedPeople = 1;

  @override
  void initState() {
    super.initState();
    // DTO의 minPeople 참조
    _selectedPeople = widget.item.minPeople ?? 1;
  }

  // --- 팝업 및 이동 로직 ---

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("로그인 필요"),
        content: const Text("예약하려면 로그인이 필요합니다.\n로그인 페이지로 이동하시겠습니까?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // arguments를 넘겨 로그인 후 돌아올 수 있도록 처리
              Navigator.pushNamed(context, '/login', arguments: 'from_detail');
            },
            child: const Text("로그인하러 가기"),
          ),
        ],
      ),
    );
  }

  void _showReservationConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("예약 확인"),
        content: Text(
            "총 $_selectedPeople명, ${_numberFormat.format((widget.item.price ?? 0) * _selectedPeople)}원을 예약하시겠습니까?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("예약 요청이 전송되었습니다.")),
              );
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  // --- 화면 구성 위젯 ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("패키지 상세", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 대표 이미지 (thumbnail 필드 참조)
            _buildImageSection(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. 태그 리스트 (tags 필드 참조)
                  if (widget.item.tags != null && widget.item.tags!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        widget.item.tags!.join(" "),
                        style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500),
                      ),
                    ),

                  // 3. 제목 및 가격 (title, price 필드 참조)
                  Text(widget.item.title ?? "상품 제목",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    "${_numberFormat.format(widget.item.price ?? 0)}원 / 1인",
                    style: const TextStyle(fontSize: 20, color: Color(0xFFF7323F), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // 4. 주요 요약 정보 카드 (region, min/maxPeople 필드 참조)
                  _buildSummaryCard(),
                  const Divider(height: 40),

                  // 5. 인원 선택
                  _buildPeopleSelector(),
                  const Divider(height: 40),

                  // 6. 상세 내용 섹션 (List<String> 타입을 문자열로 변환하여 출력)
                  _buildDetailSection("📝 상품 설명", widget.item.description),
                  _buildListSection("✅ 포함 사항", widget.item.inclusions, Colors.blue[700]!),
                  _buildListSection("❌ 불포함 사항", widget.item.exclusions, Colors.red[700]!),

                  // 7. 카테고리 정보 표시
                  if (widget.item.category != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),

                  // 하단 여백
                  SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Image.network(
      widget.item.thumbnail ?? '',
      height: 250,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Container(height: 250, color: Colors.grey[200], child: const Icon(Icons.image, size: 50)),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconInfo(Icons.location_on_outlined, "지역", widget.item.region ?? "전국"),
          _buildIconInfo(Icons.group_outlined, "인원", "${widget.item.minPeople ?? 1}~${widget.item.maxPeople ?? 10}"),
          _buildIconInfo(Icons.category_outlined, "유형", widget.item.category ?? "일반"),
        ],
      ),
    );
  }

  Widget _buildIconInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700], size: 22),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPeopleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("예약 인원", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (_selectedPeople > (widget.item.minPeople ?? 1)) setState(() => _selectedPeople--);
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text("$_selectedPeople 명", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: () {
                if (_selectedPeople < (widget.item.maxPeople ?? 10)) setState(() => _selectedPeople++);
              },
              icon: const Icon(Icons.add_circle_outline, color: Color(0xFFF7323F)),
            ),
          ],
        ),
      ],
    );
  }

  // 일반 텍스트 섹션용
  Widget _buildDetailSection(String title, String? content) {
    if (content == null || content.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(content, style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87)),
        const SizedBox(height: 30),
      ],
    );
  }

  // List<String> 타입 섹션용 (inclusions, exclusions 전용)
  Widget _buildListSection(String title, List<String>? items, Color color) {
    if (items == null || items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        // 리스트의 각 항목 앞에 '•'를 붙여서 나열
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• ", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              Expanded(child: Text(item, style: TextStyle(fontSize: 15, color: color))),
            ],
          ),
        )),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF7323F), // 여기어때 레드 컬러
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final token = await _storage.getAccessToken();
              if (token == null || token.isEmpty) {
                _showLoginDialog();
              } else {
                _showReservationConfirmDialog();
              }
            },
            child: const Text("예약하기", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}