import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:paper_translation/data/apikey.dart";

String apiKey = apiKeySecret;
/*
callAPIメソッド
引数txt:翻訳される前の文章
引数に渡された文章をdeeplAPIに渡して，翻訳された文章をString型で返す関数
*/
Future<String> callAPI(String txt) async {
  //httpリクエストを送るURL
  final Uri url = Uri.parse("https://api-free.deepl.com/v2/translate");
  //httpリクエストのbodyとなる部分
  var sendBody = {
    "auth_key": apiKey,
    "text": txt,
    "source_lang": 'EN',
    "target_lang": 'JA',
  };
  //httpリクエストを送信，結果を格納
  var response = await http.post(url, body: sendBody);
  //httpリクエストの結果をjson形式からmap形式にdecode
  final res = json.decode(response.body);
  //httpリクエストの結果は日本語が文字化けするため(おそらく変な形式にdecodeされているため)，UTF-8にdecodeを行う
  return utf8.decode(res["translations"][0]["text"].runes.toList());
}
