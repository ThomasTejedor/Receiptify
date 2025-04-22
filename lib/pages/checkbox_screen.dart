import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ocr_service.dart';
import '../widgets/checkbox_widget.dart';

class CheckboxPage extends StatefulWidget{
  CheckboxPage({super.key, this.imageFile});
  File? imageFile;
  
  @override
  State<StatefulWidget> createState() => _CheckboxPageState();

}

class _CheckboxPageState extends State<CheckboxPage> {

  String _imageText = 'Text could not be found in this image';
  
  List<CheckboxWidget> _items = [CheckboxWidget(1.538, "hello"),CheckboxWidget(2, "test"),CheckboxWidget(3, "hello1"),CheckboxWidget(1, "test1"),CheckboxWidget(1, "hello2"),CheckboxWidget(0, "test2"),CheckboxWidget(0, "hello3"),CheckboxWidget(0, "test3"),CheckboxWidget(0, "hello"),CheckboxWidget(0, "test"),CheckboxWidget(0, "hello"),CheckboxWidget(0, "test")];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Receiptify'
        )
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: widget.imageFile == null
            ? Center(child: Text('No image selected'))
            : image(),
    );
  }

  Widget image() {
    return Padding(
      padding: EdgeInsets.all(10),
      child:
        Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //Image of the receipt
              Center(
                child: Image.file(
                  widget.imageFile!,
                  height: 250
                ),
              ),
              
              //Title for the list i.e Title/price
              Padding(
                padding: EdgeInsets.all(5),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Item",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        "Price",
                        style: Theme.of(context).textTheme.headlineMedium,  
                      ),
                    ],
                  ),
                ),
              ),

              //List of receipt items
              Expanded(
                child: _items.isEmpty
                  ? Text("No items found in this image")
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _items[index].getCheckboxWidget(this);
                        },
                      ),
                    ),
              ),

              //Bottom Bar for adding items and total amt
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    //Button to add items
                    IconButton(
                      iconSize: 40,
                      icon: const Icon(
                        Icons.add_box_outlined
                      ),
                      onPressed: () {
                        setState(() {
                          _items.add(CheckboxWidget(0,"Item"));
                        });
                      },
                    ),

                    //Display total of checked items
                    Text(
                      "Total: \$${CheckboxWidget.getTotal().toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.headlineMedium, 
                    ),
                  ],
                )
              ),
            ]
         ),
    );
  }
}