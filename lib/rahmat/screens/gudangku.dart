import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapyart_home/rahmat/screens/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GudangkuScreen extends StatefulWidget {
  const GudangkuScreen({Key? key}) : super(key: key);

  @override
  State<GudangkuScreen> createState() => _GudangkuScreenState();
}

class _GudangkuScreenState extends State<GudangkuScreen> {
  // ignore: unused_field
  Uint8List? _image;

  Future<void> selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  final firestoreService = FirestoreService();

  final userCollection = FirebaseFirestore.instance.collection("users");

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gudangku", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Map<String, dynamic> userData =
                (snapshot.data!.data() as Map<String, dynamic>?) ?? {};

            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 38,
                          backgroundImage: AssetImage('lib/assets/scrap.jpeg'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onDoubleTap: () => editField('username'),
                            child: Text(
                              '${userData['username']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'Email: ${currentUser?.email}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => editField('username'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 212, 19),
                              minimumSize: const Size(10, 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  fontStyle: FontStyle.normal),
                            ),
                            child: const Text('Edit Profile'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: Color.fromARGB(43, 3, 3, 3),
                    thickness: 1,
                    indent: 10,
                    endIndent: 0,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('videoDetails')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<QueryDocumentSnapshot> documents =
                              snapshot.data!.docs;

                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // Number of columns
                                childAspectRatio: 0.8, // Aspect ratio
                              ),
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic>? data = documents[index]
                                    .data() as Map<String, dynamic>?;
                                String thumbnailUrl =
                                    data?['thumbnailUrl'] ?? '';

                                return GestureDetector(
                                  onLongPress: () {
                                    // Show the context menu when long-pressed
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoContextMenu(
                                          actions: <Widget>[
                                            CupertinoContextMenuAction(
                                              onPressed: () {
                                                firestoreService.deleteImage(
                                                    documents[index].id);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return const GudangkuScreen();
                                                    },
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                          child: Image.network(thumbnailUrl),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Image.network(
                                      thumbnailUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(child: Text('No data available'));
                        }
                      },
                    ),
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      label: Text("Log Out",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        logout();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.logout,
                          color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Center(child: Text('No user data available'));
          }
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(items: [
      //   BottomNavigationBarItem(
      //     icon: IconButton(
      //         onPressed: () => logout(), icon: const Icon(Icons.logout)),
      //     label: 'log out',
      //   ),
      // ]),
    );
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            "Edit $field",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: TextFormField(
            autofocus: true,
            controller: TextEditingController(),
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            TextButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Save', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (newValue.trim().isNotEmpty) {
                  await userCollection
                      .doc(currentUser!.email)
                      .update({field: newValue});
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class FirestoreService {
  final videoDetails = FirebaseFirestore.instance.collection('videoDetails');

  Future<void> deleteImage(String docID) {
    return videoDetails.doc(docID).delete();
  }
}

class StoreData {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({
    required Uint8List file,
  }) async {
    String resp = "Some Error Occurred";
    try {
      String imageURL = await uploadImageToStorage('ProfileImage', file);
      await FirebaseFirestore.instance.collection('userProfile').add({
        'imageLink': imageURL,
      });
      resp = 'success';
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
