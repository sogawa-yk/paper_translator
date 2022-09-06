import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_translation/providers/providers.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import "package:paper_translation/repository/deepl_translate.dart";
import "package:flutter/services.dart";

class Translate extends Intent {}

class pdfViewPage extends ConsumerWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController _pdfViewerController = PdfViewerController();

  var tmp = 0;
  //翻訳前，翻訳語テキストフィールドの内容のコントローラ
  final _originalTextController = TextEditingController();
  final _translatedTextController = TextEditingController();

  //Ctrl+CでAPIを起動するためのキーセット
  var copyKeySetWindows = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyC,
  );

  //Cmd+CでAPIを起動するためのキーセット
  var copyKeySetMac = LogicalKeySet(
    LogicalKeyboardKey.meta,
    LogicalKeyboardKey.keyC,
  );

  LogicalKeySet copyKeySet = LogicalKeySet(LogicalKeyboardKey.keyC);

  pdfViewPage({Key? key}) : super(key: key) {
    getPlatform();
  }

  void getPlatform() {
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      copyKeySet = copyKeySetMac;
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      copyKeySet = copyKeySetWindows;
    }
  }

  //クリップボードのテキストを抽出して返す
  Future<String> getClipboardText() async {
    String? ret = "";
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      ret = value!.text;
    });
    ret ??= "";
    return ret!;
  }

  Future<void> translateClipboard(WidgetRef ref) async {
    String clipboardText = await getClipboardText();
    //翻訳前テキストフィールドのテキストにクリップボードのテキストを書き込む
    _originalTextController.text = await getClipboardText();
    //DeepLAPIに翻訳するテキストを送信して結果を反映させる
    useAPI(clipboardText, ref);
  }

  void useAPI(String sendText, WidgetRef ref) {
    //DeeplAPIを利用して翻訳した結果を格納
    final translatedRes =
        callAPI(sendText, ref.watch(pdfSourceProvider.state).state);
    //翻訳語テキストフィールドに翻訳結果を反映させる
    translatedRes.then((value) => _translatedTextController.text = value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
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
              //_pdfViewerKey.currentState?.openBookmarkView();
              _pdfViewerController.zoomLevel = 2;
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
              child: FocusableActionDetector(
                  autofocus: true,
                  shortcuts: {
                    copyKeySet: Translate(),
                  },
                  actions: {
                    Translate: CallbackAction(
                        onInvoke: (intent) => translateClipboard(ref))
                  },
                  child: SfPdfViewer.network(
                    ref.watch(pdfSourceProvider),
                    key: _pdfViewerKey,
                  ))),
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
                onChanged: (value) => useAPI(value, ref),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter text you want to translate'),
              ))
            ],
          ))
        ],
      ),
    );
  }
}
