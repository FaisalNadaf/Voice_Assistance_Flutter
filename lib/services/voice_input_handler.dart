import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'llama_api_service.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceInputHandler {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final LLaMAApiService _llamaApiService = LLaMAApiService();

  Future<String> checkAndRequestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted ? 'Granted' : 'Denied';
  }

  Future<String> startListening() async {
    try {
      if (await checkAndRequestMicrophonePermission() == 'Denied') {
        return "Microphone permission denied";
      }

      bool available =
          await _speech.initialize(onError: (val) => print("Error: $val"));
      if (!available) throw Exception('Speech recognition unavailable');

      String recognizedText = "";
      await _speech.listen(onResult: (result) {
        recognizedText = result.recognizedWords;
      });

      await Future.delayed(
        Duration(
          seconds: 5,
        ),
      );
      await _speech.stop();
      return recognizedText.isNotEmpty
          ? recognizedText
          : "No speech recognized";
    } catch (e) {
      print("Exception: $e");
      return "Error during speech recognition: $e";
    } finally {
      if (_speech.isListening) await _speech.stop();
    }
  }

  Future<String> getLLaMAResponse(String inputText) async {
    try {
      print("Sending input to LLaMA: $inputText"); // Debug statement
      return await _llamaApiService.getLLaMAResponse(inputText);
    } catch (e) {
      print("Error getting LLaMA response: $e");
      return "Error fetching response from LLaMA";
    }
  }
}
