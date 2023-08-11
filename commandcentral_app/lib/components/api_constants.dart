// const String baseApiUrl = 'http://localhost:8080/'; // Mac
const String baseApiUrl =
    'http://commandcentralapi.azurewebsites.net/'; // Azure
// const String baseLinuxApiUrl = 'http://10.0.2.2:8080/';

// Authenticat
const String getToken = '${baseApiUrl}Authentication';

// GroceryList
const String getGroceryList = '${baseApiUrl}GroceryList/';

// GroceryList items
const String editGroceryItemUrl = '${baseApiUrl}GroceryList/Item';
const String createGroceryItemUrl = '${baseApiUrl}GroceryList/Item';
const String deleteGroceryItemUrl = '${baseApiUrl}GroceryList/Item/';
