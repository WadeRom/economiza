import 'package:economiza/src/interfaces/database/interface_database_schema.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDatabaseManager implements IDatabaseSchemaManager {
  // Database instance
  static Database? _database;

  // Seed data for initial setup
  static final Map<String, Object> seedData = {
    'transaction_type': {
      'column': 'type',
      'values': [
        'ingreso',
        'gasto',
        'transferencia',
        'pago de deuda',
        'ahorro'
      ]
    },
    'transaction_state': {
      'column': 'state',
      'values': [
        'pendiente',
        'completado',
        'cancelado',
        'en proceso'
      ]
    },	
    'transaction_category': {
      'column': 'category',
      'values': [
      'alimentación',
      'transporte',
      'entretenimiento',
      'salud',
      'vivienda',
      'educación',
      'ahorro',
      'otros'
      ]
    }
  };

  SQLiteDatabaseManager._internal();

  // Singleton instance
  static final SQLiteDatabaseManager _instance =
      SQLiteDatabaseManager._internal();

  // Factory constructor to return the singleton instance
  factory SQLiteDatabaseManager() {
    return _instance;
  }
  
  Future<Database> getDatabase() async {
    if (_database == null) {
      print('Database is null, initializing...');
      // If the database is not initialized, set it up
      // and create the tables
      await setupConnectionDB();
    }
    print('Database is initialized');
    // If the database is already initialized, return it
    return _database!;
  }

  @override
  // Method to initialize the database
  Future<void> setupConnectionDB() async {
    final String path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'economiza.db'),
      version: 1,
      onCreate: (Database db, int version) async {

        // Aquí defines tus tablas SOLO la primera vez
        await createSchemaDB('transaction_type', [
          ColumnDefinition(
            name: 'id',
            type: 'INTEGER',
            isPrimaryKey: true,
            isAutoIncrement: true,
          ),
          ColumnDefinition(
            name: 'type',
            type: 'VARCHAR(50)',
            isNullable: false,
          ),
          ColumnDefinition(
            name: 'created_at',
            type: 'DATETIME DEFAULT CURRENT_TIMESTAMP',
            isNullable: false,
          ),
        ], db: db);

        await createSchemaDB('transaction_state', [
          ColumnDefinition(
            name: 'id',
            type: 'INTEGER',
            isPrimaryKey: true,
            isAutoIncrement: true,
          ),
          ColumnDefinition(
            name: 'state',
            type: 'TEXT',
            isNullable: false,
          ),
          ColumnDefinition(
            name: 'created_at',
            type: 'DATETIME DEFAULT CURRENT_TIMESTAMP',
            isNullable: false,
          ),
        ], db: db);

        await createSchemaDB('transaction_category', [
          ColumnDefinition(
            name: 'id',
            type: 'INTEGER',
            isPrimaryKey: true,
            isAutoIncrement: true,
          ),
          ColumnDefinition(
            name: 'category',
            type: 'VARCHAR(50)',
            isNullable: false,
          ),
          ColumnDefinition(
            name: 'description',
            type: 'VARCHAR(100)',
            isNullable: true,
          ),
          ColumnDefinition(
            name: 'created_at',
            type: 'DATETIME DEFAULT CURRENT_TIMESTAMP',
            isNullable: false,
          ),
        ], db: db);

        await createSchemaDB('transaction', [
          ColumnDefinition(
            name: 'id',
            type: 'INTEGER',
            isPrimaryKey: true,
            isAutoIncrement: true,
            isNullable: false,
          ),
          ColumnDefinition(
            name: 'date',
            type: 'DATETIME',
            isNullable: false,
          ),
          ColumnDefinition(
            name: 'amount',
            type: 'DECIMAL(10, 2)',
            isNullable: false,
          ),
          ColumnDefinition(
            name: 'description',
            type: 'VARCHAR(100)',
            isNullable: true,
          ),
          ColumnDefinition(
            name: 'type_id',
            type: 'INTEGER',
            isNullable: false,
            foreignKey: 'transaction_type(id)',
          ),
          ColumnDefinition(
            name: 'state_id',
            type: 'INTEGER',
            isNullable: false,
            foreignKey: 'transaction_state(id)',
          ),
          ColumnDefinition(
            name: 'category_id',
            type: 'INTEGER',
            isNullable: false,
            foreignKey: 'transaction_category(id)',
          ),
        ], db: db);

        await seedDatabase(db);
      }
    );
  }

  Future<void> seedDatabase(Database db) async {
    final batch = db.batch();
    seedData.forEach((tableName, data) {
      final mapData = data as Map<String, dynamic>;
      final column = mapData['column'];
      final values = mapData['values'];
      for (var value in values) {
        batch.insert(tableName, {column: value});
      }
    });
    await batch.commit(noResult: true);
  }

  @override
  // Method to close the database
  Future<void> closeConnectionDB() async {
    if (_database != null) {
      await _database?.close();
      _database = null;
    }
  }

  @override
  // Method to create a schema (table)
  Future<void> createSchemaDB(
    String storageName,
    List<ColumnDefinition> columns, {
    Database? db, 
  }) async {

    String sql = 'CREATE TABLE IF NOT EXISTS "$storageName" (';
    final foreignKeys = <String>[];
    for (var column in columns) {
      sql += '"${column.name}" ${column.type}';
      if (column.isPrimaryKey) {
        sql += ' PRIMARY KEY';
        if (column.type.toUpperCase() == 'INTEGER' && column.isAutoIncrement) {
          sql += ' AUTOINCREMENT';
        }
      }
      if (!column.isNullable) {
        sql += ' NOT NULL';
      }
      sql += ', ';
      if (column.foreignKey != null) {
        foreignKeys.add('FOREIGN KEY (${column.name}) REFERENCES ${column.foreignKey}');
      }
    }
    if (foreignKeys.isNotEmpty) {
      sql += '${foreignKeys.join(', ')}, ';
    }
    sql = sql.substring(0, sql.length - 2); // Remove last comma and space
    sql += ')';

    await (db ?? _database)?.execute(sql);
  }
}
