class ResponseResult {
  final bool success;
  final String message;
  final dynamic data; // can be String (JWT), Map, List, etc.
  final int? statusCode; // optional, for HTTP status codes

  ResponseResult({
    required this.success,
    required this.message,
    this.data, // <-- make it optional!
    this.statusCode, // <-- make it optional
  });
}
