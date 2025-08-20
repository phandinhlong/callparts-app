import 'package:flutter/material.dart';
import '../../../Constants/colors.dart';
import '../../../Widgets/detailstext1.dart';
import '../../../Widgets/detailstext2.dart';
import '../Screens/Home/details.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;

  const ProductCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StarterBatteryDetailsScreen(),
            ),
          );
        },
      child: Card(

           elevation: 3,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StarterBatteryDetailsScreen(),
                    ),
                  );
                },
                child: SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)
                        ),

                        child: Image.asset(
                          width: 120,

                          imagePath,
                          fit: BoxFit.fill,
                        ),
                      ),
                     Positioned(
                       right: 2,

                       child:  GestureDetector(
                       onTap: () {
                         Navigator.of(context).push(MaterialPageRoute(
                             builder: (context) =>  const StarterBatteryDetailsScreen())
                         );
                       },
                       child: const CircleAvatar(
                         radius: 13,
                         backgroundColor: AppColors.buttonColor,
                         child: Icon(
                           Icons.favorite_border,
                           size: 17,
                           color: Colors.white,
                         ),
                       ),
                     ),)

                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text1(text1: name, size: 15, color: AppColors.text1Color),
                    const Spacer(),
                    Text1(text1: price, color: AppColors.text1Color),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.text3Color, size: 17),
                        Icon(Icons.star, color: AppColors.text3Color, size: 17),
                        Icon(Icons.star, color: AppColors.text3Color, size: 17),
                        Icon(Icons.star, color: AppColors.text3Color, size: 17),
                        Text2(text2: ' (3.5)', color: AppColors.text2Color),
                      ],
                    ),
                    Spacer(),
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.buttonColor,
                      child: Icon(
                        Icons.add,
                        size: 15,
                        color: AppColors.buttonTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
