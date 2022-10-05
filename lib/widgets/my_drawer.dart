import 'package:euser/global/global.dart';
import 'package:euser/mainScreen/about_screen.dart';
import 'package:euser/mainScreen/profile_screen.dart';
import 'package:euser/mainScreen/trip_history_screen.dart';
import 'package:euser/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;

  MyDrawer({this.name, this.email});
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //drawer header
          Container(
            height: 110,
            color: Colors.white,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_rounded,
                    size: 70,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name.toString().length > 18 ? widget.name.toString().substring(0, 18) + "..." : widget.name.toString(),
                        style: const TextStyle(
                          fontSize: 27,
                          color: Color.fromRGBO(55, 55, 61, 100),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.email.toString().length > 20 ? widget.email.toString().substring(0, 20) + "..." : widget.email.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(55, 55, 61, 100),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 10.0,
          ),

          //drawer body

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => ProfileScreen()));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.person_rounded,
                  size: 37,
                  color: Color.fromRGBO(55, 55, 61, 100),
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: Color.fromRGBO(55, 55, 61, 100),
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {},
              child: const ListTile(
                leading: Icon(
                  Icons.pets_rounded,
                  size: 37,
                  color: Color.fromRGBO(55, 55, 61, 100),
                ),
                title: Text(
                  "Pets",
                  style: TextStyle(
                    color: Color.fromRGBO(55, 55, 61, 100),
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const TripHistoryScreen()));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.history_rounded,
                  size: 37,
                  color: Color.fromRGBO(55, 55, 61, 100),
                ),
                title: Text(
                  "History",
                  style: TextStyle(
                    color: Color.fromRGBO(55, 55, 61, 100),
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {},
              child: const ListTile(
                leading: Icon(
                  Icons.warning_amber_rounded,
                  size: 37,
                  color: Color.fromRGBO(55, 55, 61, 100),
                ),
                title: Text(
                  "Reports",
                  style: TextStyle(
                    color: Color.fromRGBO(55, 55, 61, 100),
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const AboutScreen()));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.info_outlined,
                  size: 37,
                  color: Color.fromRGBO(55, 55, 61, 100),
                ),
                title: Text(
                  "About",
                  style: TextStyle(
                    color: Color.fromRGBO(55, 55, 61, 100),
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                fAuth.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  size: 37,
                  color: Colors.red,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
