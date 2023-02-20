import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendDataFirebase extends StatefulWidget {
  const SendDataFirebase({Key? key}) : super(key: key);

  @override
  State<SendDataFirebase> createState() => _SendDataFirebaseState();
}

class _SendDataFirebaseState extends State<SendDataFirebase> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController numberController = TextEditingController();

 final CollectionReference users = FirebaseFirestore.instance.collection('users');
  // final CollectionReference users =  Firestore.instance.collection('profileInfo');
  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchDatabaseList();
  }
  List userProfilesList = [];
  String userID = "";

  String name = "";

  fetchUserInfo() async {
    dynamic getUser = FirebaseAuth.instance.currentUser;
    userID = getUser!.uid;
  }

  fetchDatabaseList() async {
    dynamic resultant = await getUsersList();

    if (resultant == null) {
      log('Unable to retrieve');
    } else {
      setState(() {
        userProfilesList = resultant;
      });
    }
  }

  sortByDate() async {
    dynamic resultants = await getDateBy();

    if (resultants == null) {
      log('Unable to retrieve');
    } else {
      setState(() {
        userProfilesList = resultants;
      });
    }
  }



  Future<void> sendData ()async {
    return users.add({
      'age':ageController.text,
      'name':nameController.text.toString(),
      'number':numberController.text
    })
    .then((value) => log('added Successfully'))
    .catchError((error)=> log('add failed $error'));
  }
  Future getDateBy() async {
    List  getDateBy = [];
    try {
      await  FirebaseFirestore.instance
          .collection('users')
          .orderBy('date', descending: false )
          .get().then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          getDateBy.add(element.data());
        }
        log(' itemList : ${ getDateBy.length.toString()}');
      });
      return getDateBy;
    } catch (e) {
      log(e.toString());
      return null;
    }


  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      await users.get().then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          itemsList.add(element.data());
        }
        log(' itemList : ${ itemsList.length.toString()}');
      });
      return itemsList;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration:const  InputDecoration(
                    hintText: 'Enter your name'
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration:const  InputDecoration(
                      hintText: 'Enter your age'
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration:const  InputDecoration(
                      hintText: 'Enter your number'
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(onPressed:()async{

                  // Update'''->

                  // FirebaseFirestore.instance
                  //     .collection('users')
                  //     .get()
                  //     .then(
                  //       (value) => value.docs.forEach(
                  //         (element) {
                  //       var docRef = FirebaseFirestore.instance
                  //           .collection('users')
                  //           .doc(element.id);
                  //
                  //       docRef.update({'date': DateTime.now()});
                  //     },
                  //   ),
                  // );
                 await sendData();
                  await fetchDatabaseList();
                  setState((){});
                  ageController.clear();
                  nameController.clear();
                  numberController.clear();
                  } , child:const  Text('Submit')),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value){
                          setState((){
                            name=value;
                          });
                        },
                        decoration:const  InputDecoration(
                            hintText: 'search',
                          prefixIcon: Icon(Icons.search)

                        ),
                      ),
                    ),
                    ElevatedButton(onPressed:()async{
                      sortByDate();

                    } , child:const  Text('Short by date')),
                  ],
                ),
              SizedBox(
                height: 500,
                child: ListView.builder(
                    itemCount: userProfilesList.length,
                    itemBuilder: (context, index) {
                      if (name.isEmpty){
                        return Card(
                          child: ListTile(
                            title: Text(userProfilesList[index]['name'].toString()),
                            subtitle: Text(userProfilesList[index]['age'].toString()),
                            trailing: Text('${userProfilesList[index]['number'].toString()}'),
                          ),
                        );
                      }
    if (userProfilesList[index]['name'].toString()
        .toString()
        .toLowerCase()
        .startsWith(name.toLowerCase())) {
      return Card(
        child: ListTile(
          title: Text(userProfilesList[index]['name'].toString()),
          subtitle: Text(userProfilesList[index]['age'].toString()),
          trailing: Text('${userProfilesList[index]['number'].toString()}'),
        ),
      );
    }
                      if (userProfilesList[index]['age'].toString()
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return Card(
                          child: ListTile(
                            title: Text(userProfilesList[index]['name'].toString()),
                            subtitle: Text(userProfilesList[index]['age'].toString()),
                            trailing: Text('${userProfilesList[index]['number'].toString()}'),
                          ),
                        );
                      }
                      if (userProfilesList[index]['number'].toString()
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return Card(
                          child: ListTile(
                            title: Text(userProfilesList[index]['name'].toString()),
                            subtitle: Text(userProfilesList[index]['age'].toString()),
                            trailing: Text('${userProfilesList[index]['number'].toString()}'),
                          ),
                        );
                      }
    return Container();

                    }),
              )]

            ),
          ),
        ),
      ),
    );
  }

}
