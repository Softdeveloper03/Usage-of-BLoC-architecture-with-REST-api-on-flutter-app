import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frnt/model/model.dart';
import 'package:frnt/repository/repository.dart';
import 'bloc/name_bloc.dart';
import 'provider/name_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) =>
            NameBloc(NameRepository(NameProvider()))..add(FetchNames()),
        child: NameScreen(),
      ),
    );
  }
}

class NameScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NameBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Name CRUD')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                bloc.add(CreateName(_nameController.text));
                _nameController.clear();
              }
            },
            child: Text('Add Name'),
          ),
          Expanded(
            child: BlocBuilder<NameBloc, NameState>(
              builder: (context, state) {
                if (state is NameLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is NameLoaded) {
                  return ListView.builder(
                    itemCount: state.names.length,
                    itemBuilder: (context, index) {
                      final name = state.names[index];
                      return ListTile(
                        title: Text(name.name),
                        leading: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showUpdateDialog(context, bloc, name);
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            bloc.add(DeleteName(name.id));
                          },
                        ),
                      );
                    },
                  );
                } else if (state is NameError) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text('No data'));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, NameBloc bloc, NameModel name) {
    final TextEditingController _editController =
        TextEditingController(text: name.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(
              labelText: 'Enter new name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final updatedName = _editController.text.trim();
                if (updatedName.isNotEmpty) {
                  bloc.add(UpdateName(name.id, updatedName));
                }
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
