import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper_translation/providers/providers.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class pdfViewPage extends ConsumerWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  var tmp = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
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
              tmp++; // 翻訳ボタンをつける
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
              Expanded(child: Text('Translation results')),
              const Divider(
                height: 20,
                thickness: 2,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
              Expanded(
                  child: TextField(
                maxLines: null,
                decoration: InputDecoration(
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
