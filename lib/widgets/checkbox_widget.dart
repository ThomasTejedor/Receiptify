import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../pages/checkbox_screen.dart';

class PassData {
  PassData(this.userPicture, this.items);
  File? userPicture;
  List<CheckboxWidget>? items;
}

class CheckboxList {

  CheckboxList(this.items) {
    size = items.length;
  }

  List<CheckboxWidget> items;
  double total = 0.0;
  late int size;
  int numChecked = 0;
  CheckboxWidget? idEditing;
  //Adds checkbox to the end of the list
  void addCheckbox(CheckboxWidget value) {
    items.add(value);
    size++;
  }
  
  CheckboxWidget getCheckbox(int index) {
    return items[index];
  }
  //removes the checkbox given
  void removeCheckbox(CheckboxWidget widget) {
    print(widget.checked);
    if(widget.checked) {
      numChecked--;
    }
    items.remove(widget);
    size--;
  }

}

//Widget for the 
class CheckboxWidget {

  double amount;
  String description;
  bool checked = false;
  bool editMode = false;

  CheckboxWidget (
    this.amount,
    this.description,
  );

  Widget getCheckboxWidget(State<CheckboxPage> state, CheckboxList list, GlobalKey<FormState> _formkey) {
    
    final _itemText = TextEditingController(text: description);
    final _priceText = TextEditingController(text: amount.toStringAsFixed(2));
    final _itemTextState = ObjectKey(TextFormField);
    final _priceState = ObjectKey(TextFormField);

    return InkWell(
      onTap: () {
        editMode
          //nothing happens if you are in edit mode
          ? ()
          : state.setState(() {
            checked = !checked;
            if(checked) {
              list.total += amount;
            } else {
              list.total -= amount; 
            }
          });
      },
      child: Padding (
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Left side of clickable row
            editMode 
            ? Row(children: [
              
              //Edit Item Form
              SizedBox(
                height: 40,
                width: 150,
                child: TextFormField (
                  textAlignVertical: TextAlignVertical.center,
                  validator: MultiValidator([
                    RequiredValidator( 
                      errorText: 'Please enter an item'), 
                    MaxLengthValidator(20,
                      errorText:
                        'Username cannot be longer than 16 digits'), 
                  ]).call,
                  key: _itemTextState,
                  controller: _itemText,
                  decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(3),
                  hintText: 'Item', 
                  labelText: 'Item', 
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

              //Add Changes
              IconButton(
                icon: const Icon(
                  Icons.check
                ),
                onPressed: () {
                  if(_formkey.currentState!.validate()){
                    state.setState(() {
                      editMode = false;
                      description = _itemText.text;
                      double oldAmt = amount;
                      amount = double.parse(_priceText.text);
                      amount = double.parse(amount.toStringAsFixed(2));
                      if(checked) {
                        list.total -= oldAmt;
                        list.total += amount;
                      } 
                    });
                  }
                }
              ),
              
              //Remove changes
              IconButton(
                icon: const Icon(
                  Icons.remove
                ),
                onPressed: () {
                  state.setState(() {
                    editMode = false;
                  });
                }
              ),
            ])

            : Row(children: [
              
              //Item name
              Text(description),

              //Edit button
              IconButton(
                icon: const Icon(
                  Icons.edit
                ),
                onPressed: () {
                  state.setState(() {
                    if(list.idEditing != null) {
                      list.idEditing!.editMode = false;
                    }
                    list.idEditing = this;
                    editMode = true;
                  });
                }
              ),
            ]),
            
            //Right side of clickable row
            editMode
            //Edit mode
            ? Row( 
              children: [ 
                
                //Delete button
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline_outlined
                  ),
                  onPressed: () {
                    state.setState(() {
                      if(checked) {
                        list.total -= amount;
                      }
                      list.removeCheckbox(this);
                    });
                  }
                ),
                
                //Edit Price of item
                SizedBox(
                  height: 40,
                  width: 80,
                  child: TextFormField (
                    textAlignVertical: TextAlignVertical.center,
                    key: _priceState,
                    controller: _priceText,
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
                      hintText: 'Item', 
                      labelText: 'Item', 
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
            : Row(
              children: [ 
                
                //Include Item or not
                Checkbox(
                  value: checked,
                  onChanged: (newValue) {
                    state.setState(() {
                      checked = !checked;
                      if(checked) {
                        list.numChecked++;
                        list.total += amount;
                      } else {
                        list.numChecked--;
                        list.total -= amount; 
                      }
                    });
                  },
                ),

                //Price of item
                Text(
                  "\$${amount.toStringAsFixed(2)}"
                ),

              ]
            )
          ],
        )
      ),
    );
  }
}