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

  
  @override
  void dispose() {
    inputController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int itemsLeft = items.where((item) => !item.bought).length;

    
    

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

const SizedBox(width: 8),
IconButton(
icon: const Icon(Icons.delete_outline,
color: Colors.redAccent),
onPressed: () {

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
