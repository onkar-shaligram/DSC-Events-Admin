import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditEvent extends StatefulWidget {
  DocumentSnapshot docToEdit;

  EditEvent({this.docToEdit});

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
    TextEditingController urlTextEditingController =
        TextEditingController(text: widget.docToEdit.data()['urlToEvent']);
    TextEditingController timeTextEditingController =
        TextEditingController(text: widget.docToEdit.data()['time']);
      TextEditingController priorityTextEditingController =
        TextEditingController(text: widget.docToEdit.data()['priority']);

    // print(titleTextEditingController);
    // print(descriptionTextEditingController);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () {
              widget.docToEdit.reference
                  .delete()
                  .whenComplete(() => Navigator.pop(context));
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.docToEdit.reference.update({
            'title': titleTextEditingController.text,
            'description': descriptionTextEditingController.text,
            'urlToEvent': urlTextEditingController.text,
            'time': timeTextEditingController.text,
            "priority": priorityTextEditingController.text
          }).whenComplete(() => Navigator.pop(context));
        },
        child: Icon(Icons.save),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  controller: titleTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Enter title", labelText: 'Title'),
                  maxLines: 2,
                ),
                TextField(
                  controller: descriptionTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Enter description",
                    labelText: 'Description',
                  ),
                  maxLines: 4,
                ),
                TextField(
                  controller: urlTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Enter URL to event", labelText: 'Event URL'),
                  maxLines: 2,
                ),
                TextField(
                  controller: timeTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Enter time", labelText: 'Time of Event'),
                  maxLines: 2,
                ),
                TextField(
                  controller: priorityTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Enter Priority Number", labelText: 'Priority Level'),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
