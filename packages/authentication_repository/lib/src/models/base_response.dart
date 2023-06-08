class BaseResponse {
  final bool success;
  final int? statusCode;
  final String message;

  BaseResponse(
      {required this.success, required this.statusCode, required this.message});
}
