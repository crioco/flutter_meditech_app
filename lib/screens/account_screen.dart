import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meditech_app/auth_helper.dart';
import 'package:flutter_meditech_app/functions/data_shared_preferences.dart';
import 'package:flutter_meditech_app/functions/global_functions.dart';
import 'package:flutter_meditech_app/functions/reset_data.dart';
import 'package:flutter_meditech_app/model/pill_object.dart';
import 'package:flutter_meditech_app/providers/data_provider.dart';
import 'package:flutter_meditech_app/route/routing_constants.dart';
import 'package:flutter_meditech_app/widgets/my_app_bar.dart';
import 'package:flutter_meditech_app/widgets/my_side_menu.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var deviceID = '';
  var userID = '';

  @override
  Widget build(BuildContext context) {
    var firstName = Provider.of<DataProvider>(context).firstName;
    var lastName = Provider.of<DataProvider>(context).lastName;
    deviceID = DataSharedPreferences.getDeviceID();
    userID = DataSharedPreferences.getUserID();
    User? user = AuthHelper.currentUser();
    String email = '';
    // Provider.of<DataProvider>(context).changeQRResult('NULL');

    if (user != null) {
      email = user.email!;
    }
    
    return Scaffold(
      appBar: MyAppBar(title: 'My Account'),
      drawer: const MySideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
             Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text('$firstName $lastName',
                  style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: () => showUserIDQR(context), icon: const Iconify(Ion.qr_code_sharp))
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (deviceID != 'NULL')
                      ? Column(
                        children: [
                          const Text('Device: Device Registered', style: TextStyle(fontSize: 24)),
                          const SizedBox(height: 50),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showDeleteDialog(context);
                                });
                              },
                              child: const Text('REMOVE DEVICE', style: TextStyle(fontSize: 22)),
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(250, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: Colors.redAccent))
                        ],
                      )
                      : Column(
                        children: [
                          Row(
                              children: const [
                                Text('Device: No Registed Device',
                                    style: TextStyle(fontSize: 24)),
                              ],
                            ),
                           const SizedBox(height: 50),
                           ElevatedButton(
                              onPressed: () async{
                                await Navigator.pushNamed(context, QRScanScreenRoute);
                                
                                if (Provider.of<DataProvider>(context, listen: false).qrResult != 'NULL'){
                                  setState(() async {
                                    await registerDevice();    
                                  });      
                                }        
                              },
                              child: const Text('REGISTER', style: TextStyle(fontSize: 22)),
                              style: ElevatedButton.styleFrom(
                                   fixedSize: const Size(250, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: Colors.blueAccent)),
                        ],
                      ),
                    // Text(qrResult)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showUserIDQR(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 150,
            height: 300,
            child: Center(
              child: Column(
                children: [
                  QrImage(
                    data: userID,
                    size: 250,
                    backgroundColor: Colors.white,
                  ),
                   const Text('SCAN QR CODE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              )
            ),
          ));
      },
    );
  }

  registerDevice() async{
    var scanDeviceID = Provider.of<DataProvider>(context, listen: false).qrResult;
    DocumentSnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
    .collection('DEVICES').doc(scanDeviceID).get();

    if (query.exists){
      if(query.data()!['owner'] as String == 'NULL'){
        await FirebaseFirestore.instance.collection('Users').doc(userID).update({'device': scanDeviceID}).then((value){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User Device Updated'),
          backgroundColor: Color.fromARGB(255, 74, 204, 79),
          ));
        })
        .catchError((error){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to Update User\'s Device'),
          backgroundColor: Color.fromARGB(255, 196, 69, 69),
          ));
        });
        await FirebaseFirestore.instance.collection('DEVICES').doc(scanDeviceID).update({'owner': userID}).then((value) async {
          await DataSharedPreferences.setDeviceID(deviceID);
          resetData(userID, context);
          
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Device Owner Updated'),
          backgroundColor: Color.fromARGB(255, 74, 204, 79),
          ));
        })
        .catchError((error){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to Update Device Owner'),
          backgroundColor: Color.fromARGB(255, 196, 69, 69),
          ));
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Device is Already Owned'),
          backgroundColor: Color.fromARGB(255, 196, 69, 69),
          ));
      }
    }
  }

  removeDevice() async {
    await FirebaseFirestore.instance.collection('Users').doc(userID).update({'device': 'NULL'}).then((value){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Removed User Device'),
      backgroundColor: Color.fromARGB(255, 74, 204, 79),
      ));
    })
    .catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Failed to Remove User\'s Device'),
      backgroundColor: Color.fromARGB(255, 196, 69, 69),
      ));
    });
    await FirebaseFirestore.instance.collection('DEVICES').doc('DEVICE001').update({'owner': 'NULL'}).then((value) async {
      await DataSharedPreferences.setDeviceID(deviceID);
      resetData(userID, context);
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Removed Device Owner'),
      backgroundColor: Color.fromARGB(255, 74, 204, 79),
      ));
    })
    .catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Failed to Remove Device Owner'),
      backgroundColor: Color.fromARGB(255, 196, 69, 69),
      ));
    });
  }

  void showDeleteDialog(BuildContext context){
    showDialog(context: context,  builder: (BuildContext context){
      return AlertDialog(
        insetPadding: const EdgeInsets.all(15),
        titlePadding: const EdgeInsets.all(10),
        title: Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('Remove Device?', style: TextStyle(fontSize: 20)),
            ),
            Divider(thickness: 1, height: 1)
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.blueAccent
                )
              ),
              ElevatedButton(
                onPressed: () async{
                  setState(() async {
                    await removeDevice(); 
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('DELETE'),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  primary: Colors.redAccent
                )
              ),
            ],
          ),
        ],
      );
    });
  }
}