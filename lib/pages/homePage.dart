import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voice_assistance_flutter/services/llama_api_service.dart';
import 'package:voice_assistance_flutter/services/voice_assistant.dart';
import 'package:voice_assistance_flutter/services/voice_input_handler.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class VoiceBotHomePage extends StatefulWidget {
  @override
  _VoiceBotHomePageState createState() => _VoiceBotHomePageState();
}

class _VoiceBotHomePageState extends State<VoiceBotHomePage> {
  final List<Map<String, String>> messages = [];
  final LLaMAApiService llamaApiService = LLaMAApiService();
  final VoiceInputHandler voiceInputHandler = VoiceInputHandler();
  final VoiceAssistant voiceAssistant = VoiceAssistant();
  final ScrollController _scrollController = ScrollController();

  bool isListening = false;
  bool isWaitingForBotResponse = false;

  void sendMessage(String message) {
    setState(() {
      messages.add({"user": message});
      isWaitingForBotResponse = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    _getBotResponse(message);
  }

  void _getBotResponse(String userMessage) async {
    String llamaResponse = await llamaApiService.getLLaMAResponse(userMessage);
    setState(() {
      messages.add({"bot": llamaResponse});
      isWaitingForBotResponse = false;
    });
    await voiceAssistant.speak(llamaResponse);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void handleVoiceInput() async {
    setState(() {
      isListening = true;
    });

    String recognizedText = await voiceInputHandler.startListening();
    if (recognizedText.isNotEmpty) {
      sendMessage(recognizedText);
    }

    setState(() {
      isListening = false;
    });
  }

  void clearMessages() {
    setState(() {
      messages.clear();
    });
  }

  @override
  void dispose() {
    clearMessages();
    _scrollController.dispose();
    super.dispose();
  }

  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: SizedBox(
                height: _deviceHeight * 0.2,
                child: Image.asset(
                  'assets/images/SplashLogo-removebg.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Zoe',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: clearMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length +
                  (isWaitingForBotResponse || isListening ? 1 : 0),
              itemBuilder: (context, index) {
                if (isListening && index == messages.length) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: ChatBubble(
                      alignment: Alignment.centerRight,
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      backGroundColor: Color(0xFF1B97F3),
                      clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.2,
                        ),
                        child: SpinKitThreeBounce(
                          color: Colors.black,
                          size: _deviceHeight * 0.020,
                        ),
                      ),
                    ),
                  );
                }

                if (isWaitingForBotResponse && index == messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Image.asset(
                              'assets/images/SplashLogo-removebg.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: 20),
                          SpinKitThreeBounce(
                            color: Colors.deepPurple,
                            size: _deviceHeight * 0.020,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                bool isUserMessage = messages[index].containsKey("user");

                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: isUserMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUserMessage)
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            'assets/images/SplashLogo-removebg.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      Container(
                          child: isUserMessage
                              ? ChatBubble(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 4),
                                  backGroundColor: Color(0xFF1B97F3),
                                  clipper: ChatBubbleClipper3(
                                      type: BubbleType.sendBubble),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    child: Text(
                                      messages[index]["user"] ?? '',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                )
                              : ChatBubble(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(vertical: 6),
                                  backGroundColor: Colors.grey[200]!,
                                  clipper: ChatBubbleClipper8(
                                      type: BubbleType.receiverBubble),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    child: Text(
                                      messages[index]["bot"] ?? '',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                )

                          // BubbleSpecialOne(
                          //     text: messages[index]["bot"] ?? '',
                          //     color: Colors.grey[200]!,
                          //     tail: true,
                          //     isSender: false,
                          //     textStyle: TextStyle(
                          //         color: Colors.black, fontSize: 16),
                          //   ),
                          ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: isListening ? null : handleVoiceInput,
              label: Container(
                child: isListening ? Icon(Icons.mic_off) : Icon(Icons.mic),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
