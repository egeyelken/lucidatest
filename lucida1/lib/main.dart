import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'speech_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpeechViewModel(),
      child: MaterialApp(
        title: 'Lucida AI Assistant',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SpeechViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lucida AI Assistant'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(viewModel.status),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  viewModel.listen();
                },
                child: Icon(
                  viewModel.isListening ? Icons.mic : Icons.mic_none,
                  size: 36,
                ),
              ),
              SizedBox(height: 20),
              if (viewModel.transcription.isNotEmpty)
                Text(
                  'Transcription: ${viewModel.transcription}',
                  style: TextStyle(fontSize: 16),
                ),
              if (viewModel.response.isNotEmpty)
                Text(
                  'Response: ${viewModel.response}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
