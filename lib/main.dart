import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrcpy_plus_plus_gui/scrcpy.dart';
import 'package:window_size/window_size.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    var window = await getWindowInfo();
    if (window.screen != null) {
      final screenFrame = window.screen.visibleFrame;
      final width = 600.0;
      final height = 1200.0;
      final left = ((screenFrame.width - width) / 2).roundToDouble();
      final top = ((screenFrame.height - height) / 3).roundToDouble();
      final frame = Rect.fromLTWH(left, top, width, height);
      setWindowFrame(frame);
      setWindowTitle("Scrcpy++");
      setWindowMinSize(Size(500.0, 1000.0));
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String keyInitialRun = "keyInitialRun";
  static String keyAdbPath = "keyAdbPath";
  static String keyscrcpyPath = "keyscrcpyPath";

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scrcpy++',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        accentColor: Colors.indigoAccent,
        focusColor: Colors.indigoAccent,
        highlightColor: Colors.indigoAccent,
        indicatorColor: Colors.indigoAccent,
      ),
      home: MyHomePage(title: 'Scrcpy++', box: box, initial: true),
      routes: <String, WidgetBuilder>{
        '/homepageAsSetting': (BuildContext context) =>
            MyHomePage(title: 'Scrcpy++', box: box, initial: false),
        '/scrcpypage': (BuildContext context) => ScrcpyPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.box, this.initial}) : super(key: key);
  final String title;
  final GetStorage box;
  final bool initial;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _adbPathController = TextEditingController();
  final TextEditingController _scrcpyPathController = TextEditingController();
  bool _saveButtonDisabled = true;
  bool pathsNotStored = false;
  bool firstPageLoad = true;
  String adbPath;
  String scrcpyPath;

  @override
  Widget build(BuildContext context) {
    _saveButtonDisabled =
        _adbPathController.text.isEmpty || _scrcpyPathController.text.isEmpty;

    pathsNotStored = widget.box.hasData(MyApp.keyInitialRun);
    if (pathsNotStored) {
      if (widget.initial) {
        Future.delayed(Duration.zero, () {
          Navigator.popAndPushNamed(context, '/scrcpypage');
        });
      }
    } else {
      widget.box.writeIfNull(MyApp.keyscrcpyPath, "/usr/local/bin/scrcpy");
      scrcpyPath = widget.box.read(MyApp.keyscrcpyPath);
      setState(() {
        _scrcpyPathController.text = scrcpyPath;
      });
    }

    if (!widget.initial && firstPageLoad) {
      scrcpyPath = widget.box.read(MyApp.keyscrcpyPath);
      adbPath = widget.box.read(MyApp.keyAdbPath);
      setState(() {
        _scrcpyPathController.text = scrcpyPath;
        _adbPathController.text = adbPath;
        _saveButtonDisabled = _adbPathController.text.isEmpty ||
            _scrcpyPathController.text.isEmpty;
        firstPageLoad = false;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.indigo),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  "adb PATH",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _saveButtonDisabled =
                              _adbPathController.text.isEmpty ||
                                  _scrcpyPathController.text.isEmpty;
                        });
                      },
                      controller: _adbPathController,
                      decoration: InputDecoration(hintText: '$adbPath'),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
              child: Row(
                children: [
                  Text(
                    "scrcpy PATH",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _saveButtonDisabled =
                                _adbPathController.text.isEmpty ||
                                    _scrcpyPathController.text.isEmpty;
                          });
                        },
                        controller: _scrcpyPathController,
                        decoration: InputDecoration(hintText: '$scrcpyPath'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
              child: ElevatedButton(
                onPressed: _saveButtonDisabled
                    ? null
                    : () {
                        widget.box.write(MyApp.keyInitialRun, false);
                        widget.box
                            .write(MyApp.keyAdbPath, _adbPathController.text);
                        widget.box.write(
                            MyApp.keyscrcpyPath, _scrcpyPathController.text);
                        Future.delayed(Duration.zero, () {
                          if (widget.initial) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScrcpyPage()));
                          } else {
                            Navigator.pop(context);
                          }
                        });
                      },
                autofocus: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _adbPathController.dispose();
    _scrcpyPathController.dispose();
    super.dispose();
  }
}
