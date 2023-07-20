import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroceryListPage extends StatelessWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        var url = Uri.parse('http://10.0.2.2:8080/GroceryList/1');
        var headers = {'Authorization': 'Bearer $token'};
        var response = await http.get(url, headers: headers);
        print("Status code ${response.statusCode}");
        if (response.statusCode == 200) {
          // Parse the JSON response
          var jsonData = jsonDecode(response.body);

          // Handle the data as needed
          print(jsonData);
          return jsonDecode(response.body);
        } else {
          // Handle API response for failed request
          print('Request failed with status: ${response.statusCode}');
          return {};
        }
      } catch (e) {
        // Handle any errors that occurred during the API call
        print('Error: $e');
        return {};
      }
    } else {
      print('Token is null or not available');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the data is being fetched, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error in fetching the data, show an error message
            return Center(child: Text('Error fetching data'));
          } else {
            // If data is available, build the ListView.builder with the data
            Map<String, dynamic> data =
                snapshot.data ?? {}; // Default to an empty map if data is null
            return ListView.builder(
              itemCount: data['groceryListItems'] != null
                  ? data['groceryListItems'].length
                  : 0,
              itemBuilder: (context, index) {
                // Check if the groceryListItems is not null and index is within range
                if (data['groceryListItems'] != null &&
                    index < data['groceryListItems'].length) {
                  var item = data['groceryListItems'][index];
                  return ListTile(
                    title: Text(item['itemName']),
                    subtitle: Text('Amount: ${item['itemAmount']}'),
                  );
                } else {
                  // Return an empty Container if data is not available or out of range
                  return Container();
                }
              },
            );
          }
        },
      ),
    );
  }
}
