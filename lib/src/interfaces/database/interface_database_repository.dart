abstract class IDatabaseRepository<T, R> {
  Future<R> insert(String table, dynamic data, {Map<String, dynamic>? config});
  Future<R> update(String table, dynamic data, Map<String, dynamic> config);
  Future<List<Map<String, dynamic>>> select(String table, dynamic config);

  Future<R> transaction<R>(Future<R> Function(T context) operation);
}
