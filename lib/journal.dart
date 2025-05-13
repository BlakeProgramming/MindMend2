import 'package:flutter/material.dart';
import 'data.dart';


class JournalHomePage extends StatefulWidget {
  @override
  _JournalHomePageState createState() => _JournalHomePageState();
}


class _JournalHomePageState extends State<JournalHomePage> {
  final data = JournalData();


  @override
  void initState() {
    super.initState();
    data.loadData().then((_) => setState(() {}));
  }


  void _createNewFolder() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController folderController = TextEditingController();
        return AlertDialog(
          title: Text("New Folder"),
          content: TextField(
            controller: folderController,
            decoration: InputDecoration(hintText: "Folder Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String folderName = folderController.text.trim();
                if (folderName.isNotEmpty && !data.folders.contains(folderName)) {
                  setState(() {
                    data.folders.add(folderName);
                    data.saveData();
                  });
                }
                Navigator.pop(context);
              },
              child: Text("Create"),
            ),
          ],
        );
      },
    );
  }


  void _openNewEntry() async {
    final newEntry = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NewEntryPage()),
    );


    if (newEntry != null && newEntry is JournalEntry) {
      setState(() {
        data.entries.add(newEntry);
        data.saveData();
      });
    }
  }


  void _openEntry(JournalEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EntryViewPage(entry: entry)),
    ).then((_) => setState(() {}));
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Journal"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Entries"),
              Tab(text: "Folders"),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.create_new_folder),
              onPressed: _createNewFolder,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: data.entries.length,
              itemBuilder: (context, index) {
                final entry = data.entries[index];
                return ListTile(
                  title: Text(entry.title),
                  subtitle: Text(entry.folder ?? "Unsorted"),
                  onTap: () => _openEntry(entry),
                );
              },
            ),
            ListView.builder(
              itemCount: data.folders.length,
              itemBuilder: (context, index) {
                final folder = data.folders[index];
                return ExpansionTile(
                  title: Text(folder),
                  children: data.entries
                      .where((e) => e.folder == folder)
                      .map((e) => ListTile(
                            title: Text(e.title),
                            onTap: () => _openEntry(e),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openNewEntry,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}


class NewEntryPage extends StatefulWidget {
  final JournalEntry? entryToEdit;


  NewEntryPage({this.entryToEdit});


  @override
  _NewEntryPageState createState() => _NewEntryPageState();
}


class _NewEntryPageState extends State<NewEntryPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _selectedFolder;


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.entryToEdit?.title ?? "Untitled Entry");
    _contentController =
        TextEditingController(text: widget.entryToEdit?.content ?? "");
    _selectedFolder = widget.entryToEdit?.folder;
  }


  @override
  Widget build(BuildContext context) {
    final folders = JournalData().folders;


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryToEdit == null ? "New Entry" : "Edit Entry"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final newEntry = JournalEntry(
                title: _titleController.text,
                content: _contentController.text,
                folder: _selectedFolder,
              );
              Navigator.pop(context, newEntry);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Entry Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: "Write your entry...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedFolder,
              hint: Text("Select Folder (Optional)"),
              items: folders.map((f) {
                return DropdownMenuItem(value: f, child: Text(f));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFolder = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}


class EntryViewPage extends StatefulWidget {
  final JournalEntry entry;


  EntryViewPage({required this.entry});


  @override
  _EntryViewPageState createState() => _EntryViewPageState();
}


class _EntryViewPageState extends State<EntryViewPage> {
  final data = JournalData();


  void _editEntry() async {
    final updatedEntry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewEntryPage(entryToEdit: widget.entry),
      ),
    );


    if (updatedEntry != null && updatedEntry is JournalEntry) {
      final index = data.entries.indexOf(widget.entry);
      if (index != -1) {
        setState(() {
          data.entries[index] = updatedEntry;
        });
        data.saveData();
      }
    }
  }


  void _changeFolder(String? newFolder) {
    final index = data.entries.indexOf(widget.entry);
    if (index != -1) {
      setState(() {
        data.entries[index].folder = newFolder;
      });
      data.saveData();
    }
  }


  @override
  Widget build(BuildContext context) {
    final folders = data.folders;


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editEntry,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SingleChildScrollView(child: Text(widget.entry.content))),
            SizedBox(height: 20),
            DropdownButton<String>(
              isExpanded: true,
              value: widget.entry.folder,
              hint: Text("Change Folder"),
              items: [null, ...folders].map((f) {
                return DropdownMenuItem<String>(
                  value: f,
                  child: Text(f ?? "Unsorted"),
                );
              }).toList(),
              onChanged: _changeFolder,
            ),
          ],
        ),
      ),
    );
  }
}
