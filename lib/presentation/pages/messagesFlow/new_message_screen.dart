import 'package:flutter/material.dart';

import 'package:callparts/presentation/widgets/custom_app_bar.dart';
import 'package:callparts/presentation/widgets/custom_text_field.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/custom_outlined_button.dart';
import './all_conversions.dart';
import './archived_messages_screen.dart';

class NewMessageScreen extends StatelessWidget {
  const NewMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              child: CustomAppBar(text: 'New Messages', text1: ''),
            ),
            const SizedBox(height: 10),
            const CustomTextField(
              label: 'To',
              icon: Icons.person_add_alt_1,
            ),
            const SizedBox(height: 20),
            const CustomTextField(
              label: 'Message',
              icon: Icons.message,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Send',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllConversions()),
                );
              },
            ),
            CustomOutlinedButton(
              text: 'Archived Messages',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ArchivedMessagesScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
