import 'package:flutter/material.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Basic'),
            leading: const Icon(Icons.list),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            title: const Text('List Tiles'),
            leading: const Icon(Icons.view_list),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/list_tile_example');
            },
          ),
          ListTile(
            title: const Text('Expansion Tiles'),
            leading: const Icon(Icons.keyboard_arrow_down),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed('/expansion_tile_example');
            },
          ),
          ListTile(
            title: const Text('Slivers'),
            leading: const Icon(Icons.assignment),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/sliver_example');
            },
          ),
          ListTile(
            title: const Text('Drag Into List'),
            leading: const Icon(Icons.add),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed('/drag_into_list_example');
            },
          ),
          ListTile(
            title: const Text('Horizontal'),
            leading: const Icon(Icons.swap_horiz),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/horizontal_example');
            },
          ),
          ListTile(
            title: const Text('Fixed Items'),
            leading: const Icon(Icons.block),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/fixed_example');
            },
          ),
          ListTile(
            title: const Text('Drag Handle'),
            leading: const Icon(Icons.drag_handle),
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
