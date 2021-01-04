// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';

class EditPriceScreen extends StatelessWidget {
  const EditPriceScreen(this.price);
  final String price;

  @override

  Widget build(BuildContext context) {
    String newPrice;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your current pay rate is $price'),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(hintText: 'Enter new pay rate'),
                onChanged: (value){
                  newPrice = value;
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autofocus: true,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(child: Text('Cancel'), onPressed: (){
                    Navigator.pop(context);
                  }),
                  SizedBox(width: 10),
                  RaisedButton(child: Text('Update'), onPressed: (){
                    Navigator.pop(context, newPrice);
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
