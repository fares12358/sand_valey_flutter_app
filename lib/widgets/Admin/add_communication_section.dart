import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddCommunicationSection extends StatefulWidget {
  final VoidCallback onSaved;
  final VoidCallback onCancel;

  const AddCommunicationSection({
    super.key,
    required this.onSaved,
    required this.onCancel,
  });

  @override
  State<AddCommunicationSection> createState() => _AddCommunicationSectionState();
}

class _AddCommunicationSectionState extends State<AddCommunicationSection> {
  final _secureStorage = const FlutterSecureStorage();
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;
  String? _error;

  Future<void> _saveCommunication() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Name is required');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    final token = await _secureStorage.read(key: 'token');
    final url = Uri.parse('https://sand-valey-flutter-app-backend-node.vercel.app/api/auth/add-communication-data');

    try {
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name}),
      );

      if (res.statusCode == 200) {
        widget.onSaved(); // Refresh list and close form
      } else {
        final resBody = jsonDecode(res.body);
        setState(() => _error = resBody['message'] ?? 'Failed to add communication');
      }
    } catch (e) {
      setState(() => _error = 'Error: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Communication Name',
              border: OutlineInputBorder(),
              errorText: _error,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveCommunication,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save, color: Colors.white),
                label: const Text('Save', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7941D),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
