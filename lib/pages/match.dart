import 'package:flutter/material.dart';
import 'package:lovealapp/models/user.dart';
import 'package:lovealapp/services/auth.dart';
import 'package:lovealapp/services/database.dart';
import 'package:lovealapp/shared/loading.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'message.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pimp_my_button/pimp_my_button.dart';

//adding for transition animation
import 'package:page_transition/page_transition.dart';

class Match extends StatefulWidget {
  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> {
  String matchID;
  String chatID;
  int matches;
  bool isProfileCreated;

  double sigmaX = 50;
  double sigmaY = 50;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<User>(context, listen: false);

    //get matches, matchID and chatID from db
    Firestore.instance.collection('users').document(user.uid).get().then((doc) {
      //get values for the widget build
      setState(() {
        matchID = doc['matchID'];
        chatID = doc['chatID'];
        matches = doc['matches'];
      });

      //decrease blur of active messages if matches have been reset to zero and you are not a new user
      if (doc['matches'] == 0 && doc['matchID'] != null) {
        Firestore.instance
            .collection("messages")
            .where('fromID', isEqualTo: user.uid)
            .where('matched', isEqualTo: true)
            .getDocuments()
            .then((querySnapshot) {
          querySnapshot.documents.forEach((document) {
            var documentID = document.documentID;
            var blur = document.data['blur'] - 5;

            //for each message document update the blur value
            Firestore.instance
                .collection("messages")
                .document(documentID)
                .updateData({'blur': blur});
          });
        });
      }
    });
  }

  void startChat() async {
    Firestore.instance
        .collection("messages")
        .document(chatID)
        .updateData({'matched': true});
  }

  @override
  Widget build(BuildContext context) {
    final myUserData = Provider.of<UserData>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: matchID).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          if (snapshot.hasData && matches > 0) {
            return Scaffold(
              backgroundColor: Hexcolor("#F4AA33"),
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).size.height * 0.30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return _imageFullScreen(userData.imgUrl);
                        }));
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(userData.imgUrl),
                      ),
                    ),
                    Text('${userData.nickname},  ${userData.age.toString()}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold)),
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(MdiIcons.mapMarker,
                              size: 20.0, color: Colors.white),
                          Text('${userData.location}, Japan',
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: ListView(
                      children: <Widget>[
                        _buildQuestion("Occupation", userData.occupation),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Interests',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 5),
                                Wrap(
                                  children: <Widget>[
                                    //WHEN REFACTORING CREATE SEPARATE WIDGET AND MAP THROUGH INTERESTS
                                    if (userData.yodeling)
                                      _buildInterests("Yodeling"),
                                    if (userData.shopping)
                                      _buildInterests("Shopping"),
                                    if (userData.makingBalloonAnimals)
                                      _buildInterests("Making Balloon Animals"),
                                    if (userData.cooking)
                                      _buildInterests("Cooking"),
                                    if (userData.painting)
                                      _buildInterests("Painting"),
                                    if (userData.movies)
                                      _buildInterests("Movies"),
                                    if (userData.sports)
                                      _buildInterests("Sports"),
                                    if (userData.writing)
                                      _buildInterests("Writing"),
                                    if (userData.drinking)
                                      _buildInterests("Drinking"),
                                  ],
                                )
                              ]),
                        ),
                        _buildQuestion("About me", userData.about),
                        //ANSWERS
                        _buildQuestion(
                            "🛌 Do you make your bed in the morning?",
                            userData.bed ?? "Ask me!"),
                        _buildQuestion(
                            "🤓 Do you read reviews, or just go with your gut?",
                            userData.reviews ?? "Ask me!"),
                        _buildQuestion(
                            "🌮 If you could only eat one thing for the rest of your life, what would it be?",
                            userData.foreverEat),
                        _buildQuestion(
                            "🌭 If you're eating a meal do you save the best thing for last or eat it first?",
                            userData.bestForLast ?? "Ask me!"),
                        _buildQuestion("👽 Do you believe in aliens?",
                            userData.aliens ?? "Ask me!"),
                        _buildQuestion(
                            "🚽 If you were a piece of furniture, what piece of furniture would you be?",
                            userData.furniture ?? "Ask me!"),
                        _buildQuestion(
                            "🏠 Would you rather have a home in the beach or the mountains?",
                            userData.beachOrMountain ?? "Ask me!"),
                        _buildQuestion(
                            "🍱 When you get take-out food do you eat out of the container or transfer the food to dishes?",
                            userData.takeOutFood ?? "Ask me!"),
                        _buildQuestion(
                            "🏝 If you were deserted on an island what items would you bring with you?",
                            userData.desertedIsland ?? "Ask me!"),
                        _buildQuestion(
                            "💒 If you were to choose between a glamorous wedding or a small ceremony at the city hall, which would you choose?",
                            userData.wedding ?? "Ask me!"),
                        _buildQuestion("🏡 Your place or mine?",
                            userData.yourPlaceOrMine ?? "Ask me!"),
                        _buildStartChatBtn(userData),
                        //ANSWER MORE QUESTIONS BTN
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if ((snapshot.hasData && matches == 0) || matchID == null) {
            final user = Provider.of<User>(context);
            return Scaffold(
              body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Hexcolor("#FFF1BA"), Hexcolor("#F4AA33")],
                  stops: [0.2, 0.7],
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //GET NEW MATCH BUTTON
                    PimpedButton(
                      particle: DemoParticle(),
                      pimpedWidgetBuilder: (context, controller) {
                        return Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: FloatingActionButton.extended(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0))),
                            label: Text("Meet someone new today! 🍺",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                            onPressed: () async {
                              controller.forward(from: 0.0);

                              //add matches by one
                              int matches = myUserData.matches + 1;

                              //find a user where matched is false
                              await Firestore.instance
                                  .collection("messages")
                                  .where('matchedUsers',
                                      arrayContains: user.uid)
                                  .getDocuments()
                                  .then((data) =>
                                      data.documents.forEach((doc) => {
                                            if (!doc['matched'])
                                              {
                                                //if fromID is not yours
                                                //set fromID to user.uid and toID to original fromID value
                                                if (doc['fromID'] != user.uid)
                                                  {
                                                    //check doc['fromID'] gender is equal to my gender pref
                                                    Firestore.instance
                                                        .collection("messages")
                                                        .document(
                                                            doc.documentID)
                                                        .updateData({
                                                      'fromID': user.uid,
                                                      'toID': doc['fromID']
                                                    }),
                                                    Firestore.instance
                                                        .collection('users')
                                                        .document(user.uid)
                                                        .updateData({
                                                      'matchID': doc['fromID'],
                                                      'chatID': doc.documentID,
                                                      'matches': matches,
                                                    }),
                                                  }
                                                else
                                                  {
                                                    Firestore.instance
                                                        .collection('users')
                                                        .document(user.uid)
                                                        .updateData({
                                                      'matchID': doc['toID'],
                                                      'chatID': doc.documentID,
                                                      'matches': matches,
                                                    }),
                                                  }
                                              }
                                          }));
                              //go to matched Profile page
                              Navigator.of(context)
                                  .pushNamed('/navigationHome');
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  Widget _buildInterests(String interest) {
    return Container(
        margin: EdgeInsets.only(right: 10),
        child: OutlineButton(
            child: Text(interest, style: TextStyle(color: Hexcolor("#8CC63E"))),
            onPressed: null,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0))));
  }

  Widget _buildQuestion(String title, String body) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 5),
            Text(body, style: TextStyle(fontSize: 16.0))
          ]),
    );
  }

  Widget _imageFullScreen(String src) {
    return GestureDetector(
      child: Center(
        child: Hero(
          tag: 'imageHero',
          child: Image.network(
            src,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildStartChatBtn(UserData userData) {
    return Container(
      height: 60.0,
      margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
      child: RaisedButton(
          child: Text('Share a 🍺 and chat!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          color: Colors.lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () => {
                startChat(),
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: Message(
                        chatRoomID: chatID,
                        matchID: matchID,
                        nickname: userData.nickname,
                        imgUrl: userData.imgUrl,
                      )),
                ),
              }),
    );
  }
}
