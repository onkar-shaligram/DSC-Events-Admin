import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditEvent extends StatefulWidget {

  DocumentSnapshot docToEdit;

  EditEvent ({this.docToEdit});

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  @override
  Widget build(BuildContext context) {
    TextEditingController titleTextEditingController =
        TextEditingController(text: widget.docToEdit.data()['title']);
    TextEditingController descriptionTextEditingController =
        TextEditingController(text: widget.docToEdit.data()['description']);

        print(titleTextEditingController);
        print(descriptionTextEditingController);

    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () {
              widget.docToEdit.reference.update({
                'title': titleTextEditingController.text,
                'description': descriptionTextEditingController.text,
              }).whenComplete(() => Navigator.pop(context));
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
          FlatButton(
            onPressed: () {
              widget.docToEdit.reference
                  .delete()
                  .whenComplete(() => Navigator.pop(context));
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(border: Border.all()),
            child: TextField(
              controller: titleTextEditingController,
              decoration: InputDecoration(hintText: "Title"),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: descriptionTextEditingController,
                maxLines: null, //Let this be infinity
                expands: true, //let this be expanding howoever it want
                decoration: InputDecoration(hintText: "description"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}