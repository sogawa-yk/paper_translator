import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_translation/providers/providers.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import "package:paper_translation/repository/deepl_translate.dart";

class pdfViewPage extends ConsumerWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController _pdfViewerController = PdfViewerController();

  var tmp = 0;
  //翻訳前，翻訳語テキストフィールドの内容のコントローラ
  final _originalTextController = TextEditingController();
  final _translatedTextController = TextEditingController();

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
              /*
              //翻訳前テキストフィールドのテキストを読み込む
              String txt = _originalTextController.text;
              //DeeplAPIを利用して翻訳した結果を格納
              final translatedRes = callAPI(txt);
              //翻訳語テキストフィールドに翻訳結果を反映させる
              translatedRes
                  .then((value) => _translatedTextController.text = value);
              */
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
              child: SfPdfViewer.network(ref.watch(pdfSourceProvider),
                  key: _pdfViewerKey,
                  enableDoubleTapZooming: true,
                  controller: _pdfViewerController,
                  pageLayoutMode: PdfPageLayoutMode.single,
                  canShowScrollHead: true,
                  canShowScrollStatus: true)),
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
                onChanged: (text) {
                  //翻訳前テキストフィールドのテキストを読み込む
                  String txt = _originalTextController.text;
                  //DeeplAPIを利用して翻訳した結果を格納
                  final translatedRes =
                      callAPI(txt, ref.watch(pdfSourceProvider.state).state);
                  //翻訳語テキストフィールドに翻訳結果を反映させる
                  translatedRes
                      .then((value) => _translatedTextController.text = value);
                },
                maxLines: null,
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
