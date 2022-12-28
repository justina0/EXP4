import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/io.dart';


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
  /*******************10.1*******************/
  // Dio _dio = Dio();
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     alignment: Alignment.center,
  //     child: FutureBuilder(
  //         future: _dio.get("https://api.github.com/orgs/flutterchina/repos"),
  //         builder: (BuildContext context, AsyncSnapshot snapshot) {
  //           //请求完成
  //           if (snapshot.connectionState == ConnectionState.done) {
  //             Response response = snapshot.data;
  //             //发生错误
  //             if (snapshot.hasError) {
  //               return Text(snapshot.error.toString());
  //             }
  //             //请求成功，通过项目信息构建用于显示项目名称的ListView
  //             return ListView(
  //               children: response.data.map<Widget>((e) =>
  //                   ListTile(title: Text(e["full_name"]))
  //               ).toList(),
  //             );
  //           }
  //           //请求未完成时弹出loading
  //           return CircularProgressIndicator();
  //         }
  //     ),
  //   );
  // }


/*******************10.2*******************/
  TextEditingController _controller = TextEditingController();
  IOWebSocketChannel channel = IOWebSocketChannel.connect('ws://121.40.165.18:8800');
  String _text = "";

  @override
  void initState() {
    //创建websocket连接
    // channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket(内容回显)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                //网络不通会走到这
                print(snapshot);
                if (snapshot.hasError) {
                  _text = "网络暂时不通...";
                } else if (snapshot.hasData) {
                  _text = "echo: "+snapshot.data.toString();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(_text),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }


}
