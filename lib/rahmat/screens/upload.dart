import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scrapyart_home/rahmat/screens/gudangku.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  PlatformFile? pickedFile;
  String? imageUrl;
  String? thumbnailUrl;

  Future<String?> uploadFile(File file) async {
    try {
      String fileName = file.path.split('/').last;
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      TaskSnapshot uploadTask = await storageReference.putFile(file);
      if (uploadTask.state == TaskState.success) {
        thumbnailUrl = await storageReference.getDownloadURL();
        print('Thumbnail URL: $thumbnailUrl');
        return thumbnailUrl;
      } else {
        print('Upload failed');
        return null;
      }
    } on FirebaseException catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String? uploadImageUrl = await uploadFile(file);
      if (uploadImageUrl != null && uploadImageUrl.isNotEmpty) {
        setState(() {
          imageUrl = uploadImageUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pickedFile != null)
              Expanded(
                child: Container(
                  color: Colors.blue[100],
                  child: imageUrl != null
                      ? Image.network(imageUrl!)
                      : Placeholder(),
                  width: double.infinity,
                ),
              ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: selectFile,
              child: const Text('Select File'),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => addDetails(context),
              child: const Text('Details'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      // Ganti dengan kelas yang sesuai jika ini bukan kelas ForgotPasswordPage
                      return GudangkuScreen();
                    },
                  ),
                );
              },
              child: const Text('Forgot Password'),
            ),
          ],
        ),
      ),
    );
  }

  void addDetails(BuildContext context) async {
    if (thumbnailUrl != null) {
      try {
        await FirebaseFirestore.instance.collection('videoDetails').add({
          'thumbnailUrl': thumbnailUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print('Upload berhasil');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const GudangkuScreen()));
      } on FirebaseException catch (e) {
        print("Error $e");
      }
    } else {
      print('Thumbnail URL is empty. Please upload a file first.');
    }
  }
}
