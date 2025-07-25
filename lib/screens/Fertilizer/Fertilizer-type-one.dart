import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sand_valley/providers/app_state.dart';
import 'package:sand_valley/widgets/background_container.dart';
import 'package:sand_valley/widgets/customButton.dart';
import 'package:sand_valley/widgets/customWidget2.dart';
import 'package:sand_valley/widgets/customWidget2Reversed.dart';
import 'package:sand_valley/widgets/roundedContainer.dart';

class FertilizerTypeOnePage extends StatefulWidget {
  const FertilizerTypeOnePage({super.key});

  @override
  State<FertilizerTypeOnePage> createState() => _FertilizerTypeOnePageState();
}

class _FertilizerTypeOnePageState extends State<FertilizerTypeOnePage> {
  late String fertilizerId;
  late String fertilizerName;
  List<dynamic> types = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    fertilizerId = args['id'];
    fertilizerName = args['name'];
    _fetchFertilizerTypes();
  }

  Future<void> _fetchFertilizerTypes() async {
    setState(() => _isLoading = true);
    try {
      final baseUrl = Provider.of<AppState>(context, listen: false).baseUrl;

      final response = await http.get(
        Uri.parse('$baseUrl/get-fertilizer-type/$fertilizerId'),
      );

      final data = json.decode(response.body);
      final List<dynamic> fetchedTypes = data['data']['Type'] ?? [];

      setState(() {
        types = fetchedTypes;
      });
    } catch (e) {
      debugPrint("❌ Error fetching types: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff7B970C),
        toolbarHeight: 5,
      ),
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff7B970C).withOpacity(0.69),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: CustomButton(
                        buttonColor: const Color(0xff7B970C),
                        routeName: '/fertilizer-main',
                        icon: Image.asset(
                          'assets/images/arrow.png',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 70),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  fertilizerName,
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: RoundedContainer(
                        image: 'assets/images/fertilizer.png',
                      ),
                    ),
                  ],
                ),
              ),

              // Type List
              Expanded(
                child:
                    _isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff7B970C),
                          ),
                        )
                        : types.isEmpty
                        ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.grass, color: Colors.grey, size: 40),
                              SizedBox(height: 10),
                              Text(
                                'لا توجد أنواع متاحة لهذا السماد',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          itemCount: types.length,
                          itemBuilder: (context, index) {
                            final type = types[index];
                            final isEven = index % 2 == 0;

                            final hasDescription =
                                type['description']
                                    ?.toString()
                                    .trim()
                                    .isNotEmpty ==
                                true;
                            final hasCompany =
                                type['company']?.toString().trim().isNotEmpty ==
                                true;
                            final hasNestedType =
                                type['Type'] != null &&
                                type['Type'] is List &&
                                type['Type'].isNotEmpty;

                            final routeName =
                                hasDescription && hasCompany
                                    ? '/fertilizer-description'
                                    : hasNestedType
                                    ? '/fertilizer-type-two'
                                    : null;

                            final arguments =
                                hasDescription && hasCompany
                                    ? {
                                      'name': type['name'],
                                      'description': type['description'],
                                      'company': type['company'],
                                      'image': type['img']['url'], // optional
                                    }
                                    : hasNestedType
                                    ? {
                                      'categoryId': fertilizerId,
                                      'typeId': type['_id'],
                                      'name': type['name'],
                                    }
                                    : null;

                            final widget =
                                isEven
                                    ? CustomWidget2(
                                      customBorderColor: const Color(
                                        0xff7B970C,
                                      ),
                                      customColor: const Color(0xff7B970C),
                                      text: type['name'],
                                      image: type['img']['url'],
                                      routeName: routeName ?? '',
                                      arguments: arguments ?? {},
                                    )
                                    : CustomWidget2Reversed(
                                      customBorderColor: const Color(
                                        0xff7B970C,
                                      ),
                                      customColor: const Color(0xff7B970C),
                                      text: type['name'],
                                      image: type['img']['url'],
                                      routeName: routeName ?? '',
                                      arguments: arguments ?? {},
                                    );

                            return Column(
                              children: [widget, const SizedBox(height: 0)],
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
