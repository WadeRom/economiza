// Interfaz para definir los métodos de conexión y cierre de la base de datos
// Esta interfaz permite implementar diferentes tipos de bases de datos
abstract class IDatabaseService<T> {
  Future<void> connect();
  Future<void> close();
  Future<T> get database;
}