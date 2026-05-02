import 'package:flutter/material.dart';

extension StringExtension on String {
  Map<String, String> get toAuthHeaders {
    return {
      "Authorization": "Bearer $this",
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json",
    };
  }

  ThemeMode get toThemeMode {
    return switch (toLowerCase()) {
      "light" => ThemeMode.light,
      "dark" => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  String get obscureEmail {
    final index = indexOf("@");
    var userName = substring(0, index);
    final domain = substring(index + 1);
    userName = '${userName[0]}***${userName[userName.length - 1]}';

    return "$userName@$domain";
  }
}
