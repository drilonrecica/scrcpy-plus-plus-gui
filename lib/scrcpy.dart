import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:process_run/shell_run.dart';
import 'package:scrcpy_plus_plus_gui/adbdevice.dart';
import 'package:scrcpy_plus_plus_gui/main.dart';

class ScrcpyPage extends StatefulWidget {
  ScrcpyPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ScrcpyPageState createState() => _ScrcpyPageState();
}

class _ScrcpyPageState extends State<ScrcpyPage> {
  final TextEditingController _titleController = TextEditingController();
  String _deviceTitle = "Android Device";
  bool _alwaysOnTop = false;
  bool _borderless = false;
  bool _fullScreen = false;
  bool _showTouches = false;
  bool _stayAwake = false;
  bool _disableScreensaver = false;
  String _rotation = '0';
  int _rotationValue = 0;
  String _videoOrientation = '0';
  int _videoOrientationValue = 0;
  String _maxHeight = '0';
  String _bitrate = '8 Mbps';
  String _bitrateValue = '8M';
  String _framerate = 'No Limit';
  int _framerateValue = 0;
  bool initialAdbLoad = true;
  Set<ADBDevice> adbDeviceSet = Set<ADBDevice>();
  List<ADBDevice> adbDeviceList;
  String adbPath = "";
  String scrcpyPath = "";

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    adbPath = box.read(MyApp.keyAdbPath);
    scrcpyPath = box.read(MyApp.keyscrcpyPath);
    if (initialAdbLoad) {
      _adb();
      initialAdbLoad = false;
    }
    adbDeviceList = adbDeviceSet.toList();
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onDoubleTap: () {
                    box.erase();
                    Future.delayed(Duration.zero, () {
                      Navigator.popAndPushNamed(context, '/homepageAsInitial');
                    });
                  },
                  child: Text(
                    "Scrcpy++",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      Navigator.pushNamed(context, '/homepageAsSetting');
                    });
                  },
                  child: Icon(Icons.settings)),
            ],
          ),
          backgroundColor: Colors.indigo),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                "Window Configuration",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Divider(),
              ),
              Row(
                children: [
                  Text(
                    "Title",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(hintText: '$_deviceTitle'),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "Rotation ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: Platform.isLinux
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: DropdownButton<String>(
                        value: _rotation,
                        onChanged: (value) {
                          setState(
                            () {
                              _rotation = value;
                              switch (_rotation) {
                                case '0':
                                  _rotationValue = 0;
                                  break;
                                case '90 Counterclockwise':
                                  _rotationValue = 1;
                                  break;
                                case '180':
                                  _rotationValue = 2;
                                  break;
                                case '90 Clockwise':
                                  _rotationValue = 3;
                                  break;
                                default:
                                  _rotationValue = 0;
                              }
                            },
                          );
                        },
                        items: <String>[
                          '0',
                          '90 Counterclockwise',
                          '180',
                          '90 Clockwise'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.indigoAccent,
                      onChanged: (value) {
                        setState(() {
                          _alwaysOnTop = value;
                        });
                      },
                      value: _alwaysOnTop,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _alwaysOnTop = !_alwaysOnTop;
                        });
                      },
                      child: Text(
                        "Always on top",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.indigoAccent,
                      onChanged: (value) {
                        setState(() {
                          _borderless = value;
                        });
                      },
                      value: _borderless,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _borderless = !_borderless;
                        });
                      },
                      child: Text(
                        "Borderless",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.indigoAccent,
                      onChanged: (value) {
                        setState(() {
                          _fullScreen = value;
                        });
                      },
                      value: _fullScreen,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _fullScreen = !_fullScreen;
                        });
                      },
                      child: Text(
                        "Fullscreen",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.indigoAccent,
                      onChanged: (value) {
                        setState(() {
                          _showTouches = value;
                        });
                      },
                      value: _showTouches,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showTouches = !_showTouches;
                        });
                      },
                      child: Text(
                        "Show touches",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.indigoAccent,
                      onChanged: (value) {
                        setState(() {
                          _stayAwake = value;
                        });
                      },
                      value: _stayAwake,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _stayAwake = !_stayAwake;
                        });
                      },
                      child: Text(
                        "Stay awake",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: Platform.isLinux
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.indigoAccent,
                      onChanged: (value) {
                        setState(() {
                          _disableScreensaver = value;
                        });
                      },
                      value: _disableScreensaver,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _disableScreensaver = !_disableScreensaver;
                        });
                      },
                      child: Text(
                        "Disable Screensaver",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: Platform.isLinux
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Divider(),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  "Capture Configuration",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Divider(),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "Max Height _______________",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        value: _maxHeight,
                        items: <String>[
                          '0',
                          '720',
                          '1080',
                          '1440',
                          '1920',
                          '2560',
                          '3088',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _maxHeight = value;
                          });
                        },
                        hint: Text(
                          "Max Height",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "Bitrate ____________________",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: DropdownButton(
                        value: _bitrate,
                        items: <String>['1 Mbps', '2 Mbps', '4 Mbps', '8 Mbps']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _bitrate = value;
                            switch (_bitrate) {
                              case '1 Mbps':
                                _bitrateValue = '1M';
                                break;
                              case '2 Mbps':
                                _bitrateValue = '2M';
                                break;
                              case '4 Mbps':
                                _bitrateValue = '4M';
                                break;
                              case '8 Mbps':
                                _bitrateValue = '8M';
                                break;
                              default:
                                _bitrateValue = '1M';
                            }
                          });
                        },
                        hint: Text("Bitrate"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "Framerate ________________",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: DropdownButton(
                        value: _framerate,
                        items: <String>['No Limit', '15', '30', '60', '120']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _framerate = value;
                            switch (_framerate) {
                              case 'No Limit':
                                _framerateValue = 0;
                                break;
                              case '15':
                                _framerateValue = 15;
                                break;
                              case '30':
                                _framerateValue = 30;
                                break;
                              case '60':
                                _framerateValue = 60;
                                break;
                              case '120':
                                _framerateValue = 120;
                                break;
                              default:
                                _framerateValue = 0;
                            }
                          });
                        },
                        hint: Text("Framerate"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  children: [
                    Text(
                      "Lock video orientation ___",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: Platform.isLinux
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: DropdownButton(
                        value: _videoOrientation,
                        items: <String>[
                          '0',
                          '90 Counterclockwise',
                          '180',
                          '90 Clockwise'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _videoOrientation = value;
                            switch (_videoOrientation) {
                              case '0':
                                _videoOrientationValue = 0;
                                break;
                              case '90 Counterclockwise':
                                _videoOrientationValue = 1;
                                break;
                              case '180':
                                _videoOrientationValue = 2;
                                break;
                              case '90 Clockwise':
                                _videoOrientationValue = 3;
                                break;
                              default:
                                _videoOrientationValue = 0;
                            }
                          });
                        },
                        hint: Text("Lock video orientation"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Divider(),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      "Connected Devices",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _adb,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Icon(Icons.refresh)),
                  )
                ]),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Divider(),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: adbDeviceSet.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    activeColor: Colors.indigoAccent,
                    title: Text(adbDeviceList[index].deviceName +
                        " | " +
                        adbDeviceList[index].deviceType),
                    value: adbDeviceList[index].selected,
                    onChanged: (value) {
                      setState(() {
                        adbDeviceList[index].selected = value;
                      });
                    },
                  );
                },
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Divider(),
              ),
              Container(
                margin: EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: _startScrcpy,
                  autofocus: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Start scrcpy",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _startScrcpy() async {
    bool notLinux = !Platform.isLinux;

    if (_titleController.text.isEmpty) {
      _deviceTitle = "Android Device";
    } else {
      _deviceTitle = _titleController.text;
    }

    var scrcpyCommand =
        "./scrcpy --window-title '$_deviceTitle' --bit-rate $_bitrateValue";

    if (notLinux) {
      scrcpyCommand = scrcpyCommand + " --rotation $_rotationValue";
    }

    if (_maxHeight != '0') {
      scrcpyCommand = scrcpyCommand + " --max-size $_maxHeight";
    }

    if (_alwaysOnTop) {
      scrcpyCommand = scrcpyCommand + " --always-on-top";
    }

    if (_borderless) {
      scrcpyCommand = scrcpyCommand + " --window-borderless";
    }

    if (_fullScreen) {
      scrcpyCommand = scrcpyCommand + " --fullscreen";
    }

    if (_showTouches) {
      scrcpyCommand = scrcpyCommand + " --show-touches";
    }

    if (notLinux && _stayAwake) {
      scrcpyCommand = scrcpyCommand + " --stay-awake";
    }

    if (notLinux && _disableScreensaver) {
      scrcpyCommand = scrcpyCommand + " --disable-screensaver";
    }

    if (_framerateValue != 0) {
      scrcpyCommand = scrcpyCommand + " --max-fps $_framerateValue";
    }

    if (notLinux && _videoOrientationValue != 0) {
      scrcpyCommand =
          scrcpyCommand + " --lock-video-orientation $_videoOrientationValue";
    }

    adbDeviceList.forEach((element) async {
      if (element.selected) {
        var deviceSerial = element.deviceName;
        var tempScrcpyCommand = scrcpyCommand + " --serial $deviceSerial";

        try {
          var environment = {
            "scrcpy": scrcpyPath,
            "adb": adbPath,
            "ADB": adbPath
          };
          Shell shell;
          if (Platform.isMacOS) {
            shell = Shell(
                environment: environment, workingDirectory: "/usr/local/bin/");
          } else {
            shell = Shell(environment: environment);
          }
          await shell.run("$tempScrcpyCommand");
        } on ShellException catch (_) {
          // We might get a shell exception
        }
      }
    });
  }

  Future<void> _adb() async {
    adbDeviceSet.clear();
    var controller = ShellLinesController();
    var shell = Shell(stdout: controller.sink, verbose: false);
    controller.stream.listen((event) {
      event = event.trim();

      if (event.toLowerCase() != "list of devices attached") {
        event = event.replaceAll(
            new RegExp(r"\s+"), " "); //Replace multiple space with single space

        var splitAdbDeviceEntry = event.split(" ");

        setState(() {
          adbDeviceSet.add(
              ADBDevice(true, splitAdbDeviceEntry[0], splitAdbDeviceEntry[1]));
        });
        shell.kill();
      }
    });
    try {
      await shell.run('$adbPath devices');
    } on ShellException catch (_) {
      // We might get a shell exception
    }
  }
}
