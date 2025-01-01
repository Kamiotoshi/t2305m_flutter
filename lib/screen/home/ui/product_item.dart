import 'package:flutter/material.dart';
import 'package:untitled/model/product.dart';

class ProductItem extends StatelessWidget {
  final ProductElement productElement; // Change this to ProductElement
  const ProductItem({super.key, required this.productElement});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network("https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png",
          width: 150,
          height: 120,
        ),
        Text(productElement.title ?? ""), // Access title from ProductElement
      ],
    );
  }
}
