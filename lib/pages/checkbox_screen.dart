import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../services/ocr_service.dart';
import '../widgets/checkbox_widget.dart';

class CheckboxPage extends StatefulWidget{
  const CheckboxPage({super.key, required this.userData});
  final PassData userData;
  @override
  State<StatefulWidget> createState() => _CheckboxPageState();
  
}

class _CheckboxPageState extends State<CheckboxPage> {

  double _taxPercent = 0;
  bool _editTax = false;
  final _formkey = GlobalKey<FormState>();
  final _taxState = ObjectKey(TextFormField);
  late CheckboxList _items;
  late TextEditingController _taxText;
  late File? _imageFile; 

  @override
  void initState() {
    super.initState();
    _items = CheckboxList(widget.userData.items!);
    _taxText = TextEditingController(text: (_items.total*_taxPercent).toStringAsFixed(2));
    _imageFile = widget.userData.userPicture;
  }
  @override
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
      child: _imageFile == null
            ? Center(child: Text('No image selected'))
            : image(),
    );
  }

  Widget image() {
    return Form(
      key: _formkey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child:
          Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //Image of the receipt
                Center(
                  child: Image.file(
                    _imageFile!,
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
                  child: _items.size == 0
                    ? Text("No items found in this image")
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                          itemCount: _items.size,
                          itemBuilder: (BuildContext context, int index) {
                            return _items.getCheckbox(index).getCheckboxWidget(this, _items, _formkey);
                          },
                        ),
                      ),
                ),

                //Bottom Bar for adding items and total amt
                SizedBox(
                  height: 200,
                  child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //Display subtotal of checked items
                      Text(
                        "Subtotal: \$${_items.total.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      _editTax
                      ? //Display edit of taxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          
                          //add changes
                          IconButton(
                            icon: const Icon(
                              Icons.add
                            ),
                            onPressed: () {
                              if(_formkey.currentState!.validate()){
                                setState(() {
                                  double _taxes = double.parse(_taxText.text);
                                  _taxes = double.parse(_taxes.toStringAsFixed(2));
                                  _taxPercent = _taxes / _items.total; 
                                  _editTax = false;
                                });
                              }
                            }
                          ),

                          //remove changes
                          IconButton(
                            icon: const Icon(
                              Icons.remove
                            ),
                            onPressed: () {
                              setState(() {
                                _editTax = false;
                              });
                            }
                          ),
                          SizedBox(
                            height: 40,
                            width: 100,
                            child: TextFormField (
                              textAlignVertical: TextAlignVertical.center,
                              key: _taxState,
                              controller: _taxText,
                              validator: MultiValidator([
                                RequiredValidator( 
                                  errorText: 'Enter price'), 
                                MaxLengthValidator(8,
                                  errorText:
                                    'Do not enter more than 8 digits'),
                                PatternValidator(r'(^\d+(\.\d{2})?$)', 
                                  errorText: 
                                    '#.##')
                              ]).call,
                              decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(3),
                              hintText: 'Taxes', 
                              labelText: 'Taxes', 
                              errorStyle: TextStyle(fontSize: 10.0), 
                              border: OutlineInputBorder( 
                                borderSide: BorderSide(color: Colors.red), 
                                borderRadius: 
                                  BorderRadius.all(
                                    Radius.circular(9.0)
                                  )
                                ), 
                              ), 
                            ),
                          ),
                        ]
                      )
                      :
                      //Display taxes of checked items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          
                          if (_items.size != 0 && _items.numChecked != 0 && _items.total != 0) ...[
                            IconButton(
                              icon: const Icon(
                                Icons.edit
                              ),
                              onPressed: () {
                                setState(() {
                                  _editTax = true;
                                });
                              }
                            )
                          ],
                          //Taxes of items
                          Text(
                            "Taxes: \$${(_items.total * _taxPercent).toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ]
                      ),
                      
                      //Buttom row to add and total
                      Row(
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
                                _items.addCheckbox(CheckboxWidget(0,"Item"));
                              });
                            },
                          ),

                          //Display total of checked items
                          Text(
                            "Total: \$${(_items.total + _items.total*_taxPercent).toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.headlineMedium, 
                          ),
                        ],
                      ),

                      //Button to save picture
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 159, 157, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Icon(
                              Icons.save_alt,
                              size: 40,
                            ),
                            onPressed: () {
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ),
                    ]
                  ), 
                ),
              ]
          ),
      ),
    );
  }
}