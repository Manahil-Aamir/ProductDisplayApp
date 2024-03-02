import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:productdisplay/models/product_model.dart';

class ProductDisplay extends StatefulWidget {
  const ProductDisplay({super.key});


  @override
  State<ProductDisplay> createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {

  String text = "";

   late Future<List<Products>> futureProductsList;

  Future<List<Products>> fetchProducts() async{
    Uri uriobject = Uri.parse('https://dummyjson.com/products');
    
    final response = await http.get(uriobject);
    print(response.body);
    if(response.statusCode == 200){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> parsedListJson = jsonResponse['products'];
      print(parsedListJson);
      print('hi');

      List<Products> itemsList = List<Products>.from(
        parsedListJson.map<Products>(
          (dynamic prod) => Products.fromJson(prod),
        ).toList(),
      );
      print(itemsList);
      return itemsList;
      }

      else{
          throw Exception('Failed to find json');
    }

  }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureProductsList = fetchProducts();
  }

  String title(String t){
    if(t.length>20){
      text = t.substring(0,20);
    }
    else{
      text = t;
    }
    return text;
  }



  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products',
        style: TextStyle(
          fontWeight: FontWeight.normal,
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(    
        child: FutureBuilder(
          future: futureProductsList, 
          builder: ((context, snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
           return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
            var product = snapshot.data![index];
          
return Card(
  child: Column(
    children: <Widget>[
      Row(
        children: [
        Expanded(
          child: Container(
          height: 100.0,
          width: MediaQuery.of(context).size.width,
          child: Image.network(product.thumbnail.toString(),
          fit: BoxFit.cover,),
        ),
        ),
        ],
      ),
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(title(product.title),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,),
          ),
          const Spacer(),
          Row(children: [
            Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
            product.price.toString() + " USD",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              
            ),
            
          ),
          
        
          ),
IconButton(
  onPressed: () {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: 250.0, // Adjust the height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: product.images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: AspectRatio(aspectRatio: 3/4,
                      child: Image.network(
                        product.images[index],
                        width: 150.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                      ),
                    );
                  },
                ),
              ),
             // Add some space between the ListView.builder and the Text widget
              Row(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child :Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                
                ),
              ],),
                            Row(children: [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child :Text(
                    product.description.toString(),
                    style: TextStyle(
                      fontSize: 15.0,
                      
                    ),
                  ),
                
                ),
              ],),
                            Row(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child :Text(
                    "\$"+product.price.toString(),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                
                ),
              ],),
              Row(
                children: [
                  Icon(Icons.star,
                  color: Colors.yellow),
                  Text(
                    product.rating.toString(),
                    style: TextStyle(
                      fontSize: 15.0,
                      
                    ),
                  ),
                  const Spacer(),
                  Text(
                    product.discountPercentage.toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.discount,
                  color: Colors.blue),),
                ],
              )
            ],
          ),
        );
      },
    );
  },
  icon: Icon(Icons.remove_red_eye_sharp)
  ),
          ],
),
        ],),
          
    
      
      Row(
        children: [
         Expanded(child: Padding(padding: EdgeInsets.all(6.0),
          child: Text(product.description.toString()),),
         ),
        ],
      ),
    ],
  ),
);




              },
            );
        
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return CircularProgressIndicator();
        }),)
          
        ),
      );
  }
}