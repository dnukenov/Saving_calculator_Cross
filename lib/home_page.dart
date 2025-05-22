import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_service.dart';
import 'auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _items = ['Coffee', 'Lunch', 'Snacks'];
  bool _showItems = true;

  void _toggleItems() {
    setState(() {
      _showItems = !_showItems;
    });
  }

  void _addItem() {
    setState(() {
      _items.add('Item ${_items.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);
    final auth = Provider.of<AuthService>(context);
    final local = AppLocalizations.of(context)!;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.home),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
            tooltip: local.addItem,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text(local.appTitle)),
            ListTile(
              title: Text(local.settings),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            if (auth.isAuthenticated)
              ListTile(
                title: Text(local.profile),
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
            ListTile(
              title: Text(local.about),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
          ],
        ),
      ),
      body: orientation == Orientation.portrait
          ? _buildListView()
          : _buildGridView(),
      floatingActionButton: GestureDetector(
        onLongPress: _toggleItems,
        child: FloatingActionButton(
          onPressed: _addItem,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return _showItems
        ? ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(_items[index]),
            ),
          )
        : Center(child: Text(AppLocalizations.of(context)!.noItems));
  }

  Widget _buildGridView() {
    return _showItems
        ? GridView.count(
            crossAxisCount: 2,
            children: _items
                .map((e) => Card(
                      margin: const EdgeInsets.all(8),
                      child: Center(child: Text(e)),
                    ))
                .toList(),
          )
        : Center(child: Text(AppLocalizations.of(context)!.noItems));
  }
}
