import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/ui/custom_text_form_field.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/widget/todo_list_logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailEC = TextEditingController();
  final _passowrdEC = TextEditingController();
  final _confirmaPasswordEC = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<RegisterController>().addListener(() {
      final controller = context.read<RegisterController>();

      var sucess = controller.sucess;
      var error = controller.error;

      if (sucess) {
        Navigator.of(context).pop();
      } else if (error != null && error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passowrdEC.dispose();
    _confirmaPasswordEC.dispose();

    // context.read<RegisterController>().removeListener(() {});

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: ClipOval(
              child: Container(
                padding: const EdgeInsets.all(8),
                color: context.primaryColor.withAlpha(20),
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 20,
                  color: context.primaryColor,
                ),
              ),
            )),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Todo List',
              style: TextStyle(
                fontSize: 14,
                color: context.primaryColor,
              ),
            ),
            Text(
              'Cadastro',
              style: TextStyle(
                color: context.primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: TodoListLogo(),
                ),
                CustomTextFormField(
                  label: 'E-mail',
                  controller: _emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatório'),
                    Validatorless.email('E-mail inválido'),
                  ]),
                ),
                CustomTextFormField(
                  label: 'Senha',
                  obscureText: true,
                  controller: _passowrdEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha obrigatória'),
                    Validatorless.min(
                        6, 'Senha deve ter pelo menos 6 caracteres')
                  ]),
                ),
                CustomTextFormField(
                  label: 'Confirma Senha',
                  obscureText: true,
                  controller: _confirmaPasswordEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Confirmar Senha obrigatória'),
                    Validatorless.compare(
                        _passowrdEC, 'Senha diferente de confirma senha')
                  ]),
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      final formValid =
                          _formKey.currentState?.validate() ?? false;

                      if (formValid) {
                        final email = _emailEC.text;
                        final password = _passowrdEC.text;

                        context
                            .read<RegisterController>()
                            .registerUser(email, password);
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
