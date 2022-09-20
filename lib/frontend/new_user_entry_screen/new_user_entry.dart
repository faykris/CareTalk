import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:CareTalk/backend/firebase/online_database_management/cloud_data_management.dart';
import 'package:CareTalk/backend/sqlite_management/local_database_management.dart';
import 'package:CareTalk/frontend/main_screens/main_screen.dart';
import 'package:CareTalk/global_uses/constants.dart';
import 'package:CareTalk/global_uses/alert.dart';
import 'package:image_picker/image_picker.dart';

import '../../backend/firebase/auth/email_and_password_auth.dart';
import '../auth_screens/login.dart';

class TakePrimaryUserData extends StatefulWidget {
  const TakePrimaryUserData({Key? key}) : super(key: key);

  @override
  _TakePrimaryUserDataState createState() => _TakePrimaryUserDataState();
}

class _TakePrimaryUserDataState extends State<TakePrimaryUserData> {
  bool _isLoading = false;
  String? profilePic;
  String _roleValue = 'Person';
  final String _roleTitle = 'Select your role';
  final String _roleWarning = "NOTE: This option cannot be changed later";
  final String _perText = "Choose this option if you need help and want to talk with a specialist";
  final String _speText = "Choose this option if you are a certificated psychologist and want to help to others";
  final _roles = ['Specialist', 'Person'];

  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();

  final LocalDatabase _localDatabase = LocalDatabase();

  final TextEditingController _username =
      TextEditingController(); //input of the username field

  final TextEditingController _userAbout =
      TextEditingController(); //input of the userAbout field

  final TextEditingController _name =
      TextEditingController(); //input of the userRole field

  final GlobalKey<FormState> _userPrimaryInformationFormKey =
      GlobalKey<FormState>(); //uniquely identify the login elements


  @override
  Widget build(BuildContext context) {
     return Scaffold(
        backgroundColor: kWhite,
        body: LoadingOverlay(
     isLoading: _isLoading,
     child: Padding(
       padding: const EdgeInsets.only(top:12.0),
       child: ListView(
         shrinkWrap: true,
         children: <Widget>[
           _heading(),
           _userPrimaryInformationform(),
           _saveUserPrimaryInformation()
         ],
       ),
     ),
        ),
      );
    
  }

//heading of the user entry screen
  Widget _heading() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 30.0),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text('Almost there',
            style: TextStyle(
                color: kSecondaryAppColor,
                fontSize: 28.0,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700
            ),
        ),
        Text('Please fill in the inputs below',
            style: TextStyle(
                color: kGrey,
                fontSize: 14.0,
                letterSpacing: 1.0,
                fontStyle: FontStyle.italic)),
      ]),
    );
  }

//some common textFormField
  Widget _commonTextFormField(
      {required String hintText,
      required String labelText,
      required TextInputType textInputType,
      required String? Function(String?)? validator,
      required TextEditingController textEditingController}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
        child: TextFormField(
            keyboardType: textInputType,
            controller: textEditingController,
            validator: validator,
            style: const TextStyle(color: kBlack, letterSpacing: 1.0),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                errorStyle: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
                labelText: labelText,
                labelStyle: const TextStyle(
                    color: kBlack,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w500),
                hintText: hintText,
                hintStyle:
                    const TextStyle(color: Colors.grey, letterSpacing: 1.0),
                filled: true,
                fillColor: Colors.white38,
                enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(color: kPrimaryAppColor)),
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(color: kPrimaryAppColor)),
                errorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(color: kPrimaryAppColor)),
                focusedErrorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(color: kPrimaryAppColor)))));
  }

//new user entry form
  Widget _userPrimaryInformationform() {
    return Form(
      key: _userPrimaryInformationFormKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  final XFile? pickedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery, imageQuality: 50);
                  if (pickedImage != null) {
                    setState(() {
                      profilePic = pickedImage.path;
                    });
                  }
                },
                child: profilePic == null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: kPrimaryAppColor,
                        child: Image.asset(
                          "assets/images/add_pic.png",
                          height: 80.0,
                          width: 60.0,
                        ))
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(profilePic!)),
                      ),
              ),
            ),
          ),
          _commonTextFormField(
              hintText: 'Enter name',
              labelText: 'Name',
              textInputType: TextInputType.text,
              validator: (String? inputValue) {
                if (inputValue!.isEmpty) {
                  return 'Name can\'t be empty';
                }
                return null;
              },
              textEditingController: _name),
          _commonTextFormField(
              hintText: 'Enter username',
              labelText: 'Username',
              textInputType: TextInputType.text,
              validator: (inputUserName) {
                //Regular expression
                final RegExp _messageRegex = RegExp(r'[a-zA-Z0-9]');
                if (inputUserName!.length < 6) {
                  return 'Username must have at least 6 characters';
                } else if (inputUserName.contains(' ') ||
                    inputUserName.contains('@')) {
                  return 'space or @ not allowed';
                } else if (!_messageRegex.hasMatch(inputUserName)) {
                  return 'Emoji not supported';
                }
                return null;
              },
              textEditingController: _username),
          _commonTextFormField(
              hintText: 'Enter about',
              labelText: 'About',
              textInputType: TextInputType.text,
              validator: (String? inputValue) {
                if (inputValue!.length < 6) {
                  return 'About must be at least 6 characters';
                }
                return null;
              },
              textEditingController: _userAbout),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
            child: Column(
              children: [
                // TextButton(
                //     onPressed: () async {
                //       EmailAndPasswordAuth().logOut();
                //
                //       await Navigator.pushReplacement(
                //           context, MaterialPageRoute(builder: (_) => const LoginPage()));
                //     },
                //     child: const Text('Logout')
                // ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsetsDirectional.only(bottom: 5),
                  child: Text(
                    _roleTitle,
                    style: const TextStyle(
                      color: kSecondaryAppColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700
                    )
                  ),
                ),
                Text(
                  _roleValue == 'Person' ? _perText : _speText,
                  style: const TextStyle(
                      color: kGrey,
                      fontSize: 12.5,
                      letterSpacing: 1.0,
                      fontStyle: FontStyle.italic),
                ),
                DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryAppColor, width:1), //border of dropdown button
                      borderRadius: BorderRadius.circular(50), //border raiuds of dropdown button
                    ),
                    //
                    child:Padding(
                        padding: EdgeInsets.only(left:10, right:20),
                        child:DropdownButton(
                          value: _roleValue,
                          items: _roles.map((String role){
                            return DropdownMenuItem(
                              value: role,
                              child: Text(
                                role,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value){ //get value when changed
                            setState(() {
                              _roleValue = value!;
                              print("You have selected $_roleValue");
                            });
                          },
                          icon: const Padding( //Icon at tail, arrow bottom is default icon
                              padding: EdgeInsets.only(left:10),
                              child:Icon(Icons.arrow_downward)
                          ),
                          iconEnabledColor: kPrimaryAppColor, //Icon color
                          style: const TextStyle(  //te
                            color: kBlack, //Font color
                            fontSize: 18, //font size on dropdown button
                            letterSpacing: 1.0,
                          ),

                          dropdownColor: kInComingMessage,
                          borderRadius: BorderRadius.circular(10),//dropdown background color
                          underline: Container(), //remove underline
                          isExpanded: true, //make true to make width 100%
                        )
                    )
                ),
                Text(
                  _roleWarning,
                  style: const TextStyle(
                    color: kOrange,
                    fontSize: 12.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  //button to save user primary info to firestore
  Widget _saveUserPrimaryInformation() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 12.0, bottom: 10.0, left: 100.0, right: 100.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(100.0, 50.0),
              primary: kPrimaryAppColor,
              elevation: 0.0,
              padding:
                  const EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)))),
          child: const Text('Save',
              style: TextStyle(
                  color: kWhite, fontSize: 16.0, fontWeight: FontWeight.w800)),
          onPressed: () async {
            if (_userPrimaryInformationFormKey.currentState!.validate()) {
              SystemChannels.textInput
                  .invokeMethod('TextInput.hide'); //hides the keyboard

              profilePic == null
                  ? showPlatformToast(
                      child: const Text(
                        'Please, select profile picture',
                        style: TextStyle(color: kBlack, fontSize: 20.0),
                      ),
                      context: context)
                  : _onpressedActionOfSaveInfoButton();
            }
          }),
    );
  }

  //
  void _onpressedActionOfSaveInfoButton() async {
    try {
      // display loading overlay
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      String msg = '';

      ///call [checkUserPresence] and pass username
      final bool canRegisterNewUser = await _cloudStoreDataManagement
          .checkUsernamePresence(username: _username.text);

      //user name already exists
      if (!canRegisterNewUser) {
        msg = 'Username already present';
         //display appropriate alert message
       alert(title: msg, context: context);
       Timer(const Duration(seconds: 2), () => Navigator.pop(context));
       SystemChannels.textInput.invokeMethod('TextInput.hide');
     
      }

      ///if username does not exist call [registerNewUser]

      else {
        //upload profile pic file and get the remote file path
        final String? downloadedImagePath = await _cloudStoreDataManagement
            .uploadMediaToStorage(File(profilePic!), reference: 'profilePics/');

        print('uploaded image path : $downloadedImagePath');

        final bool _userEntryResponse =
            await _cloudStoreDataManagement.registerNewUser(
                name: _name.text,
                username: _username.text,
                userAbout: _userAbout.text,
                userRole: _roleValue,
                userEmail: FirebaseAuth.instance.currentUser!.email.toString(),
                profilePic: downloadedImagePath!);

        ///if user data entry is successful, navigate to [Homepage]
        if (_userEntryResponse) {

          //get account creation date,time and device token from cloud firestore
          final Map<String, dynamic> _getImportantDataFromFireStore =
              await _cloudStoreDataManagement.getDataFromCloudFireStore(
                  email: FirebaseAuth.instance.currentUser!.email.toString());
        
          ///calling [LocalDatabase] methods to create and insert new user data into a table

          //creates table for important primary user data
          await _localDatabase.createTableToStoreImportantData();
          //creates call logs table
          await _localDatabase.createTableForCallLogs();

          //inserts data into the table
          await _localDatabase.insertOrUpdateDataForThisAccount(
              name: _name.text,
              userName: _username.text,
              userMail: FirebaseAuth.instance.currentUser!.email.toString(),
              userToken: _getImportantDataFromFireStore['token'],
              userAbout: _userAbout.text,
              userAccCreationDate: _getImportantDataFromFireStore['date'],
              userAccCreationTime: _getImportantDataFromFireStore['time'],
              profileImagePath: profilePic!,
              profileImageUrl: downloadedImagePath);

          //navigate to MainScreen
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
              (route) => false);
        } else {
          msg = 'user data entry not successful';
           //display appropriate alert message
         alert(title: msg, context: context);
         Timer(const Duration(seconds: 2), () => Navigator.pop(context));
         SystemChannels.textInput.invokeMethod('TextInput.hide');
     
        }
      }


      //remove laoding overlay
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("error in saving user primary info : ${e.toString}");
    }
  }
}
