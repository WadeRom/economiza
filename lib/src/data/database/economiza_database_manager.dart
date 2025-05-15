import 'package:economiza/src/data/database/sqlite_database_manager.dart';
import 'package:economiza/src/data/database/sqlite_database_table.dart';
import 'package:sqflite/sqflite.dart';

class EconomizaDatabaseInitializer {
  static final EconomizaDatabaseInitializer _singleton = EconomizaDatabaseInitializer._internal();
  static Database? _db;

  EconomizaDatabaseInitializer._internal();

  static EconomizaDatabaseInitializer get instance => _singleton;

  Future<void> setupDatabase(SQLiteTableManager manager) async {
    List<Map<String, dynamic>> tables = [
      {"name": "transaction_category", "columns": ["id INTEGER PRIMARY KEY AUTOINCREMENT", "name TEXT NOT NULL", "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"]},
      {"name": "transaction_type", "columns": ["id INTEGER PRIMARY KEY AUTOINCREMENT", "name TEXT NOT NULL", "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"]},
      {"name": "transaction_state", "columns": ["id INTEGER PRIMARY KEY AUTOINCREMENT", "name TEXT NOT NULL", "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"]},
      {"name": "transaction", "columns": [
        "id INTEGER PRIMARY KEY AUTOINCREMENT",
        "date DATETIME NOT NULL",
        "state INTEGER NOT NULL",
        "amount REAL NOT NULL CHECK(amount >= 0)",
        "description TEXT DEFAULT ''",
        "transaction_type_id INTEGER NOT NULL",
        "transaction_category_id INTEGER NOT NULL",
        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP",
        "FOREIGN KEY (transaction_type_id) REFERENCES transaction_type(id) ON DELETE CASCADE",
        "FOREIGN KEY (transaction_category_id) REFERENCES transaction_category(id) ON DELETE CASCADE",
        "FOREIGN KEY (state) REFERENCES transaction_state(id) ON DELETE SET NULL"
      ]}
    ];

    for (var table in tables) {
      try {
        await manager.createTable(table["name"], table["columns"]);
      } catch (e) {
        print("❌ Error al crear '${table["name"]}': $e");
      }
    }
  }

  Future<void> seedDatabase(SQLiteTableManager manager) async {
    List<Map<String, dynamic>> transactionTypes = [
      {"name": "Ingreso"},
      {"name": "Gasto"},
    ];

    List<Map<String, dynamic>> transactionStates = [
      {"name": "Eliminado"},
      {"name": "Editado"},
      {"name": "Completado"}
    ];

    List<Map<String, dynamic>> transactionCategories = [
      {"name": "Sueldo"},
      {"name": "Bonificaciones"},
      {"name": "Freelance"},
      {"name": "Venta de productos"},
      {"name": "Dividendos"},
      {"name": "Reembolsos"},
      {"name": "Alquileres"},
      {"name": "Regalos"},
      {"name": "Alimentación"},
      {"name": "Transporte"},
      {"name": "Vivienda"},
      {"name": "Servicios básicos"},
      {"name": "Salud"},
      {"name": "Educación"},
      {"name": "Entretenimiento"},
      {"name": "Viajes"},
      {"name": "Compras personales"},
      {"name": "Impuestos"},
      {"name": "Depósito de ahorro"},
      {"name": "Compra de acciones"},
      {"name": "Fondo de emergencia"},
      {"name": "Inversión inmobiliaria"},
      {"name": "Pensiones"},
      {"name": "Pago de préstamos"},
      {"name": "Tarjeta de crédito"},
      {"name": "Pago de intereses"},
      {"name": "Multas"}
    ];

    for (var category in transactionCategories) {
      await manager.insert("transaction_category", category);
    }

    for (var type in transactionTypes) {
      await manager.insert("transaction_type", type);
    }

    for (var state in transactionStates) {
      await manager.insert("transaction_state", state);
    }
  }

  /// Inicializa la base de datos y crea las tablas necesarias.
  Future<void> initialize() async {
    await SQLiteDatabaseManagerService.instance.connect();
    _db = await SQLiteDatabaseManagerService.instance.database;
    SQLiteTableManager tableManager = SQLiteTableManager(_db!);
    await setupDatabase(tableManager);
  }
   
}