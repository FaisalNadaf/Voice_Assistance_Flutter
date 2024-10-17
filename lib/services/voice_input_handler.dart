import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'llama_api_service.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceInputHandler {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final LLaMAApiService _llamaApiService = LLaMAApiService();

  Future<String> checkAndRequestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      // Request permission and wait for the result
      status = await Permission.microphone.request();
    }
    return status.isGranted ? 'Granted' : 'Denied';
  }

  Future<String> startListening() async {
    try {
      // Check for microphone permission
      String permissionStatus = await checkAndRequestMicrophonePermission();
      if (permissionStatus == 'Denied') {
        return "Microphone permission denied";
      }

      // Initialize speech recognition
      bool available = await _speech.initialize(
        onError: (val) => print("Error: $val"),
        debugLogging: true,
      );

      if (available) {
        String recognizedText = "a for apple"; // Default fallback text

        // Start listening and capture the recognized words
        await _speech.listen(onResult: (result) {
          recognizedText = result.recognizedWords;
          print("Recognized words: $recognizedText");
        });

        // Optionally stop listening after a certain duration
        await Future.delayed(
          Duration(
            seconds: 10,
          ),
        );

        // Ensure stopListening is always called
        await _speech.stop();
        await getLLaMAResponse(recognizedText);
        return recognizedText.isNotEmpty
            ? recognizedText
            : "No speech recognized";
      } else {
        throw Exception('Speech recognition unavailable');
      }
    } catch (e) {
      print("Exception: $e");
      return "Error during speech recognition: $e";
    } finally {
      // Ensure that we always stop listening even if an error occurs
      if (_speech.isListening) {
        await _speech.stop();
      }
    }
  }

  Future<String> getLLaMAResponse(String inputText) async {
    try {
      return await _llamaApiService.getLLaMAResponse(inputText);
    } catch (e) {
      print("Error getting LLaMA response: $e");
      return "Error fetching response from LLaMA";
    }
  }
}
