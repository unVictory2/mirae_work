import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
    State<StatefulWidget> createState() => _SettingsPageState();
}

  class _SettingsPageState extends State<SettingsPage> {
    final _formKey = GlobalKey<FormState>();
    bool _obscureText = true; // // 비번 안 보이게 해주는 역할, ***로.

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar (
        title : const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:Form(
          key: _formKey,
          // 위젯을 스크롤 할 수 있어야 함. (위젯이 키보드에 밀린다거나, 내용이 너무 길어서 밀린다거나 할 수 있음)
          child: Scrollbar (
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child : Column ( 
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            hintText : 'Enter your ID',
                            labelText : 'ID',
                          ),
                          onChanged: (value) {print(value);}, // 상태값을 받아서 사용할 수 있다.
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            hintText : 'Enter your password',
                            labelText : 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off), // _obscureText 상태에 따라 버튼 바꾸기
                              onPressed: () { // 비번 옆 아이콘 누를 경우, 비번 보이게 / ***로 보이게 토글
                                setState(() { // setStae는 내가 클릭할 때마다 강제 갱신함.
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          obscureText : _obscureText, // 비번 안 보이게 해주는 역할, ***로.
                          onChanged: (value) {print(value);}, // 상태값을 받아서 사용할 수 있다.
                        ),
                      ]
                    ]
                    ),
                  ),
                )
              ),
            ),
          )
        ),
      ),
    );
  }

}
