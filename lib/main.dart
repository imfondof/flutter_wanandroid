import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/index_page.dart';
import 'package:flutter_wanandroid/tool/utils/sp_utils.dart';

import 'common/application.dart';
import 'data/constant.dart';
import 'data/dio_util.dart';
import 'pages/login_page.dart';

///代码学习来源：
///（eventbus、sputil、viewmodel）https://github.com/iceCola7/flutter_wanandroid
///（多主题）https://github.com/iceCola7/flutter_wanandroid
///【230818-2.6k】(主题、字体、动画、provider、动画)https://github.com/phoenixsky/fun_android_flutter
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        "/": (BuildContext context) => const LoginPage(),
        "/index": (BuildContext context) => const IndexPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    Application.eventBus = EventBus();
    init();
  }

  void _incrementCounter() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return const LoginPage();
    }));
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> init() async {
    String? cookie = await SpUtil.getData<String>(Constant.keyAppCookie);
    BaseOptions options = DioUtil.getDefOptions();
    if (cookie != null && cookie.isNotEmpty) {
      Map<String, dynamic> headers = {};
      headers["cookie"] = cookie;
      options.headers = headers;
    }
    HttpConfig config = HttpConfig(options: options);
    DioUtil().setConfig(config);
  }
}
