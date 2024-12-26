import 'package:book/Data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Book> books = [];
  bool isLoading = true;
  String searchQuery = '';
  String searchCriteria = 'Title';

  Future<void> fetchBooksByTitle(String title) async {
    String path = "http://zahisaadieh.onlinewebshop.net/searchByTitle.php?title=$title";
    Uri url = Uri.parse(path);
    await _fetchData(url);
  }

  Future<void> fetchBooksByAuthor(String author) async {
    String path = "http://zahisaadieh.onlinewebshop.net/searchByAuthor.php?author=$author";
    Uri url = Uri.parse(path);
    await _fetchData(url);
  }

  Future<void> fetchBooksByYear(String year) async {
    String path = "http://zahisaadieh.onlinewebshop.net/searchByYear.php?year=$year";
    Uri url = Uri.parse(path);
    await _fetchData(url);
  }

  Future<void> _fetchData(Uri url) async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonArray = convert.jsonDecode(response.body);
        List<Book> fetchedBooks = [];
        fetchedBooks.clear();
        for (var row in jsonArray) {
          Book b = Book(
            row['ISBN'],
            row['Book_Title'],
            row['Book_Author'],
            int.parse(row['Year_Of_Publication']),
            row['Publisher'],
            row['Image_URL_M'],
          );
          fetchedBooks.add(b);
        }

        setState(() {
          books = fetchedBooks;
          isLoading = false;
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleSearch() {
    setState(() {
      isLoading = true;
    });

    if (searchQuery.isNotEmpty) {
      if (searchCriteria == 'Year' && int.tryParse(searchQuery) != null) {
        fetchBooksByYear(searchQuery);
      } else if (searchCriteria == 'Author') {
        fetchBooksByAuthor(searchQuery);
      } else if (searchCriteria == 'Title') {
        fetchBooksByTitle(searchQuery);
      }
    } else {
      fetchBooksByTitle('');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooksByTitle('');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Book",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      hintText: 'Search for books...',
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: searchCriteria,
                  onChanged: (String? newValue) {
                    setState(() {
                      searchCriteria = newValue!;
                    });
                  },
                  items: <String>['Title', 'Author', 'Year']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.blueAccent),
                  onPressed: handleSearch,
                ),
              ],
            ),
            SizedBox(height: 16),

            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : books.isEmpty
                  ? Center(child: Text("No books found.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
                  : ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, i) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              books[i].imageUrlMedium,
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 150,
                                  color: Colors.grey,
                                  child: Icon(Icons.broken_image, size: 50),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  books[i].bookTitle,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Author: ${books[i].bookAuthor}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Year: ${books[i].yearOfPublication}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Publisher: ${books[i].publisher}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
