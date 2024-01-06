import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _focusPrice = FocusNode();
  final _focusDescription = FocusNode();
  final _focusImageUrl = FocusNode();
  final TextEditingController _urlImageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusImageUrl.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)!.settings.arguments;
      
      if (arg != null) {
        final Product product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _urlImageController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusPrice.dispose();
    _focusDescription.dispose();
    _focusImageUrl.removeListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  Future<void> _submiteForm() async {
    final isvalidate = _formKey.currentState!.validate();
    if (!isvalidate) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {isLoading = true;});

    try {
      await Provider.of<ProductList>(context, listen: false).saveProduct(_formData);
      Navigator.pop(context);
    } catch(e) {
      await showDialog(
        context: context, 
        builder: (_) => AlertDialog(
          title: const Text('Ocorreu um erro'),
          content: const Text('Não foi possivel cadastrar o produto. Tente novamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: const Text('Ok'),
            )
          ],
        ),
      );
    } finally {
      setState(() {isLoading = false;});
      
    }
    
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.parse(url).hasAbsolutePath;
    bool endsWithFile = 
      url.toLowerCase().endsWith('.png') 
      || url.toLowerCase().endsWith('.jpg') 
      || url.toLowerCase().endsWith('.jpeg');

    return (isValidUrl && endsWithFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Formulário de Produto',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _submiteForm, 
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: isLoading 
      ? const Center(child: CircularProgressIndicator(),) 
      : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                initialValue: (_formData['name'] ?? '').toString(),
                decoration: const InputDecoration(
                  label: Text('Nome')
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_focusPrice);
                },
                onSaved: (name) => _formData['name'] = (name ?? ''),
                validator: (_name) {
                  final String name = _name ?? '';
                  if (name.trim().isEmpty) {
                    return 'Nome obrigatório';
                  }

                  if (name.trim().length < 3) {
                    return "Minimo 3 letras";
                  }

                  return null;
                },
              ),

              TextFormField(
                focusNode: _focusPrice,
                initialValue:  (_formData['price'] ?? '').toString(),
                decoration: const InputDecoration(
                  label: Text('Preço')
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_focusDescription);
                },
                onSaved: (price) => _formData['price'] = double.parse(price ?? '0'),
                validator: (_price) {
                  final String priceString = _price!;
                  final price = double.tryParse(priceString) ?? -1;
                  if (price < 0) {
                    return 'Digite um preço válido';
                  }
                  return null;

                },
              ),

              TextFormField(
                focusNode: _focusDescription,
                initialValue:  (_formData['description'] ?? '').toString(),
                decoration: const InputDecoration(
                  label: Text('Descrição')
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (description) => _formData['description'] = (description ?? ''),
                validator: (_description) {
                  final String description = _description ?? '';
                  if (description.trim().isEmpty) {
                    return 'Descrição obrigatório';
                  }

                  if (description.trim().length < 3) {
                    return "Minimo 3 letras";
                  }

                  return null;
                },
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _urlImageController,
                      focusNode: _focusImageUrl,
                      decoration: const InputDecoration(
                        label: Text('Url da imagem')
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true
                      ),
                      textInputAction: TextInputAction.done,
                      onSaved: (imageUrl) => _formData['imageUrl'] = (imageUrl ?? ''),
                      onFieldSubmitted: (_) => _submiteForm,
                      validator: (_url) {
                        final String url = _url ?? '';
                        if (!isValidImageUrl(url)) {
                          return 'Insira uma url válida';
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: _urlImageController.text.isEmpty 
                    ? const Text('Insira uma url')
                    : Image.network(_urlImageController.text)
                  )
                ],
              ),

            ],
          )
        ),
      ),
    );
  }
}