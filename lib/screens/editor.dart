import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class EditorScreen extends StatefulWidget {
  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final quillController = quill.QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor Markdown'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveMarkdown();
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _shareMarkdown();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: quill.QuillEditor(
              controller: quillController,
              scrollController: ScrollController(),
              scrollable: true,
              autoFocus: true,
              readOnly: false,
              placeholder: 'Digite seu texto em Markdown...',
              expands: false,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMarkdown() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/markdown_file.md');

      await file.writeAsString(quillController.document.toPlainText());
      Get.snackbar(
          "Salvo com sucesso", "O arquivo foi salvo como markdown_file.md");
    } catch (e) {
      print("Erro ao salvar o arquivo: $e");
      Get.snackbar("Erro", "Não foi possível salvar o arquivo.");
    }
  }

  void _shareMarkdown() {
    final text = quillController.document.toPlainText();
    Get.snackbar(
        "Compartilhar", "Texto copiado para a área de transferência:\n$text");

    
  }
}
