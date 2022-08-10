import 'package:flutter/material.dart';
import 'package:paper_translation/providers/providers.dart';
import 'package:paper_translation/view/pdfViewPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class uploadPage extends ConsumerWidget {
  const uploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PDF TRANSLATOR'),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                child: TextField(
                  decoration: InputDecoration(hintText: 'PDFのURLを入力'),
                  onChanged: (text) {
                    ref.read(pdfSourceProvider.state).state = text;
                  },
                ),
                width: 500,
                height: 70),
            ElevatedButton(
                onPressed: () => {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return pdfViewPage();
                      }))
                    },
                child: Text('Go to translate page.'))
          ],
        )));
  }
}
