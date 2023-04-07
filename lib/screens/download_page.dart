import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class SingleDownloadScreen extends StatefulWidget {
  final String url;
  const SingleDownloadScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<SingleDownloadScreen> createState() => _SingleDownloadScreenState();
}

class _SingleDownloadScreenState extends State<SingleDownloadScreen> {
  double? _progress;
  String _status = '';
  bool isDownloading = false;

  Future<void> downloadFile({
    required String url,
    required String name,
  }) async {
    FileDownloader.downloadFile(
        url: url,
        name: name,
        onProgress: (name, progress) {
          setState(() {
            isDownloading = true;
            _progress = progress;
            _status = 'Indiriliyor : $progress%';
          });
        },
        onDownloadCompleted: (path) {
          var download_path_list = path
              .split("/")
              .sublist(path.split("/").length - 3, path.split("/").length);
          var downloadPath =
              "${download_path_list[1]}/${download_path_list[2]}";

          setState(() {
            isDownloading = false;
            _progress = null;
            _status = 'Dosya : $downloadPath konumuna indirildi';
          });
        },
        onDownloadError: (error) {
          setState(() {
            isDownloading = false;
            _progress = null;
            _status = 'Dosya indirilirken hata olustur.';
          });
        }).then((file) {});
  }

  String parseFileNameFromUrl(String url) {
    return url.split('/').last;
  }

  @override
  void initState() {
    super.initState();
    downloadFile(url: widget.url, name: parseFileNameFromUrl(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (() => Navigator.pop(context)),
        ),
        title: const Text('Doysa Indirme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_status.isNotEmpty) ...[
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (_progress != null) ...[
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 8,
                        value: _progress! / 100,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${_progress!.toInt()}%',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
