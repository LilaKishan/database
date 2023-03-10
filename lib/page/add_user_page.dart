import 'package:database/database/my_database.dart';
import 'package:database/model/city_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddUserPage extends StatefulWidget {
  dynamic name;
  dynamic city;
  Map<String, Object?>? map;

  AddUserPage(this.map);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  var title = 'Add User';
  @override
  void initState() {
    super.initState();

    nameController.text =
        widget.map == null ? "" : widget.map!['Name'].toString();
    cityController.text =
        widget.map == null ? "" : widget.map!['CityId'].toString();

    // MyDatabase().getUserLIstFromUser();
  }

  final _formKey = GlobalKey<FormState>();

  CityModel? _ddSelectedValue;
  bool isCityListGet = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "ADD USER",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
              ),
            )
            //back page
          ],
        ),
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Card(
                elevation: 20,
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.person_add),
                            ),
                          ),
                          //person avtar
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: "Name",
                              labelText: 'Username',
                            ),
                          ),
                          //name
                          FutureBuilder<List<CityModel>>(
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (isCityListGet) {
                                  _ddSelectedValue = snapshot.data![0];
                                  isCityListGet = false;
                                }

                                return DropdownButton(
                                  value: _ddSelectedValue,
                                  items: snapshot.data!.map((CityModel e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e.CityName.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _ddSelectedValue = value;
                                    });
                                  },
                                );
                              } else {
                                return Text('data');
                              }
                            },
                            future: isCityListGet
                                ? MyDatabase().getCityList()
                                : null,
                          ),
                          //dropdown
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (widget.map == null) {
                                    insertUserDB().then((value) {
                                      if (value == true) {
                                        setState(() {});
                                      }
                                      Navigator.of(context).pop(true);
                                    });
                                  } else {
                                    updateUserDB(widget.map!['PID'])
                                        .then((value) {
                                      if (value == true) {
                                        setState(() {});
                                      }
                                      Navigator.of(context).pop(true);
                                    });
                                  }
                                }

                                // Navigator.of(context).pop(true);
                              },
                              autofocus: false,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.amber,
                                padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                              ),
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          //add or update button
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<int> insertUserDB() async {
    Map<String, dynamic> map = {};
    map['Name'] = nameController.text;
    map['CityId'] = _ddSelectedValue!.CityId!;
    int userID = await MyDatabase().insertUserDetail(map);

    return userID;
  }

  Future<int> updateUserDB(id) async {
    Map<String, dynamic> map = {};
    map['Name'] = nameController.text;
    map['CityId'] = _ddSelectedValue!.CityId!;
    int userID = await MyDatabase().updateUserDetail(map, id);

    return userID;
  }
}
