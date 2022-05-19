import 'package:flutter/material.dart';
import 'package:glucose_predictor/Model/ManualIngInput.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ManualPageView extends StatefulWidget {
  const ManualPageView({Key? key}) : super(key: key);

  @override
  State<ManualPageView> createState() => _ManualPageView();
}

class _ManualPageView extends State<ManualPageView> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final ManualInput manualInput = ManualInput("", List<Ing>.empty(growable: true),);

  @override
  void initState() {
    super.initState();

    manualInput.items.add(Ing("", 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Quick Saved",
              style: TextStyle(color: Color(0xff909090))),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _buildInputView());
  }

  Widget _buildInputView() {
    return Form(
      key: globalFormKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: FormHelper.inputFieldWidgetWithLabel(
                  context,
                  "${const Icon(Icons.web)}",
                  "name",
                  "Food Name",
                      (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return 'User Name can\'t be empty.';
                    }

                    return null;
                  },
                      (onSavedVal) => {
                    manualInput.foodName = onSavedVal,
                  },
                  initialValue: manualInput.foodName,
                  obscureText: false,
                  borderFocusColor: Theme.of(context).primaryColor,
                  prefixIconColor: Theme.of(context).primaryColor,
                  borderColor: Theme.of(context).primaryColor,
                  borderRadius: 2,
                  paddingLeft: 0,
                  paddingRight: 0,
                  showPrefixIcon: false,
                  fontSize: 13,
                  labelFontSize: 13,
                  onChange: (val) {},
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Ingredient(s)",
                      textAlign: TextAlign.left,
                      style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  emailsContainerUI(),
                  Center(
                    child: FormHelper.submitButton(
                      "Save",
                          () async {
                        if (validateAndSave()) {
                          print(manualInput.toJson());
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailsContainerUI() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: manualInput.items.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Row(children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: emailUI(index),
              ),
            ]),
          ],
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Widget emailUI(index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: FormHelper.inputFieldWidget(
              context,
              "${const Icon(Icons.web)}",
              "ing_$index",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Ingredient ${index + 1} can\'t be empty.';
                }

                return null;
              },
                  (onSavedVal) => {
                manualInput.items[index].ingName = onSavedVal,
              },
              initialValue: manualInput.items[index].ingName,
              obscureText: false,
              borderFocusColor: Theme.of(context).primaryColor,
              prefixIconColor: Theme.of(context).primaryColor,
              borderColor: Theme.of(context).primaryColor,
              borderRadius: 2,
              paddingLeft: 0,
              paddingRight: 0,
              showPrefixIcon: false,
              fontSize: 13,
              onChange: (val) {},
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            flex: 1,
            child: FormHelper.inputFieldWidget(
              context,
              "${const Icon(Icons.web)}",
              "quantity_$index",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Quantity ${index + 1} can\'t be empty.';
                }
                return null;
              },
                  (onSavedVal) => {
                manualInput.items[index].quantity = int.parse(onSavedVal),
              },
              initialValue: "${manualInput.items[index].quantity}",
              obscureText: false,
              borderFocusColor: Theme.of(context).primaryColor,
              prefixIconColor: Theme.of(context).primaryColor,
              borderColor: Theme.of(context).primaryColor,
              borderRadius: 2,
              paddingLeft: 0,
              paddingRight: 0,
              showPrefixIcon: false,
              fontSize: 13,
              onChange: (val) {},
            ),
          ),
          Visibility(
            child: SizedBox(
              width: 35,
              child: IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.green,
                ),
                onPressed: () {
                  addEmailControl();
                },
              ),
            ),
            visible: index == manualInput.items.length - 1,
          ),
          Visibility(
            child: SizedBox(
              width: 35,
              child: IconButton(
                icon: const Icon(
                  Icons.remove_circle,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  removeEmailControl(index);
                },
              ),
            ),
            visible: index > 0,
          )
        ],
      ),
    );
  }

  void addEmailControl() {
    setState(() {
      manualInput.items.add(Ing("", 0));
    });
  }

  void removeEmailControl(index) {
    setState(() {
      if (manualInput.items.length > 1) {
        manualInput.items.removeAt(index);
      }
    });
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

Widget addIngField() {
  return Scaffold(
      body: SizedBox(
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                child: TextField(
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.lightGreen,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: "Enter Ingredient",
                    )),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                child: TextField(
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelText: "Quantity")),
              ),
            ),
          ],
        ),
      ));
}