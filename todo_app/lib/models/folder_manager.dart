// folder_manager.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';

class FolderManager extends StatefulWidget {
  final List<String> folders;
  final Function(List<String>) onFoldersUpdated;

  const FolderManager({
    super.key,
    required this.folders,
    required this.onFoldersUpdated,
  });

  @override
  _FolderManagerState createState() => _FolderManagerState();
}

class _FolderManagerState extends State<FolderManager> {
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      List<String> updatedPaths = List.from(widget.folders);
      for (var file in result.files) {
        if (file.path != null && !updatedPaths.contains(file.path)) {
          updatedPaths.add(file.path!);
        }
      }
      widget.onFoldersUpdated(updatedPaths);
    }
  }

  Future<void> _pickFolder() async {
    String? result = await FilePicker.platform.getDirectoryPath();

    if (result != null && !widget.folders.contains(result)) {
      List<String> updatedPaths = List.from(widget.folders)..add(result);
      widget.onFoldersUpdated(updatedPaths);
    }
  }

  void _removePath(int index) {
    List<String> updatedPaths = List.from(widget.folders)..removeAt(index);
    widget.onFoldersUpdated(updatedPaths);
  }

  Future<void> _openPath(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Impossible d\'ouvrir: ${result.message}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ouverture: $e')),
        );
      }
    }
  }

  bool _isDirectory(String path) {
    try {
      return FileSystemEntity.isDirectorySync(path);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.file_present),
              label: const Text('Ajouter fichier'),
            ),
            ElevatedButton.icon(
              onPressed: _pickFolder,
              icon: const Icon(Icons.folder),
              label: const Text('Ajouter dossier'),
            ),
          ],
        ),
        if (widget.folders.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(widget.folders.length, (index) {
                final filePath = widget.folders[index];
                final isDirectory = _isDirectory(filePath);
                final fileName = path.basename(filePath);

                return Card(
                  child: InkWell(
                    onTap: () => _openPath(filePath),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isDirectory ? Icons.folder : Icons.insert_drive_file,
                            size: 16,
                            color: isDirectory ? Colors.amber : Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              fileName,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () => _removePath(index),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
