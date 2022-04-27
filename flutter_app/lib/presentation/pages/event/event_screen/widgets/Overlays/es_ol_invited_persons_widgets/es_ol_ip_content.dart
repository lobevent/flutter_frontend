import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/core_widgets_stylings_text_with_icon.dart';

class InvitedPersonsContent extends StatelessWidget {
  const InvitedPersonsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child:
      Scaffold(
          appBar: TabBar(tabs: [
              Tab(child: TextWithIcon(text: "Invited", icon: Icons.person,)),
              Tab(child: TextWithIcon(text: "Invited", icon: Icons.person,)),
              Tab(child: TextWithIcon(text: "Invited", icon: Icons.person,)),
            ],
          ),
        body: TabBarView(children: [
          InvitedPersons(),
          AttendingPersons(),
          NotAttendingPersons()
        ],
        ),
      )
    );
  }


  Widget InvitedPersons(){
    return Text("tester1");
  }

  Widget AttendingPersons(){
    return Text("tester2");
  }

  Widget NotAttendingPersons(){
    return Text("tester3");
  }



}
