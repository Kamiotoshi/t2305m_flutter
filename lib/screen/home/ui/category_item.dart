import 'package:flutter/material.dart';
import 'package:untitled/model/category.dart';

class CategoryItem extends StatelessWidget{
  final Category category;
  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network("https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png",
        width: 150,
        height: 120,
        ),
        Text(category.name??"")
      ],
    );
  }
  
}