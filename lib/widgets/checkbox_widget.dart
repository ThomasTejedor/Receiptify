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
    
    final _itemText = TextEditingController();
    final _priceText = TextEditingController();

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


              //Add Changes
              IconButton(
                icon: const Icon(
                  Icons.check
                ),
                onPressed: () {
                  state.setState(() {
                    editMode = false;
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
            Row(
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