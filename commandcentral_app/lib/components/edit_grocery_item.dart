import 'package:commandcentral_app/components/custom_colors.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:commandcentral_app/components/api_constants.dart';
import 'package:commandcentral_app/model/grocery_data.dart';

class EditGroceryItemPage extends StatefulWidget {
  final Map<String, dynamic> itemData;

  const EditGroceryItemPage({Key? key, required this.itemData})
      : super(key: key);

  @override
  _EditGroceryItemPageState createState() => _EditGroceryItemPageState();
}

class _EditGroceryItemPageState extends State<EditGroceryItemPage> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemAmountController = TextEditingController();

  Future<void> _updateItem() async {
    String newItemName = itemNameController.text;
    String newItemAmount = itemAmountController.text;
    int? newItemAmountAsInt;

    // Validate the input for item amount
    if (newItemAmount.isNotEmpty) {
      newItemAmountAsInt = int.tryParse(newItemAmount);
      if (newItemAmountAsInt == null) {
        _showErrorSnackbar('Invalid input for Item Amount');
        return;
      }
    }

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        final Map<String, dynamic> requestBody = {
          'groceryListItemId': widget.itemData['groceryListItemId'],
          'itemName': newItemName,
          'itemAmount': newItemAmountAsInt,
        };

        final http.Response response = await http.put(
          Uri.parse(editGroceryItemUrl),
          headers: headers,
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 204) {
          // Item was successfully updated, navigate back to the grocery list page
          int indexOfUpdatedItem = GroceryData.groceryListItems.indexWhere(
              (item) =>
                  item['groceryListItemId'] ==
                  widget.itemData['groceryListItemId']);
          if (indexOfUpdatedItem != -1) {
            // Update the item in the list with the new data
            setState(() {
              GroceryData.groceryListItems[indexOfUpdatedItem]['itemName'] =
                  newItemName;
              GroceryData.groceryListItems[indexOfUpdatedItem]['itemAmount'] =
                  newItemAmountAsInt;
            });
          }
          Navigator.pop(context, true);
        } else {
          // Show a snackbar with the error message from the API response
          if (response.body.isNotEmpty) {
            final dynamic responseData = jsonDecode(response.body);
            final String errorMessage =
                responseData['message'] ?? 'Unknown error occurred';
            _showErrorSnackbar(errorMessage);
          } else {
            _showErrorSnackbar(
                'Failed to update item. Status code: ${response.statusCode}');
          }
        }
      } else {
        _showErrorSnackbar('Token is null or not available');
      }
    } catch (e) {
      _showErrorSnackbar('Error: $e');
    }
  }

  void _showErrorSnackbar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the current item data
    itemNameController.text = widget.itemData['itemName'];
    itemAmountController.text = widget.itemData['itemAmount'].toString();
  }

  @override
  void dispose() {
    // Clean up the text controllers
    itemNameController.dispose();
    itemAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appItemColor,
        title: Text('Edit Grocery Item'),
      ),
      body: Container(
        color: appBgColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: itemAmountController,
                decoration: InputDecoration(labelText: 'Item Amount'),
              ),
              ElevatedButton(
                onPressed: _updateItem,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
