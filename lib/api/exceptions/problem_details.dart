class ProblemDetails implements Exception {
  final String? type;
  final String? title;
  final int? status;
  final String? detail;
  final String? instance;

  ProblemDetails({this.type, this.title, this.status, this.detail, this.instance});

  factory ProblemDetails.fromJson(Map<String, dynamic> json) {
    return ProblemDetails(
      type: json['type'],
      title: json['title'],
      status: json['status'],
      detail: json['detail'],
      instance: json['instance'],
    );
  }

  @override
  String toString() => 'ProblemDetails(status: $status, detail: $detail)';
}