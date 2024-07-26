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
    _flutterTts.setCompletionHandler(() {
      _status = 'Press the microphone to start speaking';
      notifyListeners();
    });
    _flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg");
      _status = 'TTS Error: $msg';
      notifyListeners();
    });
  }

  void listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          if (val == 'notListening' && _isListening) {
            _isListening = false;
            notifyListeners();
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _isListening = true;
        _status = 'Listening...';
        notifyListeners();
        _speech.listen(
          onResult: (val) async {
            _transcription = val.recognizedWords;
            print('Transcription: $_transcription');
            if (val.hasConfidenceRating && val.confidence > 0) {
              _transcription += ' (confidence: ${val.confidence})';
            }
            if (val.finalResult) {
              await _speech.stop(); // Ensure the listening stops
              _respondToSpeech(_transcription);
            }
            notifyListeners();
          },
        );
      }
    } else {
      _isListening = false;
      _status = 'Press the microphone to start speaking';
      notifyListeners();
      await _speech.stop();
    }
  }

  void _respondToSpeech(String userSpeech) async {
    _status = 'Responding...';
    notifyListeners();

    _response = _getResponse(userSpeech);
    print('Response: $_response');
    notifyListeners();
    await _speakResponse(_response);
  }

  Future<void> _speakResponse(String response) async {
    try {
      await _flutterTts.speak(response);
    } catch (e) {
      print("Error speaking: $e");
      _status = 'Error speaking: $e';
      notifyListeners();
    }

    // Reset state after response
    _isListening = false;
    _transcription = '';
    _status = 'Press the microphone to start speaking';
    notifyListeners();
  }

  String _getResponse(String userSpeech) {
    userSpeech = userSpeech.toLowerCase().trim();
    print('Processed user speech: $userSpeech');
    if (userSpeech.contains('hello')) {
      return 'Hello! How can I assist you?';
    } else if (userSpeech.contains('weather')) {
      return 'The weather today is sunny.';
    } else {
      return 'I did not understand that. Please repeat.';
    }
  }
}
