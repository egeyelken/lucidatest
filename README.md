# Lucida AI Assistant

A Flutter application that utilizes speech recognition and text-to-speech functionalities to create an AI assistant. This project includes features such as theme toggling and a pulsating microphone button when listening.

## Features

- **Speech Recognition**: Recognizes and processes spoken words.
- **Text-to-Speech (TTS)**: Converts text responses to speech.
- **Theme Toggling**: Switch between light and dark themes.
- **Pulsating Microphone Button**: Animated button when the app is listening.

## Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Xcode: Latest version from the Mac App Store
- CocoaPods: [Install CocoaPods](https://guides.cocoapods.org/using/getting-started.html#installation)

## Getting Started

### Clone the Repository

```sh
git clone [https://github.com/yourusername/lucida_ai_assistant.git](https://github.com/egeyelken/lucidatest.git)
cd lucidatest
cd lucida1

### Install Dependencies
flutter pub get
cd ios
pod install
cd ..


### Configure iOS Permissions
Ensure the following keys are present in your Info.plist file for microphone and speech recognition permissions:

<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone for speech recognition.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>We need access to speech recognition services.</string>
<key>NSSpeechSynthesizerUsageDescription</key>
<string>We need access to speech synthesis services.</string>

### Run the App
flutter run

