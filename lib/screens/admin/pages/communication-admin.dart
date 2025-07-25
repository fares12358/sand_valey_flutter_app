import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sand_valley/providers/app_state.dart';
import 'package:sand_valley/widgets/Admin/add_communication_section.dart';

class CommunicationAdminPage extends StatefulWidget {
  const CommunicationAdminPage({super.key});

  @override
  State<CommunicationAdminPage> createState() => _CommunicationAdminPageState();
}

class _CommunicationAdminPageState extends State<CommunicationAdminPage> {
  final _secureStorage = const FlutterSecureStorage();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> communicationList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool _isLoading = true;
  bool _deleting = false;
  String? _error;
  bool _showAdd = false;
  Map<String, bool> expandedMap = {};
  Map<String, bool> editingMap = {};
  Map<String, TextEditingController> nameControllers = {};
  Map<String, bool> loadingMap = {};

  @override
  void initState() {
    super.initState();
    _fetchCommunications();
  }

  Future<void> _fetchCommunications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = await _secureStorage.read(key: 'token');
      final baseUrl = Provider.of<AppState>(context, listen: false).baseUrl;

      final res = await http.get(
        Uri.parse('$baseUrl/get-communication-data'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        final List<dynamic> data = j['data']['data'];

        communicationList =
            data.map<Map<String, dynamic>>((e) {
              return {'id': e['_id'], 'name': e['name']};
            }).toList();

        filteredList = List.from(communicationList);

        for (var item in filteredList) {
          final id = item['id'];
          expandedMap[id] = false;
          editingMap[id] = false;
          nameControllers[id] = TextEditingController(text: item['name']);
          loadingMap[id] = false;
        }
      } else {
        _error = 'Failed to load data (status ${res.statusCode}).';
      }
    } catch (e) {
      _error = 'Error fetching data: $e';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredList =
          communicationList
              .where(
                (item) =>
                    item['name'].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void _toggleAdd() => setState(() => _showAdd = !_showAdd);

  void _onSavedCommunication() {
    setState(() => _showAdd = false);
    _fetchCommunications(); // Refresh
  }

  Future<void> _deleteItem(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete this communication?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    setState(() => loadingMap[id] = true);

    final token = await _secureStorage.read(key: 'token');
    final baseUrl = Provider.of<AppState>(context, listen: false).baseUrl;

    final url = Uri.parse('$baseUrl/delete-communication-data/$id');

    try {
      final res = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        setState(() {
          communicationList.removeWhere((item) => item['id'] == id);
          filteredList.removeWhere((item) => item['id'] == id);
          expandedMap.remove(id);
          editingMap.remove(id);
          nameControllers.remove(id);
          loadingMap.remove(id);
        });
      } else {
        _showSnackBar('Failed to delete item (Status ${res.statusCode})', true);
      }
    } catch (e) {
      _showSnackBar('Error: $e', true);
    } finally {
      setState(() => loadingMap[id] = false);
    }
  }

  Future<void> _saveEdit(String id) async {
    final newName = nameControllers[id]?.text.trim();
    if (newName == null || newName.isEmpty) {
      _showSnackBar('Name cannot be empty.', true);
      return;
    }

    setState(() => loadingMap[id] = true);
    final baseUrl = Provider.of<AppState>(context, listen: false).baseUrl;

    final token = await _secureStorage.read(key: 'token');
    final url = Uri.parse('$baseUrl/update-communication-data');

    try {
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id, 'name': newName}),
      );

      if (res.statusCode == 200) {
        setState(() {
          editingMap[id] = false;
          final index = communicationList.indexWhere((e) => e['id'] == id);
          if (index != -1) {
            communicationList[index]['name'] = newName;
            filteredList[index]['name'] = newName;
          }
        });
        _showSnackBar('Updated successfully.', false);
      } else {
        _showSnackBar('Failed to update.', true);
      }
    } catch (e) {
      _showSnackBar('Error: $e', true);
    } finally {
      setState(() => loadingMap[id] = false);
    }
  }

  void _showSnackBar(String msg, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Communication Main',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF7941D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFF7941D)),
              )
              : _error != null
              ? Center(
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              )
              : RefreshIndicator(
                color: const Color(0xFFF7941D),
                onRefresh: _fetchCommunications,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      // Search bar
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFF7941D),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                cursorColor: const Color(0xFFF7941D),
                                decoration: const InputDecoration(
                                  hintText: "Search...",
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            const Icon(Icons.search, color: Color(0xFFF7941D)),
                          ],
                        ),
                      ),

                      // Add Button
                      if (!_showAdd)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton.icon(
                              onPressed: _toggleAdd,
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF7941D),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Add Section
                      if (_showAdd)
                        Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: AddCommunicationSection(
                            onSaved: _onSavedCommunication,
                            onCancel: _toggleAdd,
                          ),
                        ),

                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Communication Categories',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF7941D),
                            ),
                          ),
                        ),
                      ),

                      if (filteredList.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'No location found',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          itemBuilder: (context, i) {
                            final item = filteredList[i];
                            final id = item['id'];
                            final isExpanded = expandedMap[id] ?? false;
                            final isEditing = editingMap[id] ?? false;

                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              elevation: 5,
                              shadowColor: Colors.black,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.location_pin,
                                      color: Color(0xFFF7941D),
                                    ),
                                    title: Text(
                                      nameControllers[id]?.text ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFFF7941D),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        isExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: const Color(0xFFF7941D),
                                      ),
                                      onPressed: () {
                                        setState(
                                          () => expandedMap[id] = !isExpanded,
                                        );
                                      },
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/communicate-eng-admin',
                                        arguments: {'id': item['id']},
                                      );
                                    },
                                  ),
                                  if (isExpanded)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          TextField(
                                            controller: nameControllers[id],
                                            enabled: isEditing,
                                            decoration: InputDecoration(
                                              labelText: 'Name',
                                              labelStyle: const TextStyle(
                                                color: Color(0xFFF7941D),
                                              ),
                                              border:
                                                  const OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children:
                                                isEditing
                                                    ? [
                                                      ElevatedButton(
                                                        onPressed:
                                                            loadingMap[id]!
                                                                ? null
                                                                : () =>
                                                                    _saveEdit(
                                                                      id,
                                                                    ),
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                    0xFFF7941D,
                                                                  ),
                                                            ),
                                                        child:
                                                            loadingMap[id]!
                                                                ? const SizedBox(
                                                                  width: 16,
                                                                  height: 16,
                                                                  child: CircularProgressIndicator(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
                                                                )
                                                                : const Text(
                                                                  'Save',
                                                                  style: TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          setState(
                                                            () =>
                                                                editingMap[id] =
                                                                    false,
                                                          );
                                                          nameControllers[id]
                                                                  ?.text =
                                                              item['name'];
                                                        },
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.grey,
                                                            ),
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ]
                                                    : [
                                                      ElevatedButton(
                                                        onPressed:
                                                            loadingMap[id]!
                                                                ? null
                                                                : () =>
                                                                    _deleteItem(
                                                                      id,
                                                                    ),
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                        child:
                                                            loadingMap[id]!
                                                                ? const SizedBox(
                                                                  width: 16,
                                                                  height: 16,
                                                                  child: CircularProgressIndicator(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
                                                                )
                                                                : const Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          setState(
                                                            () =>
                                                                editingMap[id] =
                                                                    true,
                                                          );
                                                        },
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                    0xFFF7941D,
                                                                  ),
                                                            ),
                                                        child: const Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
    );
  }
}
