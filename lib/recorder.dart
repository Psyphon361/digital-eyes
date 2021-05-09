import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

String customPath;

class Recorder extends StatefulWidget {
  static String id = 'recorderState';
  @override
  _Recorderstate createState() => new _Recorderstate();
}

class _Recorderstate extends State<Recorder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF0275D8),
        title: Center(child: Text('Record Audio')),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color(0XFF181820),
        ),
        child: RecorderClass(),
      ),
    );
  }
}

class RecorderClass extends StatefulWidget {
  
  final LocalFileSystem localFileSystem;

  RecorderClass({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new RecorderExampleState();
}

class RecorderExampleState extends State<RecorderClass> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile() async {
    print(customPath);
    File file = File(customPath);

    await storage.ref('audio/audio.wav').putFile(file);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 1.2.h),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.97.h, horizontal: 0.97.w),
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Color(0XFF0275D8),
                        ),
                      ),
                      onPressed: () {
                        switch (_currentStatus) {
                          case RecordingStatus.Initialized:
                            {
                              _start();
                              break;
                            }
                          case RecordingStatus.Recording:
                            {
                              _pause();
                              break;
                            }
                          case RecordingStatus.Paused:
                            {
                              _resume();
                              break;
                            }
                          case RecordingStatus.Stopped:
                            {
                              _init();
                              break;
                            }
                          default:
                            break;
                        }
                      },
                      child: Container(
                        height: 20.0.h,
                        width: 88.8.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _buildText(_currentStatus),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10.0.w,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.record_voice_over,
                              size: 40.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.97.h, horizontal: 0.97.w),
                    child: BlindScreenButton(
                      text: "Stop",
                      buttonHeight: 20.0.h,
                      onPressed: _currentStatus != RecordingStatus.Unset
                          ? _stop
                          : null,
                      icon: Icons.stop,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.97.h, horizontal: 0.97.w),
                    child: BlindScreenButton(
                      onPressed: onPlayAudio,
                      text: "Play",
                      buttonHeight: 20.0.h,
                      icon: Icons.play_arrow,
                    ),
                  ),
                ],
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color(0XFF0275D8),
                  ),
                ),
                onPressed: uploadFile,
                child: Container(
                  child: Center(
                    child: Text(
                      'POST',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 9.0.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        customPath = '/flutter_audio_recorder_';
        Directory appDocDirectory;
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        var current = await _recorder.current(channel: 0);
        setState(() {
          _current = current;
          _currentStatus = current.status;
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  String _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Record Again';
          break;
        }
      default:
        break;
    }
    return text;
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }
}

class BlindScreenButton extends StatelessWidget {
  BlindScreenButton({this.text, this.buttonHeight, this.onPressed, this.icon});

  final buttonHeight;
  final text;
  final Function onPressed;
  final icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          Color(0XFF0275D8),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        height: buttonHeight,
        width: 88.8.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 10.0.w,
                color: Colors.white,
              ),
            ),
            Icon(
              icon,
              size: 50.0,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
