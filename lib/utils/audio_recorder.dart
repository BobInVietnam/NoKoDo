import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audio_session/audio_session.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const theSource = AudioSource.microphone;

class AudioRecorder extends ChangeNotifier {
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  // FlutterSoundPlayer? _player = FlutterSoundPlayer();
  String recordingName = "";
  bool _recorderIsInited = false;
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';

  AudioRecorder() {
    _init();
  }

  Future<void> _init() async {
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

    final tmpDir = await getTemporaryDirectory();
    _mPath = path.join(tmpDir.path, 'tau_file.mp4');
    // _player!.openPlayer().then((value) {
    //   setState(() {
    //     _mPlayerIsInited = true;
    //   });
    // });

    await openTheRecorder().then((value) {
      _recorderIsInited = true;
      notifyListeners();
    });
    debugPrint("RECORDER: Finished init");
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _recorder!.openRecorder();
    if (!await _recorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _recorder!.isEncoderSupported(_codec) && kIsWeb) {
        _recorderIsInited = true;
        return;
      }
    }
    _recorderIsInited = true;
  }

  Future<void> record({String sid = "S0"}) async {
    await _recorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    );
    final now = DateTime.now();
    recordingName = "${sid}_nokodoaudio_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.mp4";
    debugPrint("RECORDER: Recording started.");
    _isRecording = true;
    notifyListeners();
  }

  Future<String> stop() async {
    await _recorder!.stopRecorder();
    debugPrint("RECORDER: Saving...");
    _isRecording = false;
    try {
      final recordingFile = File(_mPath);
      final bytes = await recordingFile.readAsBytes();
      final recordingPath = await FileSaver.instance.saveFile(
        name: recordingName,
        bytes: bytes,
        mimeType: MimeType.mp4Audio,
      );

      debugPrint("RECORDER: Saved successfully at $recordingPath");
      notifyListeners();
      return recordingPath;
    } catch (e) {
      debugPrint("ERROR SAVING AUDIO RECORDING: $e");
      notifyListeners();
      return "";
    }
  }

  // bool _playbackReady = false;
  // bool _mPlayerIsInited = false;

  // /// Begin to play the recorded sound
  // void play() {
  //   assert(_mPlayerIsInited &&
  //       _playbackReady &&
  //       _recorder!.isStopped &&
  //       _player!.isStopped);
  //   _player!
  //       .startPlayer(
  //       fromURI: _mPath,
  //       whenFinished: () {
  //         setState(() {});
  //       })
  //       .then((value) {
  //     setState(() {});
  //   });
  // }
  //
  // /// Stop the player
  // void stopPlayer() {
  //   _player!.stopPlayer().then((value) {
  //     setState(() {});
  //   });
  // }
  @override
  Future<void> dispose() async {
    await _recorder!.closeRecorder();
    _recorder = null;
    super.dispose();
  }
}