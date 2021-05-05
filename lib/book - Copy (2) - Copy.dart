import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer/database_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Book extends StatefulWidget {
  final int index;
  Book(this.index);

  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  Directory tempDir;
  String tempPath;

  List booklist = [
    'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-01.pdf',
    'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-02.pdf',
    'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-03.pdf',
    'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-04.pdf',
    'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-05.pdf',
    'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-06.pdf',
    'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-07.pdf',
    'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-08.pdf',
    'https://rongdhonustudio.com/islamic_books/Tafsir_Ibn_Katheer/Tafseer-Ibn-Kathir-09.pdf',
  ];

  // List<bool> downloadStatus = [
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fileDownload();
  }

  void test() async {
    var afectedCount = await DatabaseHelper.instance.update({
      DatabaseHelper.fileName: booklist[widget.index],
      DatabaseHelper.downloadStatus: true
    });

    print(afectedCount);
    print("fucl");
  }

  int percentage = 0, totalFileSize;
  var fileBytes;

  Future<void> fileDownload() async {
    try {
      tempDir = await getTemporaryDirectory();
      //download file
      tempPath = tempDir.path + "/" + booklist[widget.index];

      var statusCheck =
          await DatabaseHelper.instance.queryId(booklist[widget.index]);
      print(statusCheck);
      print(statusCheck[0]['fileName']);

      var downStatus = statusCheck[0]['downloadStatus'];
      print(downStatus);

      var dio = Dio();

      if (statusCheck[0]['downloadStatus'] == '1') {
        this.setState(() {
          percentage = 100;
        });
      } else {
        dio.download(
          booklist[widget.index],
          tempPath,
          onReceiveProgress: (count, total) {
            this.setState(() {
              percentage = ((count / total) * 100).floor();
            });
            percentage = ((count / total) * 100).floor();
            totalFileSize = total;
          },
        ).whenComplete(test);
      }
    } catch (exp) {
      print("fuccccccccccccccccccccccccccckkkkkkkkkkkkkkkkkk");
    }
  }

  void downloadAgain() {
    var dio = Dio();
    dio.download(
      booklist[widget.index],
      tempPath,
      onReceiveProgress: (count, total) {
        this.setState(() {
          percentage = ((count / total) * 100).floor();
        });
        percentage = ((count / total) * 100).floor();
        totalFileSize = total;
      },
    ).whenComplete(test);
  }

  void onBackPressed() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print("adad");
        //need to create download status false in database
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Syncfusion Flutter PDF Viewer'),
          ),
          body: percentage == 100
              ? SfPdfViewer.file(
                  File(tempPath),
                  // onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                  //   // downloadAgain();
                  // },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white,
                          value: percentage.toDouble() / 100,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
                      Text(
                        (percentage.toDouble()).toString() + " %",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Text("Please wait while file downloading",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30))
                    ],
                  ),
                )),
    );
  }
}
