// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/widgets/to_do_dialog.dart';
import 'package:to_dont_list/objects/book.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<Book> items = [ Book(name: "All the President's Men", isFiction: false, progress: 0.5)];
  final _itemSet = <Book>{};

  void _handleListChanged(Book item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
      }
    });
  }

  void _handleDeleteItem(Book item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
    });
  }

   void _handleNewItem(String itemText, TextEditingController textController, double sliderValue, bool switchValue) {
    setState(() {
      print("Adding new item");
      Book item = Book(name: itemText, isFiction: switchValue, progress: sliderValue);
      items.insert(0, item);
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Book List'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return BookItem(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return ToDoDialog(onListAdded: _handleNewItem);
                  });
            }));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'To Do List',
    home: ToDoList(),
  ));
}
