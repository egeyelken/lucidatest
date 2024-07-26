import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'speech_view_model.dart';
import 'theme_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpeechViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Lucida AI Assistant',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SpeechViewModel>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Lucida AI Assistant'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text('Toggle Theme'),
              onTap: () {
                themeProvider.toggleTheme();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
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
