import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_profile.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            ListTile(
              onTap: (){



              },
              title: Text('View Profile'),
              leading: Icon(Icons.person),
            )
          ],
        ),
      ),
    );
  }
}
