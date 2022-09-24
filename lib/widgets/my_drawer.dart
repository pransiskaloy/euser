import 'package:euser/global/global.dart';
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
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.email.toString().length > 20 ? widget.email.toString().substring(0, 20) + "..." : widget.email.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
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

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.person_rounded,
                size: 37,
                color: Colors.grey,
              ),
              title: Text(
                "Visit Profile",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 19,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.pets_rounded,
                size: 37,
                color: Colors.grey,
              ),
              title: Text(
                "Pets",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 19,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.history_rounded,
                size: 37,
                color: Colors.grey,
              ),
              title: Text(
                "History",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 19,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.warning_amber_rounded,
                size: 37,
                color: Colors.grey,
              ),
              title: Text(
                "Reports",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 19,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.info_outlined,
                size: 37,
                color: Colors.grey,
              ),
              title: Text(
                "About",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 19,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              fAuth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.logout_rounded,
                size: 37,
                color: Colors.grey,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 19,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
