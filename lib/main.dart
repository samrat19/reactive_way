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
      home: InitialApp(),
    );
  }
}

class InitialApp extends StatelessWidget with GetItMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          height: 100,
          minWidth: 200,
          child: Text('Get News',style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),),
          onPressed: (){
            get<Manager>().loadData!.execute('in');
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_)=>HomeScreen(),
            ));
          }
        ),
      ),
    );
  }
}


class HomeScreen extends StatelessWidget with GetItMixin{
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


/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>Manager(service: Service()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Manager manager;

  @override
  void initState() {
    super.initState();
    manager = BlocProvider.of<Manager>(context);
    manager.add(GetData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocListener<Manager,DataState>(
          listener: (context,state){
            if (state is HaveError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<Manager,DataState>(
            builder: (context,state){
              if(state is LoadingState){
                return CircularProgressIndicator();
              }else if(state is InitialState){
                return Text('Getting Data');
              }else if(state is HaveError){
                return Text('Error occurred');
              }else if(state is HaveData){
                return Text(state.data.articles[0].title);
              }else{
                return Text('Unidentified Error');
              }
            },
          ),
        ),
      ),
    );
  }
}*/

