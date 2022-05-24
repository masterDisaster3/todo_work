import 'package:flutter/material.dart';
import 'package:todo_work/base.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Todo Work",
        theme: ThemeData(primarySwatch: Colors.amber),
        home: const TodoHome(title: "Todo Work!!!"));
  }
}

class TodoHome extends StatefulWidget {
  const TodoHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  var baseHandler = BaseHandler();
  final _biggerFont = const TextStyle(fontSize: 24);
  late String newValue;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color.fromARGB(255, 255, 246, 201),
            Color.fromARGB(255, 123, 255, 152)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(widget.title)),
        body: FutureBuilder(
          future: baseHandler.readData(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              var data = (snapshot.data as List<dynamic>).toList();
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    return Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: data[index]["status"]
                                  ? [
                                      const Color.fromARGB(255, 32, 255, 81),
                                      const Color.fromARGB(255, 206, 241, 213)
                                    ]
                                  : [
                                      const Color.fromARGB(255, 237, 115, 85),
                                      const Color.fromARGB(255, 241, 181, 151)
                                    ])),
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: 200,
                            height: 70,
                            child: Center(
                                child: Text(data[index]["task"],
                                    style: _biggerFont)),
                          ),
                          Checkbox(
                              value: data[index]["status"],
                              onChanged: (bool? value) {
                                baseHandler.updateData(
                                    data[index]["id"], value!);
                                setState(() {});
                              }),
                          IconButton(
                              onPressed: () {
                                baseHandler.deleteData(data[index]["id"]);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    );
                  });
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 200,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Enter new task"),
                      controller: _textController,
                      onChanged: ((value) {
                        newValue = value;
                      }),
                    )),
                const SizedBox(
                  width: 30,
                ),
                FloatingActionButton(
                    onPressed: () {
                      baseHandler.addData(_textController.text, false);
                      setState(() {
                        _textController.clear();
                      });
                    },
                    child: const Icon(Icons.add)),
                const SizedBox(
                  width: 30,
                ),
                FloatingActionButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Icon(Icons.refresh)),
              ]),
        ),
      ),
    );
  }
}
