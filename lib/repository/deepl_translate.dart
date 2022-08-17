import 'dart:convert';
import 'package:http/http.dart' as http;

/*
callAPIメソッド
引数txt:翻訳される前の文章
引数に渡された文章をdeeplAPIに渡して，翻訳された文章をString型で返す関数
*/
Future<String> callAPI(String txt, String uri) async {
  //httpリクエストを送るURL
  final Uri url = Uri.parse("http://127.0.0.1:8000/translate/");
  //httpリクエストのbodyとなる部分
  var sendBody = json.encode({"text": txt, "uri": uri});
  //httpリクエストを送信，結果を格納
  var response = await http.post(url,
      headers: {'Content-Type': 'application/json'}, body: sendBody);
  //httpリクエストの結果をjson形式からmap形式にdecode
  final res = json.decode(utf8.decode(response.bodyBytes));
  //httpリクエストの結果は日本語が文字化けするため(おそらく変な形式にdecodeされているため)，UTF-8にdecodeを行う
  return res['text'];
}
