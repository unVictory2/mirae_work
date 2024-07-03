import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
    State<StatefulWidget> createState() => _SettingsPageState();
}

  class _SettingsPageState extends State<SettingsPage> {
    final _formKey = GlobalKey<FormState>();
    bool _obscureText = true; // // 비번 안 보이게 해주는 역할, ***로.
    double _sliderValue = 0; //슬라이더 값 저장할 변수
    bool checked = false; // checkbox state
    bool switchValue = false;
    String email = '';

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
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            icon: Icon(Icons.email),
                            hintText: 'Enter your email',
                            labelText: 'Email',
                          ),
                          maxLength: 300,
                          maxLines: 5,
                          //글자 쓰면 함수 발동. 입력값이 value로 들어오고, 중괄호 사이에 처리 방식 입력
                          onChanged: (value) {
                            email = value;
                            // If the email has to be shown somewhere else, setState needs to be used. By using setState we order the screen to be refreshed. But email is not being shown anywhere else thus no setState required.
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children : [
                            Row( //Row가 큰 의미는 없으나 옆에 뭐 더 넣을 일 있을 때 확장성을 대비한듯 하다고 하심
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('슬라이드바', 
                                style: Theme.of(context).textTheme.titleMedium,),
                              ],
                            ),
                            Text('${_sliderValue.toInt()}'),
                            Slider(
                              min:0,
                              max:500,
                              divisions: 500,
                              value: _sliderValue,
                              onChanged: (value) {
                                setState(() {
                                  // the _sliderValue is changing without setState. But _sliderValue is being used in Text('${_sliderValue.toInt()}'), so we need to use setState on this case.
                                  _sliderValue = value; // change the current slider value to the new value
                                });
                              },
                            ),
                          ],
                        ),
                        //column goes from top to bottom, while row goes from left to right
                        Row(
                          // setting up the follwing two are mendatory if you use either row or column
                          mainAxisAlignment: MainAxisAlignment. start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value : checked,
                              //value : whether it's checked or not
                              onChanged: (value) {
                                // we intend to updatethe Text below on whether checkbox is checked or not, so we use setState.
                                setState(() {
                                  checked = value!;
                                });
                              },
                            ),
                            // Ternary operator = 삼항연산자. get used to using ternary operator, instead of using "if" every time.
                            Text((checked)? '체크됨' : '체크안됨'),
                          ],
                        ),
                        Row(
                          //switch is almost the same as checkbox.
                          mainAxisAlignment: MainAxisAlignment. start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Switch(value: switchValue, onChanged: (value) {
                              setState(() {
                                switchValue = value;
                              });
                            }
                            ),
                            Text((switchValue)? 'on' : 'off'),
                          ],
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
