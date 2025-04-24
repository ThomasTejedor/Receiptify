import 'package:flutter/material.dart';

import '../pages/checkbox_screen.dart';

class CheckboxList {

  CheckboxList();

  final List<CheckboxWidget> _items = [CheckboxWidget(1.538, "hello"),CheckboxWidget(2, "test"),CheckboxWidget(3, "hello1"),CheckboxWidget(1, "test1"),CheckboxWidget(1, "hello2"),CheckboxWidget(0, "test2"),CheckboxWidget(0, "hello3"),CheckboxWidget(0, "test3"),CheckboxWidget(0, "hello"),CheckboxWidget(0, "test"),CheckboxWidget(0, "hello"),CheckboxWidget(0, "test")];
  double total = 0.0;
  int size = 12; 
  //Adds checkbox to the end of the list
  void addCheckbox(CheckboxWidget value) {
    _items.add(value);
    size++;
  }

  //returns the checkbox at index
  CheckboxWidget getCheckbox(int index) {
    return _items[index];
  }
  
  //removes the checkbox given
  void removeCheckbox(CheckboxWidget widget) {
    _items.remove(widget);
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

  Widget getCheckboxWidget(State<CheckboxPage> state, CheckboxList list) {
    
    final _itemText = TextEditingController(text: description);
    final _priceText = TextEditingController(text: amount.toStringAsFixed(2));
    final _itemTextState = ObjectKey(TextFormField);
    final _priceState = ObjectKey(TextFormField);

    return InkWell(
      onTap: () {
        editMode
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
                      list.total -= amount;
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
                        list.total += amount;
                      } else {
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