import 'package:sqflite/sqflite.dart';

Future<void> insertInitialData(Database db) async {
  // Insertar estados
  await db.insert('transaction_state', {'state': 'activo'});
  await db.insert('transaction_state', {'state': 'eliminado'});
  await db.insert('transaction_state', {'state': 'modificado'});

  // Insertar tipos de transacción
  await db.insert('transaction_type', {'type': 'ingreso'});
  await db.insert('transaction_type', {'type': 'salida'});

  // Insertar categorías
  List<String> categories = [
    'Vivienda', 'Transporte', 'Alimentación', 'Salud',
    'Educación', 'Entretenimiento', 'Finanzas'
  ];
  for (var category in categories) {
    await db.insert('transaction_category', {'category': category});
  }
}
