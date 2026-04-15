import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_trip_project/car/controller/rent_comp_controller.dart';
import 'package:second_trip_project/car/model/comp_model.dart';

class CarRentScreen extends StatefulWidget {
  const CarRentScreen({super.key});

  @override
  State<CarRentScreen> createState() => _CarRentScreenState();
}

class _CarRentScreenState extends State<CarRentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RentCompController>().fetchInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('도시별 렌터카')),
      body: Consumer<RentCompController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(controller.errorMessage!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<RentCompController>().fetchInitial(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          if (controller.regionItems.isEmpty) {
            return const Center(child: Text('데이터가 없습니다.'));
          }

          return ListView(
            children: controller.regions.map((region) {
              final items = controller.regionItems[region] ?? [];
              return _CitySection(city: region, items: items);
            }).toList(),
          );
        },
      ),
    );
  }
}

class _CitySection extends StatelessWidget {
  final String city;
  final List<CompModel> items;
  //city와 item의 변경이 있는 부분만 빌드 할때 다시 그림 아니면 그대로 둠(함수로 하면 다시 그릴대 무조건 다시 다 그림)
  //Consumer는 "언제 다시 그릴지"를 정하고, 위젯 클래스는 "다시 그릴 때 뭘 스킵할지"를 정하는 거
  const _CitySection({required this.city, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '$city (${items.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('해당 지역 데이터 없음', style: TextStyle(color: Colors.grey)),
          )
        else
          ...items.map((item) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.directions_car, color: Colors.blueGrey),
              title: Text(item.name ?? '이름 없음'),
              subtitle: Text(
                item.road ?? item.address ?? '주소 없음',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => CarListView(company: item),
                //   ),
                // );
              },
            ),
          )),
        const Divider(),
      ],
    );
  }
}