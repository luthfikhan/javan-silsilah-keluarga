import 'package:flutter/material.dart';
import 'package:javan_silsilah_keluarga/components/primary_button.dart';
import 'package:javan_silsilah_keluarga/db/database_helper.dart';
import 'package:javan_silsilah_keluarga/model/user_model.dart';
import 'package:javan_silsilah_keluarga/view/bagan_view.dart';
import 'package:javan_silsilah_keluarga/view/children_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserModel _user;
  DatabaseHelper _databaseHelper;

  _getUser() async {
    _user = await _databaseHelper.getUserDetail(1);
    setState(() {});
  }

  @override
  void initState() {
    _databaseHelper = DatabaseHelper();
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat datang ${_user.name}'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              buttonText: 'Daftar Keluarga',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return ChildrenView();
                }));
              },
            ),
            Padding(padding: EdgeInsets.only(top: 16)),
            PrimaryButton(
              buttonText: 'Bagan Keluarga',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return BaganView();
                }));
              },
            )
          ],
        )),
      ),
    );
  }
}
