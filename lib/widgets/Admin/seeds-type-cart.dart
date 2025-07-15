import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SeedsTypeCart extends StatefulWidget {
  final String id;
  final String name;
  final String imageUrl;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const SeedsTypeCart({
    super.key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.onDelete,
    this.onTap,
  });

  @override
  State<SeedsTypeCart> createState() => _SeedsTypeCartState();
}

class _SeedsTypeCartState extends State<SeedsTypeCart> {
  bool _expanded = false;
  bool _editing = false;
  bool _loading = false;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.name;
    super.initState();
  }

  void _toggleExpand() => setState(() => _expanded = !_expanded);

  void _startEdit() => setState(() => _editing = true);

  void _cancelEdit() {
    if (_loading) return;
    setState(() {
      _editing = false;
      _nameController.text = widget.name;
    });
  }

  Future<void> _saveEdit() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty || newName == widget.name) {
      _cancelEdit();
      return;
    }

    setState(() => _loading = true);

    try {
      final uri = Uri.parse(
        'https://sand-valey-flutter-app-backend-node.vercel.app/api/auth/update-seeds-type/${widget.id}',
      );

      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': newName}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${body['message'] ?? 'Updated successfully'}'),
            backgroundColor: const Color(0xFFF7941D),
          ),
        );
        setState(() => _editing = false);
      } else {
        _showErrorSnackBar(body['message'] ?? 'Unknown error');
      }
    } catch (e) {
      _showErrorSnackBar('Exception: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showErrorSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ $msg')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (_editing || _loading) ? null : widget.onTap,
      borderRadius: BorderRadius.circular(10),
      splashColor: Colors.orange.withOpacity(0.2),
      highlightColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: _toggleExpand,
                ),
              ],
            ),
            if (_expanded)
              Column(
                children: [
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    enabled: _editing && !_loading,
                    decoration: const InputDecoration(
                      labelText: 'Edit Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _loading
                        ? const [
                            CircularProgressIndicator(color: Color(0xFFF7941D)),
                          ]
                        : _editing
                            ? [
                                ElevatedButton(
                                  onPressed: _cancelEdit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: _saveEdit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFF7941D),
                                  ),
                                  child: const Text('Save'),
                                ),
                              ]
                            : [
                                ElevatedButton(
                                  onPressed: _startEdit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFF7941D),
                                  ),
                                  child: const Text('Edit'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: widget.onDelete,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
