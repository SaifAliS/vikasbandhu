import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vikasbandhu/recorder_stuff.dart';
import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';

typedef _Fn = void Function();

void dp(dynamic data) => debugPrint("$data");

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "VikasBandhu",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Main_page(),
      builder: EasyLoading.init(),
    );
  }
}

class Main_page extends StatefulWidget {
  const Main_page({Key? key}) : super(key: key);

  @override
  State<Main_page> createState() => _Main_pageState();
}

class _Main_pageState extends State<Main_page> {
  ConvertedResponse? convertedRes;

  final cropCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final unitsCtrl = TextEditingController();
  final actionCtrl = TextEditingController();
  final translatedCtrl = TextEditingController();

  String emptyOrValue(dynamic val) => val == null || val == "" ? "EMPTY" : val;

  final dio = Dio();
  Codec _codec = Codec.pcm16WAV;
  String _mPath = 'tau_file.wav';
  // '/sdcard/Download/temp.wav';
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;
  String filePath = "";
  @override
  void initState() {
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  Future<void> openTheRecorder() async {
    final directory = await getApplicationDocumentsDirectory();
    _mPath = directory.path + '/temp.wav';
    // if (!kIsWeb) {
    //   var status = await Permission.microphone.request();
    //   if (status != PermissionStatus.granted) {
    //     throw RecordingPermissionException('Microphone permission not granted');
    //   }
    // }
    await _mRecorder!.openRecorder();
    // if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
    //   _codec = Codec.opusWebM;
    //   _mPath = 'tau_file.webm';
    //   if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
    //     _mRecorderIsInited = true;
    //     return;
    //   }
    // }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    _mRecorderIsInited = true;
  }

  @override
  void dispose() {
    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      dp("VAlue '$value'");
      setState(() {
        filePath = value ?? "";
      });
    }, onError: (err) {
      dp(err);
    });
  }

  _Fn? getRecorderFn() {
    dp('Came');
    if (!_mRecorderIsInited) {
      return null;
    }
    dp("WHT");
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VikasBandhu"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: getRecorderFn(),
            //   child:
            //       Text(_mRecorder!.isRecording ? "Stop Recording" : 'Record'),
            //   style: OutlinedButton.styleFrom(
            //       shape: CircleBorder(), padding: EdgeInsets.all(37)),
            // ),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    // height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton(
                      onPressed: getRecorderFn(),
                      child: Text(_mRecorder!.isRecording
                          ? "Recording"
                          : "Record Audio"),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Container(
                    height: 50,
                    // height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show();
                        try {
                          File audioFile = File(_mPath);
                          dp(audioFile);
                          List<int> inBits = await audioFile.readAsBytes();
                          dp('in bits done');
                          final inBase63 = base64Encode(inBits);
                          dp('in base 63 done');
                          final res = await dio.post(
                              'https://7mzl29tqtc.execute-api.us-east-1.amazonaws.com/default/aws-python-project-dev-hello',
                              options: Options(headers: {'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*'}),
                              data: {"data": inBase63, "lang": 'te-IN'});

                          dp(res);
                          convertedRes = ConvertedResponse.fromJson(res.data);
                          translatedCtrl.text =
                              emptyOrValue(convertedRes!.text);
                          cropCtrl.text = emptyOrValue(convertedRes!.crops);
                          qtyCtrl.text = emptyOrValue(convertedRes!.quantity);
                          unitsCtrl.text = emptyOrValue(convertedRes!.units);
                          actionCtrl.text = emptyOrValue(convertedRes!.action);
                        } catch (err, s) {
                          debugPrint("$err");
                          dp(s);
                          EasyLoading.showError("$err");
                        } finally {
                          EasyLoading.dismiss();
                        }
                      },
                      child: const Text("Convert audio"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            TextFormField(
              controller: translatedCtrl,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                  labelText: "Translated Text",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.teal))),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Crop : ",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: cropCtrl,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.teal))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Quantity : ",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: qtyCtrl,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.teal))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Units : ",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: unitsCtrl,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.teal))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Action : ",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: actionCtrl,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.teal))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

ConvertedResponse convertedResponseFromJson(String str) =>
    ConvertedResponse.fromJson(json.decode(str));

String convertedResponseToJson(ConvertedResponse data) =>
    json.encode(data.toJson());

class ConvertedResponse {
  ConvertedResponse({
    this.text,
    this.units,
    this.crops,
    this.quantity,
    this.action,
  });

  String? text;
  String? units;
  String? crops;
  String? quantity;
  String? action;

  factory ConvertedResponse.fromJson(Map<String, dynamic> json) =>
      ConvertedResponse(
        text: json["text"],
        units: json["nums"],
        crops: json["crops"],
        quantity: json["quantity"],
        action: json["action"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "nums": units,
        "crops": crops,
        "quantity": quantity,
        "action": action,
      };
}
