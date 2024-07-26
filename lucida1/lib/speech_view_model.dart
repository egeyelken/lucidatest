import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class SpeechViewModel extends ChangeNotifier {
  stt.SpeechToText _speech = stt.SpeechToText();
  FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _transcription = '';
  String _status = 'Press the microphone to start speaking';
  String _response = '';

  bool get isListening => _isListening;
  String get transcription => _transcription;
  String get status => _status;
  String get response => _response;

  SpeechViewModel() {
    _initializeTTS();
  }

  void _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
  }

  void listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _isListening = true;
        _status = 'Listening...';
        notifyListeners();
        _speech.listen(
          onResult: (val) {
            _transcription = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _transcription += ' (confidence: ${val.confidence})';
            }
            _speech.stop(); // Stop listening once we have the result
            _respondToSpeech(_transcription);
            notifyListeners();
          },
        );
      }
    } else {
      _isListening = false;
      _status = 'Press the microphone to start speaking';
      notifyListeners();
      _speech.stop();
    }
  }

  void _respondToSpeech(String userSpeech) async {
    _status = 'Responding...';
    notifyListeners();

    _response = _getResponse(userSpeech);
    await _flutterTts.speak(_response);

    _status = 'Response given';
    notifyListeners();

    // Reset state after response
    _isListening = false;
    _transcription = '';
    notifyListeners();
  }

  String _getResponse(String userSpeech) {
    userSpeech = userSpeech.toLowerCase();
    if (userSpeech.contains('hello')) {
      return 'Hello! How can I assist you?';
    } else if (userSpeech.contains('weather')) {
      return 'The weather today is sunny.';
    } else {
      return 'I did not understand that. Please repeat.';
    }
  }
}
