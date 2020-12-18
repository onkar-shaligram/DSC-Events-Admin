import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewEvent extends StatefulWidget {
  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {

  TextEditingController urlTextEditingController = TextEditingController();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController timeTextEditingController = TextEditingController();

  String imageUrl;

  bool isLoading = false;

  File selectedImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  addEvent() async {
    // make sure we have image
    if (selectedImage != null) {
      setState(() {
        isLoading = true;
      });
      // upload image
      FirebaseStorage storage = FirebaseStorage.instance;

      Reference storageReference = storage.ref().child("/images");

      UploadTask uploadTask = storageReference.putFile(selectedImage);

      // get download url
      await uploadTask.whenComplete(() async {
        try {
          imageUrl = await storageReference.getDownloadURL();
          print(imageUrl);
        } catch (e) {
          print(e);
        }
      });

      Map<String, dynamic> eventData = {
        "urlToEvent": urlTextEditingController.text,
        "description": descriptionTextEditingController.text,
        "title": titleTextEditingController.text,
        "imageUrl": imageUrl,
        "time": timeTextEditingController.text,
      };

      // upload to firebase
      FirebaseFirestore.instance
          .collection("events")
          .add(eventData)
          .catchError((e) {
        print("Error encountered while uploading data : $e");
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Event"),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      selectedImage == null
                          ? GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 16),
                                height: 180,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  selectedImage,
                                  height: 180,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                      TextField(
                        controller: titleTextEditingController,
                        decoration: InputDecoration(hintText: "Enter title"),
                        maxLines: 2,
                      ),
                      TextField(
                        controller: descriptionTextEditingController,
                        decoration: InputDecoration(hintText: "Enter description"),
                        maxLines: 4,
                      ),
                      TextField(
                        controller: urlTextEditingController,
                        decoration: InputDecoration(hintText: "Enter URL to event"),
                        maxLines: 2,
                      ),
                      TextField(
                        controller: timeTextEditingController,
                        decoration: InputDecoration(hintText: "Enter time"),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              addEvent();
            },
            child: Icon(
              Icons.file_upload,
            )));
  }
}