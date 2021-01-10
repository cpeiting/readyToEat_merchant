import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EstimatedTimeDialog extends StatefulWidget {
  final Function(int) onDoneListener;

  EstimatedTimeDialog({this.onDoneListener});

  @override
  _EstimatedTimeDialogState createState() => _EstimatedTimeDialogState();
}

class _EstimatedTimeDialogState extends State<EstimatedTimeDialog> {
  int _estimatedDeliveryTimeInMinute = 10;
  DateTime currentTime;

  @override
  void initState() {
    currentTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 16,
      child: Container(
        height: 200.0,
        width: 360.0,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: Text(
                "Estimated Time of Delivery",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                  'Deliver in ${DateFormat('hh:mm a').format(currentTime.add(Duration(minutes: _estimatedDeliveryTimeInMinute)))} '),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: _estimatedDeliveryTimeInMinute > 0
                      ? () {
                          setState(() {
                            _estimatedDeliveryTimeInMinute -= 5;
                          });
                        }
                      : null,
                  child: Icon(Icons.remove),
                ),
                Text('$_estimatedDeliveryTimeInMinute minutes'),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _estimatedDeliveryTimeInMinute += 5;
                    });
                  },
                  child: Icon(Icons.add),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.red,
                  child: Text('Cancel',style: TextStyle(color: Colors.white70),),
                ),

                Container(
                  width: 20,
                ),

                FlatButton(
                  onPressed: () {
                    widget.onDoneListener(_estimatedDeliveryTimeInMinute);
                    Navigator.of(context).pop();
                  },
                  color: Colors.green,
                  child: Text('Send',style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
