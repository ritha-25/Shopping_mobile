import 'package:flutter/material.dart';

class Item {
  Item(this.name, {this.quantity = 1, this.category = 'Food', this.note = ''});
  
  String name;     
  bool bought = false;
  int quantity;    
  String category;  
  String note;      
}

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'Shopping List+'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final List<Item> items = [
    Item('Milk', category: 'Drinks', note: '1 Litre pack'),
    Item('Bread', category: 'Food'),
    Item('Rice', category: 'Food', note: 'Basmati'),
  ];

  final TextEditingController inputController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  
  String activeFilter = 'All'; 
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim().toLowerCase();
      });
    });
  }

  void addItem() {
    final text = inputController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Type an item first')),
      );
      return;
    }
    int matchIndex = items.indexWhere(
        (item) => item.name.trim().toLowerCase() == text.toLowerCase());

    if (matchIndex != -1) {
      setState(() {
        items[matchIndex].quantity += 1;
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${items[matchIndex].name} is already on the list: now ×${items[matchIndex].quantity}'),
        ),
      );
    } else {
      
      setState(() {
        items.add(Item(text));
      });
    }
    inputController.clear();
  }

  @override
  void dispose() {
    inputController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int itemsLeft = items.where((item) => !item.bought).length;

    List<Item> filteredList = [];
    if (activeFilter == 'To buy') {
      filteredList = items.where((item) => !item.bought).toList();
    } else if (activeFilter == 'Bought') {
      filteredList = items.where((item) => item.bought).toList();
    } else {
      List<Item> toBuyPart = items.where((item) => !item.bought).toList();
      List<Item> boughtPart = items.where((item) => item.bought).toList();
      filteredList = [...toBuyPart, ...boughtPart];
    }
    if (searchQuery.isNotEmpty) {
      filteredList = filteredList
          .where((item) => item.name.toLowerCase().contains(searchQuery))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} ($itemsLeft left)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_outlined),
            onPressed: () {
              setState(() {
                items.removeWhere((item) => item.bought);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
       
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search items...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    onSubmitted: (_) => addItem(),
                    decoration: const InputDecoration(
                      hintText: 'Add a new item',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: addItem,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['All', 'To buy', 'Bought'].map((filterType) {
                return ChoiceChip(
                  label: Text(filterType),
                  selected: activeFilter == filterType,
                  onSelected: (_) {
                    setState(() {
                      activeFilter = filterType;
                    });
                  },
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('Your list is empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  )
                : filteredList.isEmpty
                    ? const Center(
                        child: Text('Nothing here',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      )
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return ListTile(
                            onTap: () {
                              setState(() {
                                item.bought = !item.bought;
                              });
                            },
                            onLongPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(item: item),
                                ),
                              ).then((_) {
                                setState(() {});
                              });
                            },
                            leading: Icon(
                              item.bought
                                  ? Icons.check_circle
                                  : Icons.shopping_basket,
                              color: item.bought ? Colors.green : null,
                            ),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                decoration: item.bought
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              item.note.isEmpty
                                  ? item.category
                                  : '${item.category} · ${item.note}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Row(
mainAxisSize: MainAxisSize.min,
children: [
IconButton(
icon: const Icon(Icons.remove_circle_outline),
onPressed: () {
if (item.quantity > 1) {
setState(() {
item.quantity--;
});
}
},
),
Text('${item.quantity}',
style: const TextStyle(fontSize: 16)),
IconButton(
icon: const Icon(Icons.add_circle_outline),
onPressed: () {
setState(() {
item.quantity++;
});
},
),
const SizedBox(width: 8),
IconButton(
icon: const Icon(Icons.delete_outline,
color: Colors.redAccent),
onPressed: () {
final absoluteItemIndex = items.indexOf(item);
setState(() {
items.remove(item);
});
ScaffoldMessenger.of(context).hideCurrentSnackBar();
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('${item.name} removed'),
action: SnackBarAction(
label: 'Undo',
onPressed: () {
setState(() {
items.insert(absoluteItemIndex, item);
});
},
),
),
);
},
),
],
),
);
},
),
),
],
),
);
}
}

class DetailsScreen extends StatefulWidget {
const DetailsScreen({super.key, required this.item});
final Item item;
@override
State<DetailsScreen> createState() => _DetailsScreenState();
}
class _DetailsScreenState extends State<DetailsScreen> {
late TextEditingController nameController;
late TextEditingController noteController;
late String chosenCategory;
@override
void initState() {
super.initState();
nameController = TextEditingController(text: widget.item.name);
noteController = TextEditingController(text: widget.item.note);
chosenCategory = widget.item.category;
}
void saveChanges() {
final cleanName = nameController.text.trim();
if (cleanName.isEmpty) {
ScaffoldMessenger.of(context).hideCurrentSnackBar();
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Name cannot be empty')),
);
return;
}
widget.item.name = cleanName;
widget.item.note = noteController.text.trim();
widget.item.category = chosenCategory;
Navigator.pop(context);
}
@override
void dispose() {
nameController.dispose();
noteController.dispose();
super.dispose();
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Item Details'),
),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: ListView(
children: [
TextField(
controller: nameController,
decoration: const InputDecoration(
labelText: 'Item Name',
border: OutlineInputBorder(),
),
),
const SizedBox(height: 20),
TextField(
controller: noteController,
decoration: const InputDecoration(
labelText: 'Note (e.g., brand, package size)',
border: OutlineInputBorder(),
),
),
const SizedBox(height: 24),
const Text(
'Category',
style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),
const SizedBox(height: 8),
Row(
mainAxisAlignment: MainAxisAlignment.start,
children: ['Food', 'Drinks', 'Home'].map((categoryType) {
return Padding(
padding: const EdgeInsets.only(right: 8.0),
child: ChoiceChip(
label: Text(categoryType),
selected: chosenCategory == categoryType,
onSelected: (selected) {
if (selected) {
setState(() {
chosenCategory = categoryType;
});
}
},
),
);
}).toList(),
),
const SizedBox(height: 40),

FilledButton(
onPressed: saveChanges,
child: const Padding(
padding: EdgeInsets.symmetric(vertical: 12),
child: Text('Save Changes', style: TextStyle(fontSize: 16)),
),
),
],
),
),
);
}
}