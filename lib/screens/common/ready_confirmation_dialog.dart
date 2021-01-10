import 'package:flutter/material.dart';

class ReadyConfirmationDialog extends StatefulWidget {

  Function(int) onFinish;

  ReadyConfirmationDialog({this.onFinish});

  @override
  _ReadyConfirmationDialogState createState() => _ReadyConfirmationDialogState();
}

class _ReadyConfirmationDialogState extends State<ReadyConfirmationDialog> {

  int readyInMinutes = 15;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 16,
      child:   Container(
        height: 100,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text("Ready in"),
                ),
                new Container(
                  child: new IconButton(
                    icon: new Icon(Icons.remove),
                    highlightColor: Colors.orangeAccent,
                    onPressed: () {
                      setState(() {
                        if(readyInMinutes>15){
                          readyInMinutes -= 5;//readyInMinutes =readyInMinutes -5
                        }
                      });
                    },
                  ),
                ),

                new Text(
                  "$readyInMinutes mins",
//                                      style: Theme.of(context).textTheme.headline5,
                ),

                new Container(
                  child: new IconButton(
                      icon: new Icon(Icons.add),
                      highlightColor: Colors.green,
                      onPressed: () {
                        setState(() {
                          if(readyInMinutes<50){
                            readyInMinutes += 5;//readyInMinutes =readyInMinutes +5
                          }
                        });
                      }),
                ),
              ],
            ),

            FlatButton(
              onPressed: (){
                widget.onFinish(readyInMinutes);
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            )
          ],
        ),
      ),

    );
  }
}
