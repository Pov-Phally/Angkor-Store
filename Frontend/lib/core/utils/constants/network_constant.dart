abstract class NetworkConstant {
  const NetworkConstant();

  static const baseUrl = "http://10.0.2.2:3000/api/v1";
  static const authority = "10.0.2.2:3000";
  static const apiUrl = "/api/v1";
  static const header = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Charset": "utf-8",
  };
  static const pageSize = 10;
}
