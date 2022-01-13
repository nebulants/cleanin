import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanin/models/home.dart';

class AddHomeForm extends StatefulWidget {
  const AddHomeForm({Key? key}) : super(key: key);

  @override
  State createState() => _AddHomeFormState();
}

class _AddHomeFormState extends State<AddHomeForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _saveHome() {
    Home home = Home(
        name: _formKey.currentState!.value["name"],
        address: _formKey.currentState!.value["address"],
        description: _formKey.currentState!.value["description"],
        nextCheckIn: DateTime.now(),
        cleaningState: _formKey.currentState!.value["cleaningState"],
        icalPermalink: _formKey.currentState!.value["icalPermalink"]
    );
    FirebaseFirestore.instance.collection("homes").add(home.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context)
                  ]),
                ),
                FormBuilderTextField(
                  name: 'address',
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context)
                  ]),
                ),
                FormBuilderTextField(
                  name: 'description',
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context)
                  ]),
                ),
                FormBuilderTextField(
                  name: 'icalPermalink',
                  decoration: const InputDecoration(labelText: 'Exported calendar url'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context)
                  ]),
                ),
                FormBuilderSwitch(
                  title: const Text('Is the house currently clean?'),
                  name: 'cleaningState',
                  initialValue: true,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).colorScheme.secondary,
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            debugPrint(_formKey.currentState!.value.toString());
                          } else {
                            debugPrint("validation failed");
                          }
                          // _saveHome();
                          _saveHome();
                          Navigator.of(context).pop();
                        },
                    )


                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}