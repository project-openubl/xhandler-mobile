import 'package:material_ui/material_ui.dart';

import '../strings.dart';

/// List page with a search box in the app bar and a button to add items
class SearchListPage extends StatefulWidget {
  const SearchListPage({
    super.key,
    required this.title,
    required this.addTooltip,
    required this.onAdd,
    required this.list,
  });

  final String title;
  final String addTooltip;
  final VoidCallback onAdd;

  /// The list for the current search text
  final Widget Function(String search) list;

  @override
  State<SearchListPage> createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SearchBar(
              hintText: Strings.search,
              leading: const Icon(Icons.search),
              onChanged: (text) => setState(() => _search = text.trim()),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: widget.addTooltip,
        onPressed: widget.onAdd,
        child: const Icon(Icons.add),
      ),
      body: widget.list(_search),
    );
  }
}
