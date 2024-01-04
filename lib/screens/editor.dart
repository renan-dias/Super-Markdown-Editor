import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class EditorScreen extends StatefulWidget {
  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String markdownText = 'Digite seu texto em Markdown aqui.';
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      print(controller.text);
    });
  }

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    MarkdownTextInput(
                      (String value) => setState(() => markdownText = value),
                      markdownText,
                      label: 'Texto em Markdown',
                      maxLines: 10,
                      actions: MarkdownType.values,
                      controller: controller,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.clear();
                      },
                      child: Text('Limpar'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: MarkdownBody(
                        data: markdownText,
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveMarkdown() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/markdown_file.md');

      await file.writeAsString(markdownText);
      Get.snackbar(
        "Salvo com sucesso",
        "O arquivo foi salvo como markdown_file.md",
      );
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao salvar o arquivo: $e");
      }
      Get.snackbar("Erro", "Não foi possível salvar o arquivo.");
    }
  }

  void _shareMarkdown() {
    final text = markdownText;
    Share.share(text, subject: 'Compartilhando Markdown');
  }
}
