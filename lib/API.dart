
class API {
  static String url = "192.168.0.194:8080";

  static Uri getUri(String path) {
    return Uri.http(url, path);
  }
}