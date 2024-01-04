import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'editor.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

final templatesProvider = Provider<List<String>>((ref) {
  return [
    "Template 1",
    "Template 2",
    "Template 3",
  ];
});

final selectedTemplateProvider = StateProvider<String>((ref) {
  return ref.watch(templatesProvider).first;
});

void _openProject(String projectName) {
  // Implementar lógica para abrir o projeto
  Get.snackbar("Abrir Projeto", "Projeto aberto: $projectName");
}

void _createNewProject() {
  // Implementar lógica para criar novo projeto em branco
  Get.snackbar("Novo Projeto", "Projeto em branco criado");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Super Markdown Editor',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/editor', page: () => EditorScreen()),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final templates = useProvider(templatesProvider);
    final selectedTemplate =
        useProvider(selectedTemplateProvider as Provider<List<String>>);

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildTemplatesSection(templates, selectedTemplate),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: 'URL_DA_SUA_ARTE_AQUI',
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(height: 16),
          Text(
            'Super Markdown Editor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesSection(
      List<String> templates, StateController<String> selectedTemplate) {
    return Expanded(
      child: ListView(
        children: templates.map((template) {
          return ListTile(
            title: Text(template),
            onTap: () {
              selectedTemplate.state = template;
              _openProject(template);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          _createNewProject();
        },
        child: Text("Adicionar Projeto em Branco"),
      ),
    );
  }
}

useProvider(Provider<List<String>> templatesProvider) {}
