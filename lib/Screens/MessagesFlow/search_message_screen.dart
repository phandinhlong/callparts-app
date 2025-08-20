import 'package:flutter/material.dart';
import 'package:autopartsstoreapp/Widgets/customapp_bar.dart';

import '../../Constants/colors.dart';
import '../../Widgets/customtextfield.dart';
import '../../Widgets/detailstext1.dart';
import '../../Widgets/detailstext2.dart';


class SearchMessagesScreen extends StatelessWidget {
  const SearchMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              child: CustomAppBar(text: 'Search Messages', text1: ''),
            ),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(label: 'Search',icon: Icons.search,)
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildConversation('Customer 1', 'Can I get an update on my order?', 'images/c1.png', '12:34 pm', 1),
                  _buildConversation('Customer 2', 'Is the product available?', 'images/c2.png', '12:34 pm', 1),
                  _buildConversation('Customer 3', 'Thank you for the quick response!', 'images/c3.png', '12:34 pm', 0, true),
                  _buildConversation('Customer 4', 'I am looking for organic products.', 'images/c4.png', '12:34 pm', 0, true),
                  _buildConversation('Customer 5', 'Can I get a discount on bulk purchase?', 'images/c5.png', '12:34 pm', 1),
                  _buildConversation('Customer 6', 'What is the current discount?', 'images/c3.png', '12:34 pm', 1),
                  _buildConversation('Customer 7', 'I have an issue with my order.', 'images/c2.png', '12:34 pm', 0, true),
                  _buildConversation('Customer 1', 'Can you deliver by tomorrow?', 'images/c1.png', '12:34 pm', 0, true),
                  _buildConversation('Customer 2', 'I need more details about the product.', 'images/c4.png', '12:34 pm', 1),
                  _buildConversation('Customer 3', 'Can you confirm the delivery time?', 'images/c1.png', '12:34 pm', 0, true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversation(String name, String message, String imagePath, String time, [int unreadCount = 0, bool isYourTurn = false]) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.tabColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text1(text1: name),
        subtitle: Text2(text2:  message),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (unreadCount > 0)
              CircleAvatar(
                radius: 12,
                backgroundColor:AppColors.buttonColor,
                child: Text('$unreadCount', style: const TextStyle(color: Colors.white)),
              ),
            if (isYourTurn)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Your turn',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            const SizedBox(height: 4),
            Text(time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        onTap: () {
          // Navigate to conversation details screen
        },
      ),
    );
  }
}
