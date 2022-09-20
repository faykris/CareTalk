class CallLog {
  //late String name;
  late String username;
  late String dateTime;
  late String isPicked;
  late String isCaller;
  late String profilePic;

  CallLog(
      {
        //required String name,
        required String username,
      required String dateTime,
      required String isPicked,
      required String isCaller,
      required String profilePic}) {
    //this.name = name;
    this.username = username;
    this.dateTime = dateTime;
    this.profilePic = profilePic;
    this.isPicked = isPicked;
    this.isCaller = isCaller;
  }

  factory CallLog.toJson(Map<String, dynamic> map) {
    return CallLog(
       // name: map["name"],
        username: map["username"],
        dateTime: map["date_time"],
        isPicked: map["isPicked"],
        isCaller: map["isCaller"],
        profilePic: map["profile_pic"]);
  }
}
