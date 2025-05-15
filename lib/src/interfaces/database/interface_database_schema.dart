abstract class IDatabaseTableManager {
  Future<void> createTable(String tableName, List<String> columns);
  Future<void> alterTable(String tableName, String operation, String columnDefinition);
}

abstract class IDatabaseSchemaManager {
  Future<void> createSchema(String schemaName);
  Future<void> dropSchema(String schemaName);
  Future<void> renameSchema(String oldName, String newName);
  Future<void> listSchemas();
}