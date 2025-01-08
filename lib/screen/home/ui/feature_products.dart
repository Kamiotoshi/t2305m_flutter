import 'package:flutter/material.dart';
import 'package:untitled/model/feature_product.dart';
import 'package:untitled/screen/home/ui/product_item.dart';
import 'package:untitled/service/product_service.dart';

class FeatureProducts extends StatefulWidget{
  const FeatureProducts({super.key});

  @override
  _FeatureProductsState createState()=> _FeatureProductsState();


}
class _FeatureProductsState extends State<FeatureProducts>{
  final ProductService _productService = ProductService();
  List<Product> products = [];
  Future<void> getProducts() async{
    FeatureProduct? featureProduct = await _productService.getProducts(12);
    if(featureProduct!=null){
      setState(() {
        products = featureProduct.products;
      });
    }
  }

  @override
  void initState() {
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10,top: 20,right: 10,bottom: 20),
          child: const Text("Feature Products",
            style: TextStyle(
              color: Colors.red,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 300,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ProductItem(product: products[index]),
                );
              }
          ),
        )
      ],
    );
  }
}