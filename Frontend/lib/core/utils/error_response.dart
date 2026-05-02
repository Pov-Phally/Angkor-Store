import 'package:angkor_store/core/utils/type_defs.dart';
import 'package:equatable/equatable.dart';

class ErrorResponse extends Equatable {
  const ErrorResponse({this.message, this.type, this.errorMessages});

  factory ErrorResponse.fromMap(DataMap map) {
    List<String>? errorMessages;
    String? message = map["message"] as String?;

    if (map["error"] is List) {
      errorMessages = (map["error"] as List)
          .cast<DataMap>()
          .map((error) => error["message"] as String)
          .toList();
    } else if (map["error"] is String) {
      message = map["error"] as String;
    }

    if (errorMessages != null && errorMessages.isEmpty) errorMessages = null;
    return ErrorResponse(
      message: message,
      type: map["type"] as String?,
      errorMessages: errorMessages,
    );
  }

  final String? message;
  final String? type;
  final List<String>? errorMessages;

  String get errorMessage {
    var payload = "";
    if (type != null) payload = "${type!}\n";
    if (message != null) {
      payload += message!;
    } else {
      if (errorMessages != null) {
        payload += "\nWhat went wrong?";
        for (final (index, message) in errorMessages!.indexed) {
          if (index == 0) {
            payload += "\n$message";
          } else {
            payload += "\n• $message";
          }
        }
      }
    }
    return payload;
  }

  @override
  List<Object?> get props => [message, type];
}
