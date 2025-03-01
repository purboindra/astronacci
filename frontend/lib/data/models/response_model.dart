sealed class ResponseModel {}

class Success<T> extends ResponseModel {
  final T data;
  Success(this.data);
}

class Error extends ResponseModel {
  final String message;
  Error(this.message);
}
