import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:CareTalk/backend/sqlite_management/local_database_management.dart';
import 'package:CareTalk/frontend/preview/image_preview.dart';
import 'package:CareTalk/global_uses/constants.dart';
import 'package:CareTalk/global_uses/enum_generation.dart';
import 'package:CareTalk/models/call_log.dart';
import 'package:page_transition/page_transition.dart';

class CallLogCollection extends StatefulWidget {
  const CallLogCollection({Key? key}) : super(key: key);

  @override
  State<CallLogCollection> createState() => _CallLogCollectionState();
}

class _CallLogCollectionState extends State<CallLogCollection> {
  bool _isLoading = false;
  final LocalDatabase _localDatabase = LocalDatabase();

  ///[LoadingOverlay] isLoading value
  //connections that have been called
  List<CallLog> _callDetails = [];

  TextEditingController _searchCallLogsController = TextEditingController();
  
  
  
  //load call logs from local
  void _getCallLogsFromLocal() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      List<CallLog> _callLogs = await _localDatabase.getCallLogs();

      for (int i = 0; i < _callLogs.length; i++) {
        final CallLog callLog = _callLogs[i];
        if (mounted) {
          setState(() {
            _callDetails.add(CallLog(
                //name: callLog.name,
                username: callLog.username,
                profilePic: callLog.profilePic,
                dateTime: callLog.dateTime,
                isPicked: callLog.isPicked,
                isCaller: callLog.isCaller));
          });
        }
      }
    } catch (e) {
      print("error in loading call logs from local: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _getCallLogsFromLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: kWhite,
            body: LoadingOverlay(
                isLoading: _isLoading,
                child: ListView(shrinkWrap: true, children: [
                  Container(
                      color: kWhite,
                      height: 120.0,
                      width: double.maxFinite,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 5.0),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text('Calls',
                                      style: TextStyle(
                                        color: kSecondaryAppColor,
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.w600,
                                      )
                                  ),
                                  const SizedBox(width: 115.0),
                                  IconButton(
                                      icon: const Icon(
                                          Icons.more_vert_outlined,
                                          size: 21.0,
                                          color: kSecondaryAppColor
                                      ),
                                      onPressed: () {}),
                                  const SizedBox(width: 2.0),
                                ]),
                            _searchCallLogs(),
                          ])),
                  _callDetails.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 175.0),
                          child: Center(
                            child: Text(
                              'No logs yet',
                              style: TextStyle(
                                  color: kGrey,
                                  fontSize: 18.0,
                                  letterSpacing: 1.0),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _callDetails.length,
                          itemBuilder: (upperContext, index) =>
                              _connectionCallHistory(index))
                ]))));
  }

//connection call history tile
  Widget _connectionCallHistory(int index) {
    return ListTile(
        key: Key('$index'),
        onTap: () {},
        //animation container
        leading: GestureDetector(
            child: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    FileImage(File(_callDetails[index].profilePic))),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: ImageViewScreen(
                        imagePath: _callDetails[index].profilePic,
                        imageProviderCategory: ImageProviderCategory.fileImage,
                      )));
            }),
        title: Text(
            _callDetails[index].username.length <= 18
                ? _callDetails[index].username
                : _callDetails[index].username.replaceRange(
                    18,
                    _callDetails[index].username.length,
                    '...'), //ensure title length is no more than 18
            style: const TextStyle(
                fontSize: 18.0,
                color: kSecondaryAppColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0)),
        subtitle: Row(
          children: [
            _callDetails[index].isCaller == "true"
                ? _callDetails[index].isPicked == "true"
                    ? const Icon(
                        Icons.call_made,
                        size: 15.0,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.call_missed,
                        size: 15.0,
                        color: kRed,
                      )
                : _callDetails[index].isPicked == "true"
                    ? const Icon(
                        Icons.call_received,
                        size: 15.0,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.call_missed,
                        size: 15.0,
                        color: kRed,
                      ),
            Text(
              _callDetails[index].dateTime,
              style: const TextStyle(
                  color: kGrey,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  fontSize: 13.0),
            )
          ],
        ),
        trailing: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
              size: 22.0,
              color: kPrimaryAppColor,
            )));
  }

  Widget _searchCallLogs() {
    return SizedBox(
        width: 260,
        child: TextField(
          maxLines: 1,
          controller: _searchCallLogsController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            hintText: 'Search',
            hintStyle: const TextStyle(
                color: Colors.grey,
                letterSpacing: 1.0,
                fontSize: 18
            ),
            isDense: true,                      // Added this
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            suffixIcon: IconButton(
              iconSize: 25,
              icon: const Icon(Icons.search, color: kGrey,),
              onPressed: () {},
            ),
            filled: true,
            fillColor: const Color.fromARGB(18, 63, 2, 142), // Color.fromARGB(26, 63, 2, 142),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(color: Color.fromARGB(18, 63, 2, 142))),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(color: Color.fromARGB(18, 63, 2, 142))),
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(color: Color.fromARGB(18, 63, 2, 142))),
            focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(color: Color.fromARGB(18, 63, 2, 142))),// Added this
          ),
        )
    );
  }
}
