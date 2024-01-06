import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/auth.dart';

class AuthForm extends StatefulWidget {
  AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

enum AuthMode {
  singup,
  login
}

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authData = {
    'email': '',
    'password': ''
  };
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passowordController = TextEditingController();
  bool isLoading = false;

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    

    if (!isValid) {
      return;
    }
    setState(() => isLoading = true);

    _formKey.currentState!.save();
    setState(() => isLoading = false);
    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      if (isLogin) {
        await auth.logIn(_authData['email']!, _authData['password']!);
      } else {
        await auth.signUp(_authData['email']!, _authData['password']!);
      }
    } on AuthException catch (error) {
      print(error.toString());
      _showErrorDialog(error.toString());
    }
    
  }

  _showErrorDialog(String msg) {
    return showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            child: const Text('Fechar'),
          )
        ],
      ),
    );
  }

  bool get isLogin => _authMode == AuthMode.login;
  bool get isSingup => _authMode == AuthMode.singup;

  void _switchAuthMode() {
    setState(() {_authMode = isLogin ? AuthMode.singup : AuthMode.login;});
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      child: Container(
        width: deviceSize.width * .75,
        height: isLogin ? 290 : 350,
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('E-mail')
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) {
                  _authData['email'] = email ?? '';
                },
                validator: (_email) {
                  final String email = _email ?? '';
                  if (email.isEmpty || !email.contains('@')) {
                    return 'Email inválido';
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Senha')
                ),
                obscureText: true,
                onSaved: (password) {
                  _authData['password'] = password ?? '';
                },
                controller: _passowordController,
                validator: (_password) {
                  final String password = _password ?? '';
                  if (password.trim().length < 5) {
                    return 'Senha inválida';
                  }
                },
              ),

              if (isSingup)
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Confirmar senha')
                ),
                obscureText: true,
                validator: (_password) {
                  final password = _password ?? '';
                  if (password != _passowordController.text) {
                    return 'As senhas não batem';
                  }
                },
              ),

              const SizedBox(height: 20,),

              isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(       
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.purple),
                  padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 8, horizontal: 25))
                ),
                onPressed: _submit, 
                child: Text(
                  _authMode == AuthMode.login ? 'Entrar' : 'Registrar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode, 
                child: Text(
                  isLogin
                  ? 'CRIAR UMA CONTA'
                  : 'NÃO POSSUI UMA CONTA?'
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}