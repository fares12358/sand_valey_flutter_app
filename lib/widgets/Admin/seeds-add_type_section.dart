import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddSeedsTypeSection extends StatefulWidget {
  final String categoryId; // 👈 Parent category ID
  final VoidCallback onSaved;

  const AddSeedsTypeSection({
    super.key,
    required this.categoryId,
    required this.onSaved,
  });

  @override
  State<AddSeedsTypeSection> createState() => _AddSeedsTypeSectionState();
}

class _AddSeedsTypeSectionState extends State<AddSeedsTypeSection> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Subcategory name is required.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse(
        'https://sand-valey-flutter-app-backend-node.vercel.app/api/auth/add-seeds-type',
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': widget.categoryId, 'name': name}),
      );

      if (response.statusCode == 200) {
        widget.onSaved();
      } else {
        final body = jsonDecode(response.body);
        setState(() => _error = body['message'] ?? 'Failed with status ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _error = 'Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _cancel() {
    _nameController.clear();
    setState(() => _error = null);
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New Subcategory',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7941D),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Subcategory Name',
              labelStyle: const TextStyle(color: Color(0xFFF7941D)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFF7941D)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFF7941D), width: 2),
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),

          const SizedBox(height: 12),

          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Color(0xFFF7941D)))
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _cancel,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFFF7941D), fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7941D),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
