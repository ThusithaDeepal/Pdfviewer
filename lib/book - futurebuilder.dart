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
  Future pdfFuture;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // userFuture = showPdf();
    // fileDownload();
    pdfFuture = loadPdf();
  }

  Future<Widget> loadPdf() async {
    return (SfPdfViewer.network(booklist[widget.index]));
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
        if (mounted) {
          this.setState(() {
            percentage = 100;
          });
        }
      } else {
        dio.download(
          booklist[widget.index],
          tempPath,
          onReceiveProgress: (count, total) {
            if (mounted) {
              this.setState(() {
                percentage = ((count / total) * 100).floor();
              });
            }

            percentage = ((count / total) * 100).floor();
            totalFileSize = total;
          },
        ).whenComplete(test);
      }
    } catch (exp) {
      print("fuccccccccccccccccccccccccccckkkkkkkkkkkkkkkkkk");
    }
  }

  // void downloadAgain() {
  //   var dio = Dio();
  //   dio.download(
  //     booklist[widget.index],
  //     tempPath,
  //     onReceiveProgress: (count, total) {
  //       if (mounted) {
  //         this.setState(() {
  //           percentage = ((count / total) * 100).floor();
  //         });
  //       }

  //       percentage = ((count / total) * 100).floor();
  //       totalFileSize = total;
  //     },
  //   ).whenComplete(test);
  // }

  // showPdf() async {
  //   // await fileDownload();
  //   //
  //   try {
  //     tempDir = await getTemporaryDirectory();
  //     //download file
  //     tempPath = tempDir.path + "/" + booklist[widget.index];

  //     var statusCheck =
  //         await DatabaseHelper.instance.queryId(booklist[widget.index]);
  //     print(statusCheck);
  //     print(statusCheck[0]['fileName']);

  //     var downStatus = statusCheck[0]['downloadStatus'];
  //     print(downStatus);

  //     var dio = Dio();

  //     if (statusCheck[0]['downloadStatus'] == '1') {
  //       if (mounted) {
  //         this.setState(() {
  //           percentage = 100;
  //         });
  //       }

  //       return (Text("adoo from pdf future onee"));
  //     } else {
  //       dio.download(
  //         booklist[widget.index],
  //         tempPath,
  //         onReceiveProgress: (count, total) {
  //           if (mounted) {
  //             this.setState(() {
  //               percentage = ((count / total) * 100).floor();
  //             });
  //           }

  //           percentage = ((count / total) * 100).floor();
  //           totalFileSize = total;
  //         },
  //       ).whenComplete(test);

  //       var tempbyte = await File(tempPath).readAsBytes();

  //       // return (SfPdfViewer.memory(tempbyte));
  //       return (Text("adoo from pdf future twoo"));
  //     }
  //   } catch (exp) {
  //     print("fuccccccccccccccccccccccccccckkkkkkkkkkkkkkkkkk excption");
  //   }

  //   // var tempbyte = await File(tempPath).readAsBytes();

  //   // return (SfPdfViewer.memory(tempbyte));
  //   // //
  //   // // FutureBuilder(
  //   //                   future: userFuture,
  //   //                   builder: (context, snapshot) {
  //   //                     if (snapshot.connectionState ==
  //   //                         ConnectionState.waiting) {
  //   //                       return Text("waiting $percentage");
  //   //                     } else if (snapshot.connectionState ==
  //   //                         ConnectionState.done) {
  //   //                       // return snapshot.data;
  //   //                       // return Text("doneee");
  //   //                       return SfPdfViewer.file(File(tempPath));
  //   //                     } else {
  //   //                       return Text("other errorrr");
  //   //                     }
  //   //                   })
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print("adad");
          //need to create download status false in database
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SingleChildScrollView(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Syncfusion Flutter PDF Viewer'),
            ),
            body: Container(
                child: Column(
              children: [
                FutureBuilder(
                  future: pdfFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data;
                    } else {
                      return Text("progressbar");
                    }
                  },
                ),
              ],
            )),
          ),
        ));
  }
}
