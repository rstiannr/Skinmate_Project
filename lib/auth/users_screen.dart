import 'package:flutter/material.dart';
import '../../database/database_helper.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _databaseHelper = DatabaseHelper();

  List<Map<String, dynamic>> _users = [];

  Future<void> _fetchUsers() async {
    final users = await _databaseHelper.getAllUsers();
    setState(() {
      _users = users;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Add user to the database
  Future<void> _addUser() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      await _databaseHelper.insertUserWithBasicInfo(name, email, password);
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _fetchUsers();
    }
  }

  Future<void> _getUserByEmail() async {
    final email = _emailController.text;
    final user = await _databaseHelper.getUserByEmail(email);

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User Found: ${user['email']}"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User Not Found"),
      ));
    }
  }

  Future<void> _editUser(int userId, Map<String, dynamic> user) async {
    _nameController.text = user['name'] ?? '';
    _emailController.text = user['email'] ?? '';
    _passwordController.text = user['password'] ?? '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final name = _nameController.text;
                final email = _emailController.text;
                final password = _passwordController.text;
                if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                  final updatedUser = {
                    'name': name,
                    'email': email,
                    'password': password,
                  };
                  await _databaseHelper.updateUser(userId, updatedUser);
                  Navigator.pop(context);
                  _fetchUsers();
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(int userId) async {
    await _databaseHelper.deleteUser(userId);
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Control Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addUser,
                  child: Text('Add User'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _getUserByEmail,
                  child: Text('Find User'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    title: Text(user['name'] ?? ''),
                    subtitle: Text('ID: ${user['users_id']} | Email: ${user['email']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editUser(user['users_id'], user);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteUser(user['users_id']);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
