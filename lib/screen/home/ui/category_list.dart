import 'package:flutter/material.dart';
import 'package:untitled/model/category.dart';
import 'package:untitled/screen/home/ui/category_item.dart';
import 'package:untitled/service/category_service.dart';

class CategoryList extends StatefulWidget{
  const CategoryList({super.key});
  @override
  _CategoryListState createState() => _CategoryListState();
}
class _CategoryListState extends State<CategoryList>{
  final CategoryService _categoryService = CategoryService();
  List<Category> categories = [];
  Future<void> _getData() async{
    List<Category> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
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
          padding: EdgeInsets.only(left:10,top: 20,right: 10,bottom: 20),
          child: Text("Category",
                 style: TextStyle(
                   color: Colors.red,
                   fontSize: 25.0,
                   fontWeight: FontWeight.bold,
                 ),
          ),
        ),

        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context,index){
              return Padding(
                  padding: const EdgeInsets.all(10.0),
                  // child: Text(categories[index].name??""),
                  child: CategoryItem(category: categories[index],),
              );
            },
          ),
        )
      ],
    );
  }

}