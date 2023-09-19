import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Basic'),
            leading: Icon(Icons.list),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            title: Text('List Tiles'),
            leading: Icon(Icons.view_list),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/list_tile_example');
            },
          ),
          ListTile(
            title: Text('Expansion Tiles'),
            leading: Icon(Icons.keyboard_arrow_down),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed('/expansion_tile_example');
            },
          ),
          ListTile(
            title: Text('Slivers'),
            leading: Icon(Icons.assignment),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/sliver_example');
            },
          ),
          ListTile(
            title: Text('Drag Into List'),
            leading: Icon(Icons.add),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed('/drag_into_list_example');
            },
          ),
          ListTile(
            title: Text('Horizontal'),
            leading: Icon(Icons.swap_horiz),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/horizontal_example');
            },
          ),
          ListTile(
            title: Text('Fixed Items'),
            leading: Icon(Icons.block),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/fixed_example');
            },
          ),
          ListTile(
            title: Text('Drag Handle'),
            leading: Icon(Icons.drag_handle),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed('/drag_handle_example');
            },
          ),
        ],
      ),
    );
  }
}
