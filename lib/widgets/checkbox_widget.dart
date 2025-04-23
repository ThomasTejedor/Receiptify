import 'package:flutter/material.dart';

import '../pages/checkbox_screen.dart';

class CheckboxWidget {

  static double total = 0.0;
  double amount;
  String description;
  bool checked = false;
  bool editMode = false;

  CheckboxWidget (
    this.amount,
    this.description,
  );

  Widget getCheckboxWidget(State<CheckboxPage> state) {
    
    final _itemText = TextEditingController(text: description);
    final _priceText = TextEditingController(text: amount.toStringAsFixed(2));
    final _itemTextState = ObjectKey(TextFormField);
    final _priceState = ObjectKey(TextFormField);

    return InkWell(
      onTap: () {
        state.setState(() {
          checked = !checked;
          toggleChecked(checked!);
          print(total);
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

                  }
                ),
                
                //Include Item or not
                Checkbox(
                  value: checked,
                  onChanged: (newValue) {
                    state.setState(() {
                      toggleChecked(newValue!);
                      print(total);
                    });
                  },
                ),
                //Edit Price of item
                SizedBox(
                  height: 40,
                  width: 50,
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
                
                //Delete button
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline_outlined
                  ),
                  onPressed: () {

                  }
                ),
                
                //Include Item or not
                Checkbox(
                  value: checked,
                  onChanged: (newValue) {
                    state.setState(() {
                      toggleChecked(newValue!);
                      print(total);
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

  void updateAmount(double amount) {
    this.amount = amount;
  }

  void updateDescription(String desc) {
    description = desc;
  }

  void toggleChecked(bool checked) {
    this.checked = checked;
    if(checked){
      addTotal(amount);
    } else {
      subTotal(amount);
    }
  }
  static double getTotal(){
    return total; 
  }
  static void addTotal(double value) {
    total += value;
  }

  static void subTotal(double value) {
    total -= value;
  }

}