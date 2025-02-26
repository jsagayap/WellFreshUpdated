import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wellfreshlogin/doctorSchedule.dart';
import 'navigation_drawer_widget.dart';
import 'login.dart';
import 'package:flutter/services.dart';

class Doctor extends StatefulWidget {
  const Doctor({Key? key}) : super(key: key);

  @override
  State<Doctor> createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey, // Add a Scaffold key
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!
                  .openDrawer(); // Use Scaffold key to open drawer
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Add functionality to show notifications
              },
              icon: const Icon(
                Icons.notifications,
              ),
            ),
            IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(
                Icons.logout,
              ),
            )
          ],
        ),
        drawer: NavigationDrawerWidget(),
        body: Container(
          color: Colors.white70,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: FutureBuilder(
                  future: usersCollection
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                      String docID = snapshot.data!.id;

                      String firstname = data.containsKey('firstname')
                          ? data['firstname']
                          : '';
                      String lastname =
                      data.containsKey('lastname') ? data['lastname'] : '';

                      return Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(25.0, 30.0, 12.0, 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Hi, Dr. $firstname $lastname',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                          padding:
                          const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  CircularProgressIndicator();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorSchedule(docId: docID,),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_month_outlined, color: Colors.black),
                                    SizedBox(width: 10),
                                    Text(
                                      "Schedules",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  CircularProgressIndicator();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.people_alt_rounded, color: Colors.black),
                                    SizedBox(width: 10),
                                    Text(
                                      "Patients",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ],
                          ),)

                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error fetching data'),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(25.0, 20.0, 12.0,
                        20.0), // add padding to top, left, and right
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Upcoming Appointments',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25.0, 20.0, 12.0,
                        20.0), // add padding to top, left, and right
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your logic for the button here
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ));
  }

  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
