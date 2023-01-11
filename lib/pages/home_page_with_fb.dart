import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constants.dart';
import '../widgets/my_drawer.dart';
import 'login_page.dart';


class HomePageFB extends StatefulWidget {
  const HomePageFB({super.key});

  @override
  State<HomePageFB> createState() => _HomePageFBState();
}

class _HomePageFBState extends State<HomePageFB> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    // var res = await http.get(Uri.parse(url));
    var res = await rootBundle.loadString("assets/mockdata.json");
    var data = jsonDecode(res);
    // setState(() {});
    return data;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: const Text("My Second App"),
        actions: [
          IconButton(
              onPressed: () {
                Constants.prefs?.setBool("loggedIn", false);
                // Navigator.pop(context);
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(context,
              PageRouteBuilder(pageBuilder: (a, b, c) => const HomePageFB()));
          return Future.value();
        },
        child: FutureBuilder(
            // future: Future.delayed(const Duration(seconds: 3), fetchData),
            future: fetchData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(child: Text("Nothing Loading"));
                case ConnectionState.active:
                  return const Center(child: Text("Active"));
                case ConnectionState.waiting:
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.amberAccent,
                  ));
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error Encountered"));
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index]["title"]),
                        subtitle: Text("${snapshot.data[index]["id"]}"),
                        leading: Image.network(snapshot.data[index]["url"]),
                      );
                    },
                    itemCount: snapshot.data.length,
                  );
              }
            }),
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
