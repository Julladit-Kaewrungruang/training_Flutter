import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'model/todo_model.dart';
import 'service/todo_service.dart';
import 'todo.dart';
import 'widget/cardToDo.dart';
import 'widget/dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

Future getTodoData({String? search}) async {
  var result;

  if (search != null) {
    result = await TodoService().getTodoByTitle(title: search);
    return result;
  } else {
    result = await TodoService().getTodo();
    return result;
  }
}

class _HomeState extends State<Home> {
  var searchData;
  SearchController searchControl = SearchController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
        title: Text(
          'Todo App',
          style: GoogleFonts.kanit(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SearchAnchor(
              searchController: searchControl,
              builder: (BuildContext context, SearchController controller) {
                return TextField(
                  controller: controller,
                  onChanged: (value) {
                    controller.text = value;
                  },
                  onSubmitted: (value) {
                    setState(() {
                      searchData = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Find Todo...',
                    helperStyle: const TextStyle(color: Colors.amber),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) async {
                final query = controller.text.toLowerCase();

                final filteredItems =
                    await TodoService().getTodoByTitle(title: query);

                return filteredItems.map<Widget>((item) {
                  return ListTile(
                    title: Text(item.title),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected: ${item.title}')),
                      );
                    },
                  );
                }).toList();
              },
            ),
            FutureBuilder(
              future: getTodoData(search: searchData),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  List<TodoModel> data = snapshot.data;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Todo(
                                todo: data[index],
                              ),
                            ),
                          );
                        },
                        child: Cardtodo(
                          title: data[index].title.toString(),
                          subTitle: data[index].detail.toString(),
                          iconDone: (data[index].isDone != null &&
                                  data[index].isDone!)
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          onPressedDelete: (p0) async {
                            await TodoService()
                                .deleteTodo(id: data[index].id as int);
                            log("DeleteTodo 200 Ok");
                            setState(() {});
                          },
                          onPressedEdit: (p0) {
                            log('Edit :: ${data[index].id}');
                          },
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(child: Text("No Data"));
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          backgroundColor: const Color(0xffAAB6FB),
          onPressed: () async {
            await showDialog(
                context: context, builder: (context) => const MyDialog());
            setState(() {
              searchData = null;
            });
            searchControl.clear();
          },
          tooltip: 'Increment',
          child: const Icon(
            Icons.add,
            color: Color(0xff848184),
          ),
        ),
      ),
    );
  }
}
