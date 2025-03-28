import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String quote = "Loading...";    // variable to store quote
  final String apiUrl = "https://zenquotes.io/api/random";  // API url [API key not required, public API]
  bool isLoading = false; // boolean to check if quote is still loading

  @override
  void initState() {
    super.initState();
    fetchNewQuote();    // fetch quote
  }

  ///&&&&&&&&&&&&&&&& Function to fetch new quote &&&&&&&&&&&&&&&&&&&&///
  Future<void> fetchNewQuote() async {
    // set loading true
    setState(() {
      isLoading = true;
    });

    try {
      // call API
      final response = await http.get(Uri.parse(apiUrl));

      // check if API call is successful [statusCode 200 means OK]
      if (response.statusCode == 200) {
        final data = json.decode(response.body);  //converts raw JSON to dart object

        // set received quote to variable
        setState(() {
          quote = data[0]['q']; // access first quote from map using key"q"
        });
      } else {
        // show error
        setState(() {
          quote = "Failed to load quote. Please try again.";
        });
      }
    } catch (e) {
      // show error
      setState(() {
        quote = "No internet connection. Please check your network.";
      });
    }

    // set isLoading false
    setState(() {
      isLoading = false;
    });
  }

  ///&&&&&&&&&&&&&&&&& Function to handle share &&&&&&&&&&&&&&&&&&///
  void shareQuote() {
    if (quote.isNotEmpty && quote != "Loading...") {
      Share.share(quote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFff9966),
              Color(0xFFff5e62),
              Color(0xFFEC008C),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),

        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "✨ Daily Inspiration ✨",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (widget, animation) => FadeTransition(
                  opacity: animation,
                  child: widget,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Card(
                  key: ValueKey(quote),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: const Color.fromARGB(230, 255, 255, 255),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      quote,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: fetchNewQuote,
                    icon: const Icon(Icons.refresh),
                    label: Text("New Quote", style: TextStyle(fontWeight: FontWeight.w600),),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton.icon(
                    onPressed: shareQuote,
                    icon: const Icon(Icons.share),
                    label: Text("Share", style: TextStyle(fontWeight: FontWeight.w600),),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
