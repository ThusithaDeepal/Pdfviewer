import 'package:flutter/material.dart';
import 'book.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'তাফসীর ইবনে কাসীর',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List bookindex = [
      Books(subject: '১ম - ৩য় খন্ড', subtitle: 'সূরা ফাতিহা - সূরা বাকারা'),
      Books(
          subject: '৪র্থ - ৭ম খন্ড', subtitle: 'সূরা আল-ইমরান - সূরা মায়িদাহ'),
      Books(subject: '৮ম - ১১শ খন্ড', subtitle: 'সূরা আন\'আম - সূরা ইউনুস'),
      Books(subject: '১২শ - ১৩শ খন্ড', subtitle: 'সূরা হূদ - সূরা ইসরা'),
      Books(subject: '১৪শ খন্ড', subtitle: 'সূরা কাহফ - সূরা হাজ্জ'),
      Books(subject: '১৫শ খন্ড', subtitle: 'সূরা মু\'মিনুন - সূরা আহযাব'),
      Books(subject: '১৬শ খন্ড', subtitle: 'সূরা সাবা - সূরা ফাতহ'),
      Books(subject: '১৭শ খন্ড', subtitle: 'সূরা হুজরাত - সূরা মুরসালাত'),
      Books(subject: '১৮শ খন্ড', subtitle: 'সূরা নাবা - সূরা নাস'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'তাফসীর ইবনে কাসীর',
          style: TextStyle(
            //fontSize: 14,
            fontFamily: 'Baloo Da',
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: bookindex.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/icon.png"),
              ),
              title: Text(
                bookindex[index].subject,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'HindSiliguri',
                ),
              ),
              subtitle: Text(
                bookindex[index].subtitle,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'HindSiliguri',
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Book(index)));
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 85.0,
        ),
      ),
    );
  }
}

class Books {
  String subject;
  String subtitle;
  String booklink;

  Books({this.subject, this.subtitle, this.booklink});
}
