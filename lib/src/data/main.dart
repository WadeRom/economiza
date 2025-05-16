import 'dart:developer';
import 'package:economiza/src/data/database/economiza_database_manager.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EconomizaDatabaseManager().connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Economiza',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Economiza'),
        ),
        body: const CategoryList(),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  Future<List<String>> fetchCategorias() async {
    final db = await EconomizaDatabaseManager().dbManager.getDatabase();
    final categorias = await db.query('transaction_category');
    return categorias.map((e) => e['category'].toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchCategorias(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final categorias = snapshot.data ?? [];
        if (categorias.isEmpty) {
          return const Center(child: Text('No hay categorías'));
        }
        return ListView.builder(
          itemCount: categorias.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(categorias[index]),
            );
          },
        );
      },
    );
  }
}