import 'package:flutter/material.dart';
import 'package:sqliteflutter/model/client_model.dart';
import 'package:sqliteflutter/db/database.dart';

class AddEditClient extends StatefulWidget {
  final bool edit;
  final Client client;

  AddEditClient(this.edit, {this.client})
  : assert(edit == true || client ==null);


  @override
  _AddEditClientState createState() => _AddEditClientState();
}

class _AddEditClientState extends State<AddEditClient> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {    
    super.initState();
    //if you press the button to edit it must pass to true, 
    //instantiate the name and phone in its respective controller, (link them to each controller)
    if(widget.edit == true){
      nameEditingController.text = widget.client.name;
      phoneEditingController.text = widget.client.phone;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.edit?"Edit Client":"Add client"),),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(
                  size: 300,
                ),
                //if it is new record, it asks to enter data, : but it paints the data brought in the item
                textFormField(nameEditingController, "Name", "Enter Name",
                Icons.person, widget.edit ? widget.client.name : "name"),
                textFormFieldPhone(phoneEditingController, "Phone", "Enter phone", 
                Icons.person, widget.edit ? widget.client.phone : "phone",),
                
                RaisedButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text('Save',
                    style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.white
                  ),                  
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState.validate()){
                        Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data'))
                        );
                      }else if (widget.edit == true) {
                        ClientDatabaseProvider.db.updateClient(new Client(
                          name: nameEditingController.text,
                          phone: phoneEditingController.text,
                          id: widget.client.id ));
                          Navigator.pop(context);
                      } else {
                        await ClientDatabaseProvider.db.addClientToDatabase(new Client(
                          name: nameEditingController.text,
                          phone: phoneEditingController.text                          
                        ));
                        Navigator.pop(context);
                      }
                    },
                )                
              ],
            ),
          ),
        ),
      ),
  
    );
  }

  textFormField(TextEditingController t, String label, String hint,
    IconData iconData, String initialValue) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 10,
        ),
        child: TextFormField(
          validator: (value){
            if (value.isEmpty) {
              return 'Please enter some text';
            }
          },
          controller: t,
          //keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            prefixIcon: Icon(iconData),            
            hintText: label,
            border: 
              OutlineInputBorder(borderRadius: BorderRadius.circular(10))
          ),
        ),
      );
    }

    textFormFieldPhone(TextEditingController t, String label, String hint,
    IconData iconData, String initialValue) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 10,
        ),
        child: TextFormField(
          validator: (value){
            if (value.isEmpty) {
              return 'Please enter some text';
            }
          },
          controller: t,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            prefixIcon: Icon(iconData),            
            hintText: label,
            border: 
              OutlineInputBorder(borderRadius: BorderRadius.circular(10))
          ),
        ),
      );
    }

}