import 'package:closet/Providers/Product.dart';
import 'package:closet/Providers/Product_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '\EditProductScreen';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final priceFocusNode = FocusNode();
  final DescriptionFocusNode = FocusNode();
  final imageFocusNode = FocusNode();
  final imageTextController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  @override
  void initState() {
    imageFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  var intitValue = {
    'title': '',
    'price': '',
    'ImageUrl': '',
    'Description': '',
  };

  var Isinit = true;
  @override
  void didChangeDependencies() {
    if (Isinit) {
      final ProductId = ModalRoute.of(context).settings.arguments == null
          ? "NULL"
          : ModalRoute.of(context).settings.arguments as String;
      if (ProductId != "NULL") {
        editedProduct =
            Provider.of<Product_Provider>(context).findbyid(ProductId);
        intitValue = {
          'title': editedProduct.title,
          'price': editedProduct.price.toString(),
          'Description': editedProduct.description,
          'ImageUrl': '',
        };
        imageTextController.text = editedProduct.imageUrl;
      }
    }
    Isinit = false;
    super.didChangeDependencies();
  }

  var IsLoading = false;
  Future<void> saveForm() async {
    IsLoading = true;
    final isvalid = _form.currentState.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState.save();
    if (editedProduct.id != null) {
      await Provider.of<Product_Provider>(context, listen: false)
          .UpdateProducts(editedProduct.id, editedProduct);
    } else {
      try {
        await Provider.of<Product_Provider>(context, listen: false)
            .addItems(editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An Error Occured"),
            content: Text('Something Went Wrong!'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Okay"))
            ],
          ),
        );
      } // finally {
      //  setState(() {
      //  IsLoading = false;
      //});
      //Navigator.of(context).pop();
      //}
    }
    setState(() {
      IsLoading = false;
    });
    Navigator.of(context).pop();

    //Navigator.of(context).pop();
  }

  @override
  void dispose() {
    imageFocusNode.removeListener(updateImageUrl);
    imageFocusNode.dispose();
    imageTextController.dispose();
    priceFocusNode.dispose();
    DescriptionFocusNode.dispose();
    super.dispose();
  }

  void updateImageUrl() {
    if (!imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        title: Text(
          'Edit Product',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        actions: [IconButton(onPressed: saveForm, icon: Icon(Icons.save))],
      ),
      body: IsLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: intitValue['title'],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: 'Title'),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(priceFocusNode);
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            id: editedProduct.id,
                            title: value,
                            description: editedProduct.description,
                            price: editedProduct.price,
                            imageUrl: editedProduct.imageUrl,
                            isFavourite: editedProduct.isFavourite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Provide title';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: intitValue['price'],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      focusNode: priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(DescriptionFocusNode);
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            id: editedProduct.id,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            price: double.parse(value),
                            imageUrl: editedProduct.imageUrl,
                            isFavourite: editedProduct.isFavourite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Provide Price";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please Enter Valid Price";
                        }
                        if (double.parse(value) <= 0) {
                          return "Price Must be Greater then Zero";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: intitValue['Description'],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: DescriptionFocusNode,
                      onSaved: (value) {
                        editedProduct = Product(
                            id: editedProduct.id,
                            title: editedProduct.title,
                            description: value,
                            price: editedProduct.price,
                            imageUrl: editedProduct.imageUrl,
                            isFavourite: editedProduct.isFavourite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Provide Description";
                        } else {
                          return null;
                        }
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor)),
                          child: imageTextController.text.isEmpty
                              ? Text("Enter Image Url")
                              : FittedBox(
                                  child: Image.network(
                                    imageTextController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "ImageUrl"),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: imageTextController,
                            focusNode: imageFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              saveForm();
                            },
                            onSaved: (value) {
                              editedProduct = Product(
                                  id: editedProduct.id,
                                  title: editedProduct.title,
                                  description: editedProduct.description,
                                  price: editedProduct.price,
                                  imageUrl: value,
                                  isFavourite: editedProduct.isFavourite);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Provide ImageUrl";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
