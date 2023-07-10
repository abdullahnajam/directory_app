import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../api/database_api.dart';

class QRWidget extends StatefulWidget {
  String qrCode;

  QRWidget({required this.qrCode});

  @override
  State<QRWidget> createState() => _QRWidgetState();
}

class _QRWidgetState extends State<QRWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<String>(
          future: DBApi.getWebDomain(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                alignment: Alignment.center,
                child: CupertinoActivityIndicator(),
              );
            }
            else {
              if (snapshot.hasError) {
                print("error ${snapshot.error}");
                return Container(
                  child: Center(
                    child: Text("something went wrong"),
                  ),
                );
              }



              else {
                return QrImageView(
                  data: '${snapshot.data!}/${widget.qrCode}',
                  version: QrVersions.auto,
                  size: 100.0,
                );


              }
            }
          }
      ),
    );
  }
}
