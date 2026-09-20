import 'package:flutter/material.dart';

// --- THEME NOTIFIER ---
// We create this outside the classes so it can be accessed globally.
// It holds the current theme mode (Light or Dark).
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const ShowcaseApp());
}

class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder listens to the themeNotifier and rebuilds 
    // the MaterialApp whenever the value changes.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          title: 'Flutter Showcase',
          debugShowCheckedModeBanner: false,
          
          // --- THEMING ---
          themeMode: currentMode, // This tells Flutter which theme to use
          
          // Light Theme Definition
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, 
              brightness: Brightness.light,
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              bodyMedium: TextStyle(fontSize: 16),
            ),
          ),
          
          // Dark Theme Definition
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, 
              brightness: Brightness.dark,
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              bodyMedium: TextStyle(fontSize: 16),
            ),
          ),
          
          home: const LoginPage(),
        );
      },
    );
  }
}

// --- LOGIN PAGE ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 100, color: Colors.deepPurple),
                const SizedBox(height: 20),
                Text('Welcome Back', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter username' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) => value!.length < 6 ? 'Password too short' : null,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- MAIN DASHBOARD ---
class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Workspace'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Todo', icon: Icon(Icons.list)),
              Tab(text: 'Gallery', icon: Icon(Icons.grid_view)),
              Tab(text: 'Profile', icon: Icon(Icons.person)),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'settings') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                } else if (value == 'logout') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'settings', child: Text('Settings')),
                const PopupMenuItem(value: 'logout', child: Text('Logout')),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.deepPurple),
                child: Text('App Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                },
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TodoListPage(),
            GalleryGridPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}

// --- SETTINGS PAGE ---
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  double _fontSize = 14.0;
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];

  @override
  Widget build(BuildContext context) {
    // Use ValueListenableBuilder here too, so the switch updates 
    // its visual state immediately when the theme changes.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('General', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              ),
              SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Receive alerts for new tasks'),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() => _notificationsEnabled = value);
                },
              ),
              // --- DARK MODE TOGGLE ---
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Switch to a dark theme'),
                value: currentMode == ThemeMode.dark,
                onChanged: (bool value) {
                  // Update the global notifier instead of local state
                  themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Font Size: ${_fontSize.toInt()}'),
                    Slider(
                      value: _fontSize,
                      min: 12.0,
                      max: 24.0,
                      onChanged: (double value) {
                        setState(() => _fontSize = value);
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Language'),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  onChanged: (String? newValue) {
                    setState(() => _selectedLanguage = newValue!);
                  },
                  items: _languages.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- TODO LIST, GALLERY, and PROFILE (Keep the same as previous code) ---
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}
class _TodoListPageState extends State<TodoListPage> {
  final List<String> _tasks = ['Learn Flutter Widgets', 'Build a Grid', 'Master Theming'];
  final _taskController = TextEditingController();
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() => _tasks.add(_taskController.text));
      _taskController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(hintText: 'New task...'),
                ),
              ),
              IconButton(onPressed: _addTask, icon: const Icon(Icons.add_circle, size: 40)),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_tasks[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _tasks.removeAt(index)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class GalleryGridPage extends StatelessWidget {
  const GalleryGridPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        crossAxisSpacing: 10, 
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network('https://picsum.photos/200?random=$index', fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 20),
          const Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text('Full-stack Developer', style: TextStyle(color: Colors.grey)),
          const Divider(height: 40),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ProfileStat(label: 'Posts', value: '120'),
              ProfileStat(label: 'Followers', value: '1.2k'),
              ProfileStat(label: 'Following', value: '450'),
            ],
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Bio', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          const Text(
            'Flutter enthusiast and UI designer. I love building beautiful apps with Material 3.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
class ProfileStat extends StatelessWidget {
  final String label, value;
  const ProfileStat({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}
