import 'package:ciao/task_model.dart';
import 'package:ciao/people_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 46, 178, 150)),
      ),
      home: AnimatedSplashScreen(
        splashIconSize: 200,
        duration: 3500,
        splash: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo con animazione
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: const Color.fromARGB(255, 200, 224, 217),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.checklist_rounded,
                    size: 60,
                    color: Color.fromARGB(255, 200, 224, 217),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Titolo principale
                const Text(
                  'My To Do List',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                // Sottotitolo
                Text(
                  'Organizza i tuoi compiti',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 200, 224, 217),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32)
              ],
            ),
          ),
        ),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,
        backgroundColor: const Color.fromARGB(255, 13, 107, 88),
        nextScreen: MyHomePage(title: 'My To Do List'),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

 
  List<TaskModel> taskList = [];
  List<TaskModel> searchQuery = [];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController taskTextEditingController = TextEditingController();
  String currentScreen = 'home'; // 'home' o 'people' o 'settings'

  @override
  void initState() {
    super.initState();
    searchQuery = List.from(taskList);
    searchController.addListener(_updateSearch);
  }

  @override
  void dispose() {
    searchController.dispose();
    taskTextEditingController.dispose();
    super.dispose();
  }

  void createTask({required TaskModel task}) {
    setState(() {
      taskList.add(task);
      _updateSearch();
    });
  }

  void updateTask({required String taskId, required TaskModel updatedTask}) {
    final taskIndex = taskList.indexWhere((task) => task.id == taskId);
    setState(() {
      taskList[taskIndex] = updatedTask;
      _updateSearch();
    });
  }

  void deleteTask({required String taskId}) {
    setState(() {
      taskList.removeWhere((task) => task.id == taskId);
      _updateSearch();
    });
  }

  void _updateSearch() {
    final query = searchController.text;
    setState(() {
      if (query.isEmpty) {
        searchQuery = List.from(taskList);
      } else {
        searchQuery = taskList
            .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 107, 88),
        elevation: 8,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My To Do List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Color.fromARGB(255, 200, 224, 217),
                    fontFamily: 'Roboto'
                  ),
                ),
                Text(
                  '${searchQuery.length} task',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 200, 224, 217),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 46, 178, 150),
                    Color.fromARGB(255, 13, 107, 88),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'FlutterDev',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'flutterdev@app.com',
                    style: TextStyle(
                      color: Color.fromARGB(255, 200, 224, 217),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Color.fromARGB(255, 13, 107, 88),
              ),
              title: const Text('Home'),
              selected: currentScreen == 'home',
              selectedTileColor: const Color.fromARGB(255, 240, 248, 245),
              onTap: () {
                setState(() {
                  currentScreen = 'home';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.people,
                color: Color.fromARGB(255, 13, 107, 88),
              ),
              title: const Text('Persone'),
              selected: currentScreen == 'people',
              selectedTileColor: const Color.fromARGB(255, 240, 248, 245),
              onTap: () {
                setState(() {
                  currentScreen = 'people';
                });
                Navigator.pop(context);
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 200, 200, 200),
              height: 20,
            ),
          ],
        ),
      ),
      body: currentScreen == 'home'
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 240, 248, 245),
                    Color.fromARGB(255, 225, 240, 237),
                  ],
                ),
              ),
              child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  // Search Task
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Cerca i tuoi task...',
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 130, 130, 130),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 13, 107, 88),
                        ),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  _updateSearch();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onChanged: (value) {
                        setState(() {});
                        _updateSearch();
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Sezione Task
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '✓ I Miei Task (${searchQuery.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 13, 107, 88),
                  ),
                ),
              ),
            ),
            Expanded(
              child: searchQuery.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemCount: searchQuery.length,
                      itemBuilder: (context, index) {
                        final TaskModel task = searchQuery[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tileColor: Colors.white,
                            title: Text(
                              task.title,
                              style: TextStyle(
                                color: task.isCompleted 
                                    ? const Color.fromARGB(255, 150, 150, 150)
                                    : Colors.black87,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                deleteTask(taskId: task.id);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Color.fromARGB(255, 220, 60, 60),
                                size: 24.0,
                              ),
                            ),
                            leading: Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                activeColor: const Color.fromARGB(255, 13, 107, 88),
                                checkColor: Colors.white,
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 13, 107, 88),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                value: task.isCompleted,
                                onChanged: (value) {
                                  setState(() {
                                    task.isCompleted = value!;
                                    _updateSearch();
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_outlined,
                              size: 64,
                              color: const Color.fromARGB(255, 13, 107, 88).withOpacity(0.2),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Nessun task trovato',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color.fromARGB(255, 100, 100, 100),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Aggiungine uno con il pulsante + sotto',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 130, 130, 130),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            
          ],
        ),
            )
              : const PeopleScreen(),
      floatingActionButton: currentScreen == 'home'
          ? FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        color: Color.fromARGB(255, 13, 107, 88),
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Aggiungi un nuovo task',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 13, 107, 88),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: taskTextEditingController,
                          decoration: InputDecoration(
                            hintText: 'Descrivi il tuo task',
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 150, 150, 150),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 13, 107, 88),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 46, 178, 150),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          maxLines: 3,
                          minLines: 2,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                                foregroundColor: const Color.fromARGB(255, 100, 100, 100),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancella',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 13, 107, 88),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 4,
                              ),
                              onPressed: () {
                                if (taskTextEditingController.text.isNotEmpty) {
                                  final TaskModel newTask = TaskModel(
                                    id: DateTime.now().toString(),
                                    title: taskTextEditingController.text,
                                  );
                                  createTask(task: newTask);
                                  taskTextEditingController.clear();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text(
                                'Salva',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        tooltip: 'Aggiungi Task',
        backgroundColor: const Color.fromARGB(255, 13, 107, 88),
        elevation: 8,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Nuovo Task',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
          )
          : null,
    );
  }
 
}


  
