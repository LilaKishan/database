import 'package:database/database/my_database.dart';
import 'package:database/page/add_user_page.dart';
import 'package:flutter/material.dart';

class DatabaseCall extends StatefulWidget {
  @override
  State<DatabaseCall> createState() => _DatabaseCallState();
}

class _DatabaseCallState extends State<DatabaseCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Database Demo'), actions: [
        InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return AddUserPage(null);
              })).then((value) {
                if (value == true) {
                  setState(() {
                    MyDatabase().getUserLIstFromUser();
                  });
                }
              });
            },
            child: Icon(Icons.add))
        //adduser
      ]),
      body: FutureBuilder<bool>(
        builder: (context, snapshot1) {
          if (snapshot1.hasData) {
            return FutureBuilder<List<Map<String, Object?>>>(
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AddUserPage(snapshot.data![index]);
                            },
                          ),
                        ).then((value) {
                          if (value == true) {
                            setState(() {});
                          }
                        });
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text((snapshot.data![index]['PID'])
                                      //     .toString()),
                                      Text(
                                        (snapshot.data![index]['Name'])
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text((snapshot.data![index]['CityName'])
                                          .toString()),
                                    ],
                                  ),
                                ),
                                //displaydata
                                InkWell(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        alignment: AlignmentDirectional.center,
                                        child: AlertDialog(
                                            title: Text('Are you sure?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Text('No')),
                                              TextButton(
                                                  onPressed: () {
                                                    MyDatabase()
                                                        .deleteUserDetail(
                                                            (snapshot.data![
                                                                        index]
                                                                    ['PID'])
                                                                .toString())
                                                        .then(
                                                      (value) {
                                                        setState(() {
                                                          MyDatabase()
                                                              .getUserLIstFromUser();
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                    );
                                                  },
                                                  child: Text('Yes'))
                                            ]),
                                      );
                                    },
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                                //delete
                              ]),
                        ),
                      ),
                    );
                  },
                );
              },
              future: MyDatabase().getUserLIstFromUser(),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
        future: MyDatabase().copyPasteAssetFileToRoot(),
      ),
    );
  }
}
