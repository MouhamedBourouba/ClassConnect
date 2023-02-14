class MException {
  final String errorMessage;
  final int? errorCode;

  MException(this.errorMessage, {this.errorCode});

  MException.unknown()
      : errorMessage = "Unknown error, please try again later",
        errorCode = null;

  MException.noInternetConnection()
      : errorMessage = "Unknown error, please try again later",
        errorCode = null;
}
