import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:javan_silsilah_keluarga/db/database_helper.dart';
import 'package:javan_silsilah_keluarga/model/user_model.dart';

class BaganView extends StatefulWidget {
  @override
  _BaganViewState createState() => _BaganViewState();
}

class _BaganViewState extends State<BaganView> {
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  final Graph graph = Graph();
  DatabaseHelper _databaseHelper;
  bool _isLoading = true;
  List<UserModel> _users = [];

  _initGraph() async {
    _users = await _databaseHelper.getAllData();
    List<Node> nodes = [];

    for (var i = 0; i < _users.length; i++) {
      final Node node = Node(getNodeText(
        _users[i].name,
      ));
      nodes.add(node);
    }

    for (var i = 0; i < _users.length; i++) {
      for (var j = 0; j < _users.length; j++) {
        if (_users[i].id == _users[j].ortuId) {
          graph.addEdge(nodes[i], nodes[j]);
        }
      }
    }

    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    _isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    _databaseHelper = DatabaseHelper();
    _initGraph();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(builder: (context) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (_users.length <= 1) {
            return Center(
                child: Text(
              'Masukan data keluarga anda\nterlebih dahulu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ));
          }
          return InteractiveViewer(
            constrained: false,
            boundaryMargin: EdgeInsets.all(80),
            child: GraphView(
              graph: graph,
              algorithm:
                  BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
            ),
          );
        }),
      ),
    );
  }

  Widget getNodeText(String text) {
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Colors.blue[100], spreadRadius: 1),
          ],
        ),
        child: Text("$text"));
  }
}
