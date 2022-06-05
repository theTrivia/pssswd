import 'package:flutter/material.dart';

import '../components/deletePasswordEntry.dart';
import '../components/editEntry.dart';

class EditEntryPage extends StatefulWidget {
  final String password;
  final String name;
  final String entry_id;
  final String username;
  final String url;

  EditEntryPage(
    this.name,
    this.username,
    this.password,
    this.url,
    this.entry_id,
  );

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  @override
  final newPasswordController = TextEditingController();

  var _isPasswordVisible = false;

  TextEditingController get newNameController =>
      TextEditingController(text: widget.name);

  var newPasswordValue = '';
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // print(widget.password);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password'),
      ),
      body: ListView(
        children: [
          Form(
            child: Column(children: [
              // Padding(
              //   padding: const EdgeInsets.only(
              //       top: 20, right: 10, left: 10, bottom: 20),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.grey,
              //       border: Border.all(
              //         color: Colors.grey,
              //       ),
              //       borderRadius: BorderRadius.all(Radius.circular(20)),
              //     ),
              //     // color: Colors.grey,
              //     width: double.infinity,
              //     height: mediaQuery.size.height * 0.07,
              //     child: Center(
              //       child: Text(
              //         (widget.name.length > 10
              //             ? '${widget.name.substring(0, 7)}...'
              //             : widget.name),
              //         style: TextStyle(
              //           fontSize: 30,
              //           fontWeight: FontWeight.bold,
              //         ),
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 15),
                  //   child: Text(
                  //     'Current Password',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 17,
                  //     ),
                  //   ),
                  // ),
                  // Row(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 15, right: 15),
                  //       child: Container(
                  //         width: mediaQuery.size.width * 0.6,
                  //         height: mediaQuery.size.height * 0.06,
                  //         decoration: BoxDecoration(
                  //           color: Colors.grey,
                  //           border: Border.all(
                  //             color: Colors.grey,
                  //           ),
                  //           borderRadius: BorderRadius.all(Radius.circular(5)),
                  //         ),
                  //         child: Center(
                  //           child: Text(
                  //             _isPasswordVisible
                  //                 ? '${widget.password}'
                  //                 : '********',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 17,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     IconButton(
                  //         onPressed: () {
                  //           Clipboard.setData(
                  //             ClipboardData(text: widget.password),
                  //           );
                  //           Fluttertoast.showToast(
                  //             msg: 'pssswd copied!',
                  //             gravity: ToastGravity.CENTER,
                  //           );
                  //         },
                  //         icon: Icon(Icons.copy)),
                  //     IconButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             if (_isPasswordVisible) {
                  //               _isPasswordVisible = false;
                  //             } else {
                  //               _isPasswordVisible = true;
                  //             }
                  //           });
                  //         },
                  //         icon: Icon(Icons.remove_red_eye))
                  //   ],
                  // ),
                ],
              ),
              Form(
                child: Column(
                  children: [
                    EditEntry(
                      widget.entry_id,
                      widget.name,
                      widget.username,
                      widget.password,
                      widget.url,
                    ),
                  ],
                ),
              ),
              DeletePasswordEntry(widget.entry_id),
            ]),
          ),
        ],
      ),
    );
  }
}
