import 'dart:io';

import 'package:flutter/material.dart';
import 'package:autopartsstoreapp/Screens/Wishlist/wishlist_details_screen.dart';
import 'package:autopartsstoreapp/Widgets/customapp_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../../Widgets/custombtn.dart';
import '../../Widgets/customtextfield.dart';
import '../../Widgets/detailstext1.dart';


class AddToWishlist extends StatefulWidget {
  const AddToWishlist({super.key});

  @override
  AddToWishlistState createState() => AddToWishlistState();
}

class AddToWishlistState extends State<AddToWishlist> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(
                text: 'Add To Wishlist',
                text1: '',
              ),
              const SizedBox(height: 30),
              const CustomTextField(label: 'Product Name', icon: Icons.label),
              const CustomTextField(label: 'Product Price', icon: Icons.attach_money),
              const CustomTextField(
                  label: 'Product Brand', icon: Icons.branding_watermark),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showImageSourceActionSheet(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 13),
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Center(
                    child: _image == null
                        ? const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined,
                                  color: Colors.grey, size: 50),
                              SizedBox(height: 10),
                              Text1(text1: 'Upload Images here')
                            ],
                          )
                        : SizedBox(
                          height: 200,
                        width: 300,


                        child: Image.file(_image!, fit: BoxFit.cover)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
        child: CustomButton(
          text: 'Save',
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const WishlistDetailsScreen())
            );
          },
        ),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
