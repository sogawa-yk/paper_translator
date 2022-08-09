import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class pdfViewPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF VIEW'),
      ),
      body: PDF().fromUrl('https://arxiv.org/pdf/2004.08546.pdf')
    );
  }
}