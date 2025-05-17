enum TableOperation { add, drop, modify }
/// Ejemplo de definición para columnas, lo cual ayuda a estructurar la creación o alteración de tablas.
class ColumnDefinition {
  final String name;
  final String type;
  final bool isPrimaryKey;
  final bool isNullable;
  final bool isAutoIncrement;
  final String? foreignKey; // <-- NUEVO

  ColumnDefinition({
    required this.name,
    required this.type,
    this.isPrimaryKey = false,
    this.isNullable = true,
    this.isAutoIncrement = false,
    this.foreignKey, // <-- NUEVO
  });
}

abstract class IDatabaseSchemaManager {
  /// Inicializa la conexión o configura la base de datos.
  Future<void> getDatabase();
  
  /// Cierra la conexión a la base de datos.
  Future<void> closeConnectionDB();

  /// Crea un "almacenamiento" (tabla, colección, etc.) con la definición dada.
  Future<void> createSchemaDB(String storageName, List<ColumnDefinition> columns);

}
