import 'package:flutter/material.dart';
import 'package:sqlite/db_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final DbManager _dbManager = new DbManager();

  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Student student;
  List<Student> studList;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('SQLITE'),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (val) => val.isNotEmpty ? null : 'Cannot be empty',
                ),
                TextFormField(
                  controller: _courseController,
                  decoration: InputDecoration(
                    labelText: 'Course',
                  ),
                  validator: (val) => val.isNotEmpty ? null : 'Cannot be empty',
                ),
                Container(
                  width: width * 1,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    onPressed: () {
                      _submitStudent(context);
                    },
                    child: Text('Submit'),
                  ),
                ),
                FutureBuilder(
                  future: _dbManager.getStudentList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      studList = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: studList == null ? 0 : studList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Student st = studList[index];
                          return Card(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: width * 0.6,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Name: ${st.name}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        'Course: ${st.course}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _nameController.text = st.name;
                                    _courseController.text = st.course;
                                    student = st;
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _dbManager.deleteStudent(st.id);
                                    setState(() {
                                      studList.removeAt(index);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return CircularProgressIndicator();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _submitStudent(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (student == null) {
        Student st =
        Student(name: _nameController.text, course: _courseController.text);
        _dbManager.insertStudent(st).then((id) {
          _nameController.clear();
          _courseController.clear();
          print('Student added to DB ${id}');
        });
      }
    }
  }

}
