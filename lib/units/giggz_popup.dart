import 'package:my_giggz/my_types_and_functions.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GiggzPopup extends Alert {
  GiggzPopup({
    @required this.context,
    @required this.title,
    @required this.desc,
    this.buttons,
  }){
    buttons = buttons ?? [
      DialogButton(
        child: Text('OK', style: TextStyle(color: Colors.black)),
        onPressed: (){Navigator.pop(context);},
        color: Colors.white,
      )
    ];
  }

  String title;
  String desc;
  BuildContext context;
  List<DialogButton> buttons;

  AlertStyle style = AlertStyle(
    buttonsDirection: ButtonsDirection.column,
    isOverlayTapDismiss: false,
    backgroundColor: Color(0xff7488c1),
    // backgroundColor: Colors.pink,
    overlayColor: Colors.black45,
    // isCloseButton: true,
  );
}

class FirebaseErrorPopup extends GiggzPopup {
  FirebaseErrorPopup({@required this.context, @required this.e}) {
    code = e.code;
    formattedCode = code.replaceAll('-', ' ');
    title = '${capitalizeFirst(formattedCode)}!';
    desc = '${e.message}';
  }

  BuildContext context;
  var e;
  String code;
  String formattedCode;
  String title;
  String desc;
}

class GiggzPopupButton extends StatelessWidget {
  const GiggzPopupButton({
    @required this.text,
    @required this.onPressed,
  });

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return DialogButton(
      child: Text('$text', style: TextStyle(color: Colors.black)),
      color: Colors.white,
      onPressed: onPressed,
    );
  }
}
