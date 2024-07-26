import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class SpeechViewModel extends ChangeNotifier {
  stt.SpeechToText _speech = stt.SpeechToText();
  FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  bool _isSpeaking = false;
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
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.5);
    _flutterTts.setCompletionHandler(() {
      print("TTS: Completed speaking");
      _isSpeaking = false;
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
    if (!_isListening && !_isSpeaking) {
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
      _stopListening();
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
      _status = 'Press the microphone to start speaking';
      notifyListeners();
      print('Stopped listening');
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
    int retryCount = 0;
    bool success = false;

    while (retryCount < 3 && !success) {
      try {
        _isSpeaking = true;
        print("TTS: Stopping any ongoing speech");
        await _flutterTts.stop(); // Ensure any ongoing TTS is stopped
        print("TTS: About to speak response: $response");
        var result = await _flutterTts.speak(response);
        print("TTS: Speak result: $result");
        if (result == 1) {
          success = true;
          print("TTS: Speech started successfully");
        } else {
          print("TTS: Speech failed to start");
          retryCount++;
        }
        await Future.delayed(Duration(seconds: 2)); // Increase delay to avoid immediate re-listening
      } catch (e) {
        print("Error speaking: $e");
        _status = 'Error speaking: $e';
        notifyListeners();
        retryCount++;
      }
    }

    if (!success) {
      print("TTS: Failed to speak after $retryCount retries");
      _status = 'Failed to speak';
      notifyListeners();
    }

    // Reset state after response
    _isSpeaking = false;
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
