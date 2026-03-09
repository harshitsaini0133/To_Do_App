class ApiResponse<T> {
  const ApiResponse({
    required this.data,
    this.statusCode,
  });

  final T data;
  final int? statusCode;
}
