import 'package:http/http.dart' as http;

Future getData(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

