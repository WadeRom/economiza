abstract class UseCase<Input, Output> {
  Future<Output> call(Input input);
}

abstract class UseCaseResult<T> {
  final bool success;
  final String? message;
  final T? data;

  UseCaseResult({required this.success, this.message, this.data});

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}

class SuccessUseCaseResult<T> extends UseCaseResult<T> {
  SuccessUseCaseResult({super.message, super.data}) : super(success: true);
}

class FailureUseCaseResult extends UseCaseResult<void> {
  FailureUseCaseResult({super.message}) : super(success: false);
}
