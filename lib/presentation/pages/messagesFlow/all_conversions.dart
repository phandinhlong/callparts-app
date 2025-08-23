import 'package:flutter/material.dart';

import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';
import 'no_messages.dart';

class AllConversions extends StatelessWidget {
  const AllConversions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black45),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Image.asset('images/c3.png', width: 40),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text1(
                  text1: 'Customer 3',
                ),
                Text2(
                  text2: 'Online',
                ),
              ],
            ),
            const Spacer(),
            const Row(
              children: [
                Icon(
                  Icons.call,
                  color: AppColors.text3Color,
                  size: 16,
                ),
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.video_call,
                  color: AppColors.text3Color,
                  size: 20,
                ),
              ],
            )
          ],
        ),
      ),
      body: const ChatBody(),
    );
  }
}

class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Expanded(
          child: ListView(
            children: const [
              ChatBubble(
                text: 'Hello, I need help with my order.',
                isSender: true,
                time: '09:30 am',
              ),
              ChatBubble(
                text: 'Sure, what seems to be the problem?',
                isSender: false,
                time: '09:31 am',
              ),
              ChatBubble(
                text: 'I did not receive all the items I ordered.',
                isSender: true,
                time: '09:33 am',
              ),
              ChatBubble(
                text:
                    'I apologize for the inconvenience. Can you please provide the order number?',
                isSender: false,
                time: '09:35 am',
              ),
              ChatBubble(
                text: 'Order #12345',
                isSender: true,
                time: '09:37 am',
                isFile: false,
              ),
              ChatBubble(
                text: 'Thank you. Let me check the details for you.',
                isSender: false,
                time: '09:38 am',
              ),
              ChatBubble(
                text:
                    'I see that the apples you ordered are out of stock. Would you like a refund or a replacement with another product?',
                isSender: false,
                time: '09:40 am',
              ),
              ChatBubble(
                text:
                    'A replacement would be great. Could you replace them with oranges?',
                isSender: true,
                time: '09:42 am',
              ),
              ChatBubble(
                text:
                    'Sure, I have updated your order. You will receive the oranges instead of apples.',
                isSender: false,
                time: '09:45 am',
              ),
              ChatBubble(
                text: 'Thank you so much for your help!',
                isSender: true,
                time: '09:46 am',
              ),
              ChatBubble(
                text: 'You are welcome! Have a great day!',
                isSender: false,
                time: '09:47 am',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    suffixIcon: Image.asset('images/Emoji.png'),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: AppColors.buttonColor,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const NoMessages()));
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final String time;
  final bool isVoiceMessage;
  final bool isFile;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isSender,
    required this.time,
    this.isVoiceMessage = false,
    this.isFile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isVoiceMessage)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isSender ? Colors.orange[50] : Colors.green[50],
                borderRadius: isSender
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )
                    : const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
              ),
              child: Text(
                text,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          if (isVoiceMessage)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 11),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xff000120),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      )),
                  const SizedBox(width: 10),
                  Image.asset(
                    'images/Group 28.png',
                    color: const Color(0xff000120),
                  )
                ],
              ),
            ),
          if (isFile)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 11),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.attach_file, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: const TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ),
          const SizedBox(
            height: 7,
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
