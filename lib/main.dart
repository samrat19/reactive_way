import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:reactive_way/manager.dart';
import 'package:reactive_way/service.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

void setupServiceLocator(){
  GetIt.I.registerLazySingleton<Service>(() => Service());
  GetIt.I.registerLazySingleton<Manager>(() => Manager());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}


class HomeScreen extends StatefulWidget with GetItStatefulWidgetMixin{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with GetItStateMixin{

  @override
  void initState() {
    get<Manager>().loadData!.execute({'countryCode':'in','category':'sports'});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final isRunning = watchX((Manager manager) => manager.loadData!.isExecuting);

    return Scaffold(
      body: Stack(
        children: [
          ShowData(),
          if(isRunning == true)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}



class ShowData extends StatelessWidget with GetItMixin{
  ShowData();
  @override
  Widget build(BuildContext context) {
    final data = watchX((Manager manager) => manager.loadData!);
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_,index)=>Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(data[index].title!),
        ),
      ),
    );
  }
}