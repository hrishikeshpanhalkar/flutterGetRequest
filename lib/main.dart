import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:httptutorial/services/post_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PostService postService = PostService();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: FutureBuilder<List>(
          future: postService.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data?[index]['title']),
                      subtitle: Text(snapshot.data?[index]['body']),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          var userId;
          String? title;
          String? body;
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                    content: Form(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            labelText: "UserID",
                          ),
                          onChanged: (_val) {
                            userId = _val;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            labelText: "Title",
                          ),
                          onChanged: (_val) {
                            title = _val;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            labelText: "Body",
                          ),
                          onChanged: (_val) {
                            body = _val;
                          },
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              Map<String, dynamic> data = {
                                "title": title,
                                "body": body,
                              };
                              String res = await postService.createPost(data);
                              res == "success"
                                  ? Fluttertoast.showToast(
                                      msg: "Post Created!!")
                                  : Fluttertoast.showToast(
                                      msg: "Error Creating Post !!");
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Add",
                            ))
                      ]),
                    ),
                  ));
        }));
  }
}

// {
//     "userId": 1,
//     "title": "hrishikesh",
//     "body": "Panhalkar"
// }

// http://jsonplaceholder.typicode.com/posts