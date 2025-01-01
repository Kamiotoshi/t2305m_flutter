import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget{
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SearchAnchor(
            builder: (BuildContext context, SearchController controller){
              return SearchBar(
                leading: Row(
                  children: [
                    const Icon(Icons.search_outlined)
                  ],
                ),
                onSubmitted: (e){

                },
                hintText: "Search product here...",

              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              return List<Text>.generate(5, (int index) {
                return Text("Item $index");
              },
              );
            }
        )
    );
  }


}