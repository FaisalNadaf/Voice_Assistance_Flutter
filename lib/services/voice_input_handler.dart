import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'llama_api_service.dart';

class VoiceInputHandler {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final LLaMAApiService _llamaApiService = LLaMAApiService();

  Future<String> startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      String recognizedText = "";
      await _speech.listen(onResult: (result) {
        recognizedText = result.recognizedWords;
      });
      return recognizedText;
    } else {
      throw Exception('Speech recognition unavailable');
    }
  }

  Future<String> getLLaMAResponse(String inputText) async {
    return await _llamaApiService.getLLaMAResponse(inputText);
  }
}
