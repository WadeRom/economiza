
import 'dart:developer';
import 'package:economiza/src/services/base_service.dart';
import 'package:economiza/src/services/database/database_service.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final dbService = SQLiteDatabaseManagerService.instance.connect();
  final dbTransactionService = SQLiteDatabaseTransactionService();


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
        body: Center(
          child: Text('Welcome to Economiza!'),
        ),
      ),
    );
  }
}