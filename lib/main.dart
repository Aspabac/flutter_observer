import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final UIModel _model = UIModel();
  late NameObserver nameObserver;
  late ButtonObserver buttonObserver;
  final myController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    nameObserver = NameObserver()..subscribe(_model);
    buttonObserver = ButtonObserver()..subscribe(_model);
  }

  @override
  void dispose() {
    myController.dispose();
    _model.allUnsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200),
              child: TextField(controller: myController),
            ),
            TextButton(
                onPressed: () {
                  _model.inputName(
                      myController.text, nameObserver);
                  setState(() {});
                },
                child: Text(_model.name)),
            const SizedBox(height: 50),
            const Divider(),
            const SizedBox(height: 50),
            TextButton(
                onPressed: () {
                  _model.switchButton(buttonObserver);
                  setState(() {});
                },
                child: Text(_model.swiched.toString())),
            const SizedBox(height: 50),
            const Divider(),
            const SizedBox(height: 50),
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
        onPressed: () {
          _incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Observerの管理 & observerに通知
abstract class Subject {
  Subject({List<Observer>? observers}) : observers = observers ?? [];

  List<Observer> observers;
  void subscribe(Observer observer) {
    observers.add(observer);
  }

  void allUnsubscribe() {
    observers = [];
  }

  void notify(Observer observer) {
    observer.update();
  }
}

// Dataの更新 & Subjectのnotify methodをcallする
class UIModel extends Subject {
  UIModel();

  //Data
  String name = "your name";
  bool swiched = false;

  // Data更新&notify呼び出し 処理
  void inputName(String name, Observer observer) {
    this.name = name == "" ? "empty" : name;
    notify(observer);
  }
  void switchButton(Observer observer) {
    swiched = !swiched;
    notify(observer);
  }
}

// Observer interface
abstract class Observer {
  void update();
  void subscribe(UIModel model) => model.subscribe(this);
}

// Concrete Observer
class NameObserver extends Observer {
  @override
  void update() {
    //詳細実装
  }
}

// Concrete Observer
class ButtonObserver extends Observer {
  @override
  void update() {
    //詳細実装
  }
}
