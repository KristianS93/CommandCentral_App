import 'package:commandcentral_app/model/grocery_data.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:commandcentral_app/components/custom_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:commandcentral_app/components/api_constants.dart';

import '../components/edit_grocery_item.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  bool _isLoading = false;
  String? token; // Declare the token as an instance variable
  GlobalKey listViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null) {
      try {
        var url = Uri.parse(getGroceryList);
        var headers = {'Authorization': 'Bearer $token'};
        var response = await http.get(url, headers: headers);
        print("Status code ${response.statusCode}");
        if (response.statusCode == 200) {
          List<dynamic> groceryListItems =
              jsonDecode(response.body)['groceryListItems'];
          if (groceryListItems != null) {
            setState(() {
              GroceryData.groceryListItems =
                  List<Map<String, dynamic>>.from(groceryListItems);
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          print('Request failed with status: ${response.statusCode}');
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('Token is null or not available');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addItem() async {
    // Show a dialog to add a new item
    String? itemName;
    String? itemAmount;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Item Name'),
                onChanged: (value) => itemName = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Item Amount'),
                onChanged: (value) => itemAmount = value,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (itemName != null && itemAmount != null) {
                  try {
                    final Map<String, String> headers = {
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/json',
                    };

                    final Map<String, dynamic> requestBody = {
                      'itemName': itemName,
                      'itemAmount': itemAmount,
                    };

                    final http.Response response = await http.post(
                      Uri.parse(createGroceryItemUrl),
                      headers: headers,
                      body: jsonEncode(requestBody),
                    );

                    if (response.statusCode == 201) {
                      // If the item was created successfully, add it to the list
                      setState(() {
                        GroceryData.groceryListItems.add({
                          'itemName': itemName,
                          'itemAmount': itemAmount,
                        });
                      });
                    } else {
                      // Handle other status codes as needed
                      print(
                          'Failed to create item. Status code: ${response.statusCode}');
                    }
                  } catch (e) {
                    // Handle any errors that occurred during the API call
                    print('Error: $e');
                  }

                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editItem(BuildContext context, Map<String, dynamic> item) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditGroceryItemPage(itemData: item),
      ),
    );

    // Check if result is true, indicating a successful update
    if (result == true) {
      // Perform the fetch data again to update the list with the edited item
      await _fetchData();
    }
  }

  Future<bool> _deleteItemFromApi(String itemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        var url = Uri.parse(deleteGroceryItemUrl + itemId);
        var headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };
        var response = await http.delete(url, headers: headers);
        print("Trying to delete ${itemId}");
        if (response.statusCode == 204) {
          return true;
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Token is null or not available');
    }

    return false;
  }

  Future<void> _deleteItem(int index) async {
    // Show a dialog to confirm deletion
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool deleted = await _deleteItemFromApi(
                  GroceryData.groceryListItems[index]['groceryListItemId']
                      .toString(), // Convert to String
                );
                if (deleted) {
                  setState(() {
                    GroceryData.groceryListItems.removeAt(index);
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // void _showPopupMenu(
  //     BuildContext context, Map<String, dynamic> item, int index) {
  //   final RenderBox overlay =
  //       Overlay.of(context).context.findRenderObject() as RenderBox;
  //   final RenderBox itemBox = context.findRenderObject() as RenderBox;

  //   final relativeOffset =
  //       itemBox.localToGlobal(Offset.zero, ancestor: overlay);

  //   final double left = relativeOffset.dx;
  //   final double top = relativeOffset.dy + itemBox.size.height;

  //   showMenu(
  //     context: context,
  //     position: RelativeRect.fromLTRB(left, top, 0, 0),
  //     items: [
  //       PopupMenuItem(
  //         child: Text('Edit'),
  //         value: 'edit',
  //       ),
  //       PopupMenuItem(
  //         child: Text('Delete'),
  //         value: 'delete',
  //       ),
  //     ],
  //   ).then((value) {
  //     if (value == 'edit') {
  //       _editItem(context, item);
  //     } else if (value == 'delete') {
  //       _deleteItem(index);
  //     }
  //   });
  // }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: appBgColor,
    body: RefreshIndicator(
      onRefresh: _fetchData, // Method to be called when refreshing
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GroceryData.groceryListItems.isEmpty
              ? Center(
                  child: Text(
                    'No grocery items found.',
                    style: TextStyle(fontSize: 20),
                  ),
                ) // Show message when the list is empty
              : Builder( // Use Builder to access the context
                  builder: (context) => ListView.builder(
                    itemCount: GroceryData.groceryListItems.length,
                    itemBuilder: (context, index) {
                      var item = GroceryData.groceryListItems[index];
                      return Dismissible(
                        key: Key(item['groceryListItemId'].toString()),
                        direction: DismissDirection.endToStart, // Changed the direction here
                        background: Container(
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end, // Align the icon to the right
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirm Deletion'),
                                content: Text('Are you sure you want to delete this item?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) async {
                          bool deleted = await _deleteItemFromApi(item['groceryListItemId'].toString());
                          if (deleted) {
                            setState(() {
                              GroceryData.groceryListItems.removeAt(index);
                            });
                          }
                        },
                        child: GestureDetector( // Use GestureDetector for tap and long-press behavior
                          onTap: () {}, // Add any tap behavior here if needed
                          onLongPress: () => _editItem(context, item),
                          child: Card(
                            color: Colors.white, // White background for the card
                            elevation:
                                0.0, // Set elevation to 0.0 to remove the shadow
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12.0), // Rounded corners
                            ),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
                              title: Text(
                                item['itemName'],
                                style: TextStyle(fontSize: 18, color: Colors.black), // Set text color to black
                              ),
                              subtitle: Text(
                                'Amount: ${item['itemAmount']}',
                                style: TextStyle(fontSize: 16, color: Colors.black), // Set text color to black
                              ),
                              trailing: Container(width: 0), // Remove the arrow icon
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Edit icon removed, long press for editing
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _addItem,
      child: Icon(Icons.add),
      backgroundColor: appItemColor,
    ),
  );
}

}
