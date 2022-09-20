import 'package:flutter/material.dart';

//Colors
const Color kPrimaryAppColor = Color.fromARGB(255, 6, 206, 175); // Color.fromARGB(255, 101, 93, 251);
const Color kSecondaryAppColor = Color.fromARGB(255, 6, 176, 206);
const MaterialColor primarySwatch = Colors.blueGrey; // Colors.indigo;
const Color kWhite = Colors.white;
const Color kBlack = Colors.black;
const Color kGrey = Colors.grey;
const Color kRed = Colors.red;
const Color kOrange = Colors.orange;
const Color kBlue = Colors.blue;
const Color kGreen = Colors.green; // Colors.green;
const Color kBrown = Colors.brown;
const Color kPurple = Colors.purple;
const Color kYellow = Colors.yellow;
const Color kOutGoingMessage = Color(0xFF5B40D1);
const Color kInComingMessage = Color.fromARGB(255, 119, 236, 201); // Color.fromARGB(255, 140, 118, 234);
const Color kTransparent = Colors.transparent;

//Strings
const String kDefaultFont = 'Poppins';

//gradients
const Gradient kGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: <double>[
      0.3,
      0.4,
      0.5,
      0.6
    ],
    colors: <Color>[
      Color.fromARGB(255, 49, 253, 173), // Color.fromARGB(255, 101, 93, 251)
      Color.fromARGB(255, 84, 253, 192), // Color.fromARGB(255, 108, 101, 251)
      Color.fromARGB(255, 111, 251, 188), // Color.fromARGB(255, 118, 111, 251),
      Color.fromARGB(255, 122, 249, 192), // Color.fromARGB(255, 129, 122, 249),
    ]);

//firestore field constants
class FirestoreFieldConstants {
  final String name = "name";
  final String about = "about";
  final String role = "role";
  final String status = "status";
  final String connectionRequest = "connection_request";
  final String connections = "connections";
  final String creationDate = "creation_date";
  final String creationTime = "creation_time";
  final String phoneNumber = "phone_number";
  final String profilePic = "profile_pic";
  final String token = "token";
  final String totalConnections = "total_connections";
  final String userName = "username";
  final String call = "call";
}
