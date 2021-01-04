import 'package:my_giggz/constants.dart';
import 'package:my_giggz/units/giggz_popup.dart';
import 'package:my_giggz/my_types_and_functions.dart';
import 'package:flutter/material.dart';

class SearchCriteriaScreen extends StatefulWidget {

  @override
  _SearchCriteriaScreenState createState() => _SearchCriteriaScreenState();
}

class _SearchCriteriaScreenState extends State<SearchCriteriaScreen> {
  // String dropdownValue = 'none';
  UserType dropdownValue;
  String name;
  String email;
  String location;
  Map<String, dynamic> criteria = {
    critName: null,
    critEmail: null,
    critLocation: null,
    critUserType: null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("This ain't Google... Plz be patient! The search function will improve with time.",
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      hintText: 'Search by name',
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.search),
                        onTap: (){
                          criteria[critName] = name;
                          Navigator.pop(context, criteria);
                        },
                      ),
                      filled: true,
                    ),
                    onChanged: (value){
                      name=value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by email',
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.search),
                        onTap: (){
                          criteria[critEmail] = email;
                          Navigator.pop(context, criteria);
                        },
                      ),
                      filled: true,
                    ),
                    onChanged: (value){
                      email=value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by location',
                      suffixIcon: Icon(Icons.search),
                      filled: true,
                    ),
                    // enabled: false,
                    onTap: (){
                      GiggzPopup(context: context, title: 'Notice', desc: 'This function will be available soon.').show();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('User type:  ', style: TextStyle(color: Theme.of(context).hintColor)),
                    DropdownButton(
                      // hint: Text('User type'),
                      value: dropdownValue,
                      items: [
                        DropdownMenuItem(child: Text('(none)', style: TextStyle(color: Theme.of(context).hintColor)), value: null),
                        DropdownMenuItem(child: Text('Artists'), value: UserType.artist),
                        DropdownMenuItem(child: Text('Clients'), value: UserType.artistHirer),
                        DropdownMenuItem(child: Text('Artist Services'), value: UserType.artistServices),
                      ],
                      onChanged: (value){
                        setState(() {
                          dropdownValue = value;
                        });
                        criteria[critUserType] = value;
                        Navigator.pop(context, criteria);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
