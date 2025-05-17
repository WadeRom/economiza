import 'package:economiza/src/dependency/economiza_service_locator.dart';
import 'package:economiza/src/domain/models/economiza_transaction.dart';
import 'package:economiza/src/interfaces/database/interface_database_transaction.dart';
import 'package:economiza/src/interfaces/interface_uses_cases.dart';

class InsertTransactionUseCase implements UseCase<EconomizaTransaction, UseCaseResult<EconomizaTransaction>> {
  final _transaction = economizaServiceLocator.databaseTransaction;

  @override
  Future<UseCaseResult<EconomizaTransaction>> call(EconomizaTransaction transaction) async {
    try {
      // Insertar la transacción en la base de datos
      UseCaseResult<int> response = await _transaction.insert(
        SimpleInsertTransactionModel(
          storage: 'transaction',
          record: transaction.toJson(),
        ),
      );

      // Verificar si la inserción fue exitosa y obtener el ID generado
      if (response is SuccessUseCaseResult<int> && response.data != null) {
        // Reconstruir la transacción con el nuevo ID generado
        EconomizaTransaction insertedTransaction = EconomizaTransaction(
          id: response.data.toString(), // Convertimos el ID a String si es necesario
          description: transaction.description,
          amount: transaction.amount,
          date: transaction.date,
          typeId: transaction.typeId,
          stateId: transaction.stateId,
          categoryId: transaction.categoryId,
        );

        return SuccessUseCaseResult(
          message: 'Transaction inserted successfully',
          data: insertedTransaction, // Devuelve la transacción completa
        );
      } else {
        throw FailureUseCaseResult(message: 'Error inserting transaction: ID not generated');
      }
    } catch (e) {
      throw FailureUseCaseResult(message: 'Error inserting transaction: ${e.toString()}');
    }
  }
}

