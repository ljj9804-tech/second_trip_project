import 'package:flutter/material.dart';

class WriteInquiryScreen extends StatefulWidget {
  const WriteInquiryScreen({super.key});

  @override
  State<WriteInquiryScreen> createState() => _WriteInquiryScreenState();
}

class _WriteInquiryScreenState extends State<WriteInquiryScreen> {
  final Color classicBlue = const Color(0xFF004680);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String _selectedCategory = '기타';
  final List<String> _categories = ['예약/결제', '취소/환불', '이용문의', '기타'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('1:1 문의하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 나중에 서버 API 연결할 곳!
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('문의가 등록되었습니다.')));
              Navigator.pop(context);
            },
            child: Text('등록', style: TextStyle(color: classicBlue, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('문의 유형', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            _buildDropdown(),
            const SizedBox(height: 24),
            const Text('제목', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            _buildTextField(_titleController, '제목을 입력해주세요'),
            const SizedBox(height: 24),
            const Text('문의 내용', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            _buildTextField(_contentController, '문의 내용을 상세히 입력해주세요 (최대 500자)', maxLines: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          items: _categories.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
          onChanged: (val) => setState(() => _selectedCategory = val!),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: classicBlue), borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}