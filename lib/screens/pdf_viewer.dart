import 'package:flutter/material.dart';
import 'package:pddmobile/screens/download_page.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  final String pdfUrl;

  const PdfViewer({super.key, required this.pdfUrl});
  @override
  _PdfViewer createState() => _PdfViewer();
}

class _PdfViewer extends State<PdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _showSingleDownloadModal(BuildContext context, String url) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          width: 300,
          child: SingleDownloadScreen(url: url),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (() => Navigator.pop(context)),
        ),
        title: const Text('PDF Görüntüleyici'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.white,
              semanticLabel: 'Download',
            ),
            onPressed: () {
              _showSingleDownloadModal(context, widget.pdfUrl);
            
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        key: _pdfViewerKey,
      ),
    );
  }
}
