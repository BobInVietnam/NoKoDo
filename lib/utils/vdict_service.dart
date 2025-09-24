import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class VDictService {
  static Future<String> traTuVietViet(String tuKhoa) async {
    final url = Uri.parse(
      "https://vdict.com/${Uri.encodeComponent(tuKhoa)},3,0,0.html",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);

      final meanings = document.querySelectorAll("div.meaning-value");

      if (meanings.isEmpty) {
        return "Không tìm thấy nghĩa cho từ '$tuKhoa'.";
      }

      return meanings.map((e) => e.text.trim()).join("\n\n");
    } else {
      return "Lỗi kết nối: ${response.statusCode}";
    }
  }
}
