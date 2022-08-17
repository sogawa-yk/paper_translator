import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_translation/providers/providers.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import "package:paper_translation/repository/deepl_translate.dart";
import "package:flutter/services.dart";

class Translate extends Intent {}

class pdfViewPage extends ConsumerWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  var tmp = 0;
  //翻訳前，翻訳語テキストフィールドの内容のコントローラ
  final _originalTextController = TextEditingController();
  final _translatedTextController = TextEditingController();

  //Ctrl+CでAPIを起動するためのキーセット
  final _copyKeySet = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyC,
  );

  //クリップボードのテキストを抽出して返す
  Future<String> getClipboardText() async {
    String? ret = "";
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      ret = value!.text;
    });
    return ret!;
  }

  Future<void> translate() async {
    String clipboardText = await getClipboardText();
    //翻訳前テキストフィールドのテキストにクリップボードのテキストを書き込む
    //_originalTextController.text = await getClipboardText();
    //DeeplAPIを利用して翻訳した結果を格納
    final translatedRes = callAPI(clipboardText);
    //翻訳語テキストフィールドに翻訳結果を反映させる
    translatedRes.then((value) => _translatedTextController.text = value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {_copyKeySet: Translate()},
      actions: {Translate: CallbackAction(onInvoke: (intent) => translate())},
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter PDF Viewer'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.g_translate,
                color: Colors.white,
                semanticLabel: 'Translate',
              ),
              onPressed: () {
                //tmp++; // 翻訳ボタンをつける
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.bookmark,
                color: Colors.white,
                semanticLabel: 'Bookmark',
              ),
              onPressed: () {
                _pdfViewerKey.currentState?.openBookmarkView();
              },
            ),
          ],
        ),
        body: Row(
          children: [
            Expanded(
                child: SfPdfViewer.network(
              ref.watch(pdfSourceProvider),
              key: _pdfViewerKey,
            )),
            Expanded(
                child: Column(
              children: [
                const Text('Translation results'),
                Expanded(
                    child: TextField(
                  controller: _translatedTextController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Translated text will appear here",
                  ),
                )),
                const Divider(
                  height: 20,
                  thickness: 2,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.black,
                ),
                Expanded(
                    child: TextField(
                  controller: _originalTextController,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter text you want to translate'),
                ))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
