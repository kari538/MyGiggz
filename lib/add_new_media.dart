import 'package:flutter/material.dart';
import 'package:my_giggz/firebase_labels.dart';

String _mediaType;

Future<void> addNewMedia({@required BuildContext context, @required Map<String, dynamic> newSocialMediaMap, @required Function setParentState}) async {
  String _mediaName = '';
  String _mediaLink = '';
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      side: BorderSide(color: Theme.of(context).accentColor),
    ),
    // shape: Border(
    //   left: BorderSide(color: Theme.of(context).accentColor),
    //   top: BorderSide(color: Theme.of(context).accentColor),
    //   right: BorderSide(color: Theme.of(context).accentColor),
    // ),
    builder: (context) {
      Color titleColor = Colors.tealAccent;
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 30, top: 30, right: 30, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add Media' , style: TextStyle(color: titleColor, fontSize: 30), textAlign: TextAlign.center),
              Row(
                children: [
                  Text('Media Category:   '),
                  MediaTypeMenu(),
                ],
              ),
              TextField(
                onChanged: (value) {
                  _mediaName = value;
                  // print('Value no $thisMedia');
                },
                // autofocus: true,
                decoration: InputDecoration(
                  hintText: 'media name',
                  labelText: 'Give your media a name (optional):',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                // controller: nameControllers[mediaName],
                // controller: nameControllers[thisMedia],
              ),
              TextField(
                onChanged: (value) {
                  _mediaLink = value;
                },
                decoration: InputDecoration(
                  hintText: 'link address',
                  labelText: 'Enter a link address (URL) to your media:',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                minLines: 1,
                maxLines: 3,
                // controller: linkControllers[mediaName],
                // controller: linkControllers[mediaCount],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child: Text('Cancel', style: TextStyle(inherit: true)),
                    onPressed: () {
                      _mediaType = null;
                      Navigator.pop(context);
                      setParentState();
                    },
                    textColor: Colors.black,
                    color: Colors.pink.shade100,
                  ),
                  RaisedButton(
                    child: Text('Add', style: TextStyle(inherit: true)),
                    //Button only active
                    onPressed: /*_mediaType != '' && _mediaLink != '' ?*/ () {
                      //If the key is not already there, add it:
                      if(! newSocialMediaMap.containsKey(_mediaType)){
                        newSocialMediaMap.addAll({_mediaType : {}});
                      }
                      //Then add the new media:
                      newSocialMediaMap[_mediaType].addAll({
                        //If Media Name is provided, use that, otherwise use URL as name:
                        (_mediaName != '' ? _mediaName : _mediaLink) : _mediaLink
                      });
                      print('newSocialMediaMap is $newSocialMediaMap in bottonSheet\n***********************************');
                      _mediaType = null;
                      Navigator.pop(context);
                      setParentState();
                    } /*: null*/,
                    textColor: Colors.white,
                    color: Colors.pink,
                  ),
                ],
              ),
              SizedBox(height: 300),
            ],
          ),
        ),
      );
    },
    isScrollControlled: true,
  );
}

class MediaTypeMenu extends StatefulWidget {

  @override
  _MediaTypeMenuState createState() => _MediaTypeMenuState();
}

class _MediaTypeMenuState extends State<MediaTypeMenu> {

  @override
  void dispose() {
    super.dispose();
    _mediaType = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton(
          value: _mediaType,
          // hint: Text('$mediaType'),
          items: [
            DropdownMenuItem(child: Text('Facebook'), value: kSubFieldFacebook),
            DropdownMenuItem(child: Text('YouTube'), value: kSubFieldYouTube),
            DropdownMenuItem(child: Text('Instagram'), value: kSubFieldInstagram),
            DropdownMenuItem(child: Text('Blog'), value: kSubFieldBlog),
            DropdownMenuItem(child: Text('Twitter'), value: kSubFieldTwitter),
            DropdownMenuItem(child: Text('Website'), value: kSubFieldWebsite),
            DropdownMenuItem(child: Text('Other'), value: 'Other'),
          ],
          onChanged: (value){
            setState(() {
              _mediaType = value;
            });
            // setParentState();
          },
        ),
        _mediaType == 'Other' ? SizedBox(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'media type',
              labelText: 'Specify:',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (value){
              _mediaType = value;
            },
            autofocus: true,
          ),
          width: MediaQuery.of(context).size.width/3,
        ) : SizedBox(),
      ],
    );
  }
}