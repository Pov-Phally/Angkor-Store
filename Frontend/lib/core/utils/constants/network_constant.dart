abstract class NetworkConstant {
  const NetworkConstant();

  static const baseUrl = "http://localhost:3000/api/v1";
  static const authority = "localhost:3000";
  static const apiUrl = "/api/v1";
  static const header = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Charset": "utf-8",
  };
  static const pageSize = 10;
}
