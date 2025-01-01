import 'package:flutter/material.dart';
import 'package:untitled/screen/home/ui/product_item.dart';
import 'package:untitled/service/product_service.dart';
import 'package:untitled/model/product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ProductService _productService = ProductService();
  List<ProductElement> productElements = []; // Store individual ProductElement objects

  Future<void> _getData() async {
    List<Product> data = await _productService.getProducts();
    setState(() {
      // Flatten the list of ProductElement from all Product objects
      productElements = data.expand((product) => product.products).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 20),
          child: Text(
            "Product",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productElements.length, // Use the flattened list length
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ProductItem(
                  productElement: productElements[index], // Pass individual ProductElement
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
