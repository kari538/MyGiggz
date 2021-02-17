import 'package:my_giggz/my_types_and_functions.dart';
import 'package:my_giggz/firebase_labels.dart';
import 'package:my_giggz/my_firebase.dart';
import 'package:flutter/material.dart';

//Since there will be a stream of bids, it should be Stateful!
class GiggScreen extends StatefulWidget {
  const GiggScreen({
    @required this.preview,
    @required this.giggData,
    @required this.gigId,
  });

  final bool preview;
  final String gigId;
  final Map<String, dynamic> giggData;

  @override
  _GiggScreenState createState() => _GiggScreenState(preview, giggData, gigId);
}

class _GiggScreenState extends State<GiggScreen> {
  _GiggScreenState(this.preview, this.giggData, this.docId);

  bool preview;
  final String docId;
  final Map<String, dynamic> giggData;

  @override
  Widget build(BuildContext context) {
    michaelTracker('${this.runtimeType}');
    return Scaffold(
      appBar: AppBar(title: Text('Preview Gigg Ad')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GiggTitleText('${giggData[kFieldTitle]}'),
                GiggSubTitleText('Venue: ${giggData[kFieldLocation]}'),
                // GiggSubTitleText('Date: ${giggData[kFieldDate].toDate().day}/${giggData[kFieldDate].toDate().month}/${giggData[kFieldDate].toDate().year}'),
                GiggSubTitleText('Time: ${formatTimestamp(giggData[kFieldDate])}'),
                // GiggSubTitleText('Time: ${giggData[kFieldDate].toDate().hour}:${giggData[kFieldDate].toDate().minute}'),
                GiggBodyText('Pay: ${giggData[kFieldMinPay]} - ${giggData[kFieldMaxPay]} Ksh'),
                SizedBox(height: 20),
                GiggBodyText('${giggData[kFieldDescription]}'),
                SizedBox(height: 20),
                preview ? RaisedButton(
                  child: Text('Publish'),
                  onPressed: () {
                    MyFirebase.storeObject.collection(kCollectionGiggz).doc(docId).update({
                      '$kFieldPublished': true
                    });
                    setState(() {
                      preview = false;
                    });
                  },
                ) : SizedBox(),
                preview ? RaisedButton(
                  child: Text('Keep editing'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ) : SizedBox(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.deepPurple.shade100,
    );
  }
}

class GiggBodyText extends StatelessWidget {
  const GiggBodyText(this.text);

  final String text;

  final TextStyle style = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style);
  }
}

class GiggTitleText extends StatelessWidget {
  const GiggTitleText(this.text);

  final String text;
  final TextStyle style = const TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Pacifico');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(text, style: style),
    );
  }
}

class GiggSubTitleText extends StatelessWidget {
  const GiggSubTitleText(this.text);

  final String text;

  final TextStyle style = const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Source Sans Pro');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
      child: Text(text, style: style),
    );
  }
}
