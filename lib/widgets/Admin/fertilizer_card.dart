import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:sand_valley/providers/app_state.dart';

class FertilizerCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDeleteSuccess;
  final VoidCallback onEditSuccess;

  const FertilizerCard({
    super.key,
    required this.data,
    required this.onDeleteSuccess,
    required this.onEditSuccess,
  });

  @override
  State<FertilizerCard> createState() => _FertilizerCardState();
}

class _FertilizerCardState extends State<FertilizerCard> {
  bool _expanded = false;
  bool _isEditing = false;
  bool _isLoading = false;

  late TextEditingController _nameController;
  File? _newImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data['name'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _newImage = File(picked.path));
    }
  }

  Future<void> _updateFertilizer() async {
    setState(() => _isLoading = true);

    try {
      final baseUrl = Provider.of<AppState>(context, listen: false).baseUrl;

      final uri = Uri.parse('$baseUrl/update-fertilizer-data');
      final request =
          http.MultipartRequest('POST', uri)
            ..fields['id'] = widget.data['id']
            ..fields['name'] = _nameController.text.trim();

      if (_newImage != null) {
        final mimeType = lookupMimeType(_newImage!.path)?.split('/');
        final file = await http.MultipartFile.fromPath(
          'image',
          _newImage!.path,
          contentType:
              mimeType != null
                  ? MediaType(mimeType[0], mimeType[1])
                  : MediaType('image', 'jpeg'),
          filename: p.basename(_newImage!.path),
        );
        request.files.add(file);
      }

      final res = await request.send();
      final response = await http.Response.fromStream(res);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Updated successfully')));
        widget.onEditSuccess();
        setState(() {
          _expanded = false;
          _isEditing = false;
          _newImage = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Update failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteFertilizer() async {
    setState(() => _isLoading = true);

    try {
      final baseUrl = Provider.of<AppState>(context, listen: false).baseUrl;

      final uri = Uri.parse(
        '$baseUrl/delete-fertilizer-data/${widget.data['id']}',
      );
      final res = await http.delete(uri);

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Deleted successfully')));
        widget.onDeleteSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Delete failed: ${res.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _nameController.text = widget.data['name'] ?? '';
      _newImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        // navigate on tap if not expanded
        onTap:
            !_expanded
                ? () {
                  Navigator.pushNamed(
                    context,
                    '/fertilizer-type',
                    arguments: {
                      'id': widget.data['id'],
                      'name': widget.data['name'],
                    },
                  );
                }
                : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top row: Image + Name + Arrow
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.data['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.data['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                    onPressed: () {
                      setState(() => _expanded = !_expanded);
                    },
                  ),
                ],
              ),

              // Expanded edit section
              if (_expanded) ...[
                const SizedBox(height: 16),

                // Name field
                TextField(
                  controller: _nameController,
                  enabled: _isEditing,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 20),

                // Image picker / preview
                GestureDetector(
                  onTap: _isEditing ? _pickImage : null,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child:
                        _newImage != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_newImage!, fit: BoxFit.cover),
                            )
                            : Image.network(
                              widget.data['image'],
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      const Center(child: Icon(Icons.image)),
                            ),
                  ),
                ),
                const SizedBox(height: 20),

                // Loading spinner or action buttons
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xffF7941D))
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:
                          _isEditing
                              ? [
                                // Save & Cancel
                                ElevatedButton(
                                  onPressed: _updateFertilizer,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffF7941D),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: _cancelEditing,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ]
                              : [
                                // Edit & Delete
                                ElevatedButton(
                                  onPressed: _startEditing,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffF7941D),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: _deleteFertilizer,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
