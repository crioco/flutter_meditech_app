import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({ Key? key }) : super(key: key);

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async{
    super.reassemble();
    if(Platform.isAndroid){
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQRView(context)
        ],
      ),
      
    );
  }
  Widget buildQRView(BuildContext context){
  return QRView(
    key: qrKey,
    onQRViewCreated: onQRViewCreated,
    overlay: QrScannerOverlayShape(
      cutOutSize: MediaQuery.of(context).size.width * 0.8,
      borderWidth: 10,
      borderColor: Colors.blueAccent,
    ),
  );
  }
  
  void onQRViewCreated(QRViewController controller){
    setState(()=> this.controller = controller);
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        if(barcode.code != null){
          this.barcode = barcode;
          controller.pauseCamera();
          Provider.of<DataProvider>(context, listen: false).changeQRResult(barcode.code.toString());
          Navigator.pop(context);
          // Navigator.pushNamedAndRemoveUntil(
          // context, AccountScreenRoute, (Route<dynamic> route) => false);
        }  
      });
    });
  }
}
