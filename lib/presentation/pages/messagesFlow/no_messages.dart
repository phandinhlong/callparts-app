import 'package:flutter/material.dart';

import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';
import './new_message_screen.dart';

class NoMessages extends StatelessWidget {
  const NoMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70),
              Center(
                child: Image.asset(
                  'images/messageicon.png',
                  width: 200,
                ),
              ),
              const SizedBox(height: 70),
              const Text1(
                text1: 'No Messages',
              ),
              const SizedBox(height: 10),
              const Text2(
                text2: 'You currently have no incoming messages.',
              ),
              const SizedBox(height: 5),
              const Text2(
                text2: 'Thank you for using FreshMart!',
              ),
              const Spacer(),
              CustomButton(
                text: 'Create a Message',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NewMessageScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
