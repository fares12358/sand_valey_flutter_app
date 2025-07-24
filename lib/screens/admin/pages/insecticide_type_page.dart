import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sand_valley/widgets/Admin/add_type_section.dart';
import 'package:sand_valley/widgets/Admin/type_item_card.dart';

class InsecticideTypeAdminPage extends StatefulWidget {
  const InsecticideTypeAdminPage({super.key});

  @override
  State<InsecticideTypeAdminPage> createState() =>
      _InsecticideTypeAdminPageState();
}

class _InsecticideTypeAdminPageState extends State<InsecticideTypeAdminPage> {
  List<Map<String, dynamic>> types = [];
  final TextEditingController _searchController = TextEditingController();
  bool showAddSection = false;
  bool isLoading = true;
  bool isFetched = false;

  static const orangeColor = Color(0xFFF7941D);

  late String id;
  late String name;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchInsecticideTypes(String id) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          "https://sand-valey-flutter-app-backend-node.vercel.app/api/auth/get-insecticide-type/$id",
        ),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List data = body['data'];

        setState(() {
          types = data
              .map<Map<String, dynamic>>(
                (item) => {
                  'id': item['_id'],
                  'name': item['name'],
                  'description': item['description'],
                  'company': item['company'] ?? '',
                  'imageUrl': item['img']['url'],
                },
              )
              .toList();
        });
      } else {
        print("❌ Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
        isFetched = true;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredTypes {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return types;
    return types
        .where((type) => type['name'].toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)?.settings.arguments as Map;
    id = args['id'];
    name = args['name'];

    if (!isFetched) {
      _fetchInsecticideTypes(id);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Insecticide Types',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: orangeColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // 🔍 Search Bar
                            TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Search insecticide type...',
                                fillColor: Colors.white,
                                prefixIcon: const Icon(Icons.search,
                                    color: Color(0xFFF7941D)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // ➕ Add Section
                            if (!showAddSection)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        setState(() => showAddSection = true),
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: orangeColor,
                                    ),
                                  ),
                                ],
                              )
                            else
                              AddTypeSection(
                                categoryId: id,
                                onCancel: () =>
                                    setState(() => showAddSection = false),
                                onSave: () {
                                  setState(() => showAddSection = false);
                                  _fetchInsecticideTypes(id); // Refresh list
                                },
                              ),
                          ],
                        ),
                      ),

                      // 📦 Type List or Loader
                      Expanded(
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFF7941D),
                                ),
                              )
                            : _filteredTypes.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.bug_report_outlined,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'لا توجد أنواع حالياً',
                                          style:
                                              TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    itemCount: _filteredTypes.length,
                                    itemBuilder: (context, index) {
                                      final item = _filteredTypes[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: TypeItemCard(
                                          typeName: item['name'],
                                          description: item['description'],
                                          company: item['company'],
                                          imageUrl: item['imageUrl'],
                                          catId: id,
                                          typeId: item['id'],
                                          onRefresh: () =>
                                              _fetchInsecticideTypes(id),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
