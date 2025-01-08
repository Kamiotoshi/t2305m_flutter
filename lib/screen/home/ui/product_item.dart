import 'package:flutter/material.dart';
import 'package:untitled/model/feature_product.dart';


class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({required this.product});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
        child: Column(
          children: [
            Image.network(product.thumbnail??"",
                width: 150,
                height: 120),
            Text(product.title??""),
            Text(product.price.toString()??""),
            FloatingActionButton(
              onPressed: (){},
              child: Icon(Icons.add_shopping_cart_rounded),
            )
          ],
        ),
      ),
    );
  }
}