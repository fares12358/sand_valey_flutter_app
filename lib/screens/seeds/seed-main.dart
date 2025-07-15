// Add this at the top
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sand_valley/widgets/background_container.dart';
import 'package:sand_valley/widgets/customButton.dart';
import 'package:sand_valley/widgets/customWidget2.dart';
import 'package:sand_valley/widgets/customWidget2Reversed.dart';
import 'package:sand_valley/widgets/roundedContainer.dart';

class SeedMainPage extends StatefulWidget {
  const SeedMainPage({super.key});

  @override
  State<SeedMainPage> createState() => _SeedMainPageState();
}

class _SeedMainPageState extends State<SeedMainPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showTopContainer = true;

  List<Map<String, dynamic>> seedList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && _showTopContainer) {
        setState(() => _showTopContainer = false);
      } else if (_scrollController.offset <= 50 && !_showTopContainer) {
        setState(() => _showTopContainer = true);
      }
    });

    _fetchSeeds();
  }

  Future<void> _fetchSeeds() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final res = await http.get(
        Uri.parse(
          'https://sand-valey-flutter-app-backend-node.vercel.app/api/auth/get-seeds-data',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final List<dynamic> data = json['data']['data'];

        seedList =
            data.map<Map<String, dynamic>>((e) {
              return {
                'id': e['_id'] ?? '',
                'name': e['name'] ?? '',
                'imageUrl': e['img']['url'] ?? '',
              };
            }).toList();
      } else {
        _error = 'Failed to load data: ${res.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching data: $e';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7941D),
        toolbarHeight: 5,
      ),
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            children: [
              // Top Container
              AnimatedOpacity(
                opacity: _showTopContainer ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _showTopContainer ? 300 : 0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFA927).withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: CustomButton(
                          buttonColor: const Color(0xFFF7941D),
                          routeName: '/home',
                          icon: Image.asset(
                            'assets/images/arrow.png',
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "بذور",
                                style: TextStyle(
                                  fontSize: 60,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              ImageIcon(
                                AssetImage('assets/images/page_icon.png'),
                                size: 100,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: RoundedContainer(
                          image: 'assets/images/seeds-main-img.png',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // List
              Expanded(
                child:
                    _isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffFFA927),
                          ),
                        )
                        : _error != null
                        ? Center(
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                        : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          itemCount: seedList.length,
                          itemBuilder: (context, index) {
                            final item = seedList[index];
                            final isEven = index % 2 == 0;

                            final widget =
                                isEven
                                    ? CustomWidget2(
                                      customColor: const Color(0xFFF7941D),
                                      customBorderColor: const Color(
                                        0xff00793F,
                                      ),
                                      text: item['name'],
                                      image: item['imageUrl'],
                                      routeName: '/seed-type',
                                      arguments: {
                                        'id': item['id'],
                                        'name': item['name'],
                                        'image': item['imageUrl'],
                                      },
                                    )
                                    : CustomWidget2Reversed(
                                      customColor: const Color(0xFFF7941D),
                                      customBorderColor: const Color(
                                        0xff00793F,
                                      ),
                                      text: item['name'],
                                      image: item['imageUrl'],
                                      routeName: '/seed-type',
                                      arguments: {
                                        'id': item['id'],
                                        'name': item['name'],
                                        'image': item['imageUrl'],
                                      },
                                    );

                            return Column(children: [widget]);
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
