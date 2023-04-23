import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sample/pages/common/colors.dart';
import 'package:sample/pages/top.dart';

class Header extends StatelessWidget with PreferredSizeWidget {
  final AppBar appBar;
  final User? user;
  const Header(this.appBar, this.user);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextButton(
        child: Text(
          '今日の漢字',
          style: GoogleFonts.yujiMai(color: colorWhite, fontSize: 32),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TopPage(user)));
        },
      ),
      backgroundColor: colorTriad1,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
