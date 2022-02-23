import 'package:flutter/material.dart';
import 'package:habitr_tfg/data/enum/ActivityType.dart';
import 'package:habitr_tfg/data/classes/routine.dart';
import 'package:habitr_tfg/data/models/routinesingleton.dart';
import 'package:habitr_tfg/screens/routine/editroutinescreen.dart';
import 'package:habitr_tfg/screens/routine/routinedetailscreen.dart';

class RoutineScreen extends StatefulWidget {
  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  RoutineSingleton rs = RoutineSingleton();

  @override
  Widget build(BuildContext context)  {
    final List rutinasTest = rs.listaRutinas;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Routines",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,

      ),
      body: Center(
        child:
          ListView.builder(
            itemCount: rutinasTest.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                    height: 50,
                    color: Colors.white24,
                    child: Row(children: [Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${rutinasTest[index].name}', style: TextStyle(color: Colors.white))),
                                          Spacer(),
                                          IconButton(onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditRoutineScreen(index: index))).then((_) => setState(() {}));
                                            },
                                            icon: Icon(Icons.edit),
                                            color: Colors.grey,
                                          ),]
                    ),
                ),
                onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RoutineDetailScreen(index: index)));
                }
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditRoutineScreen(index: 0, createRoutine: true))).then((_) => setState(() {}));
          },
          backgroundColor: Colors.purple[300],
          child: const Icon(Icons.add),
        )
      );
  }
}
