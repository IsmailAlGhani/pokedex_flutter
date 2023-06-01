import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poke_app/model/data.dart';
import 'package:poke_app/screens/pokemon.dart';
import 'package:poke_app/widgets/loading_spinner.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dataModel = Provider.of<Data>(
        context,
        listen: false,
      );
      dataModel.fetchPage();
    });

    controller = AnimationController(
      duration: const Duration(
        seconds: 1,
      ),
      vsync: this,
    );
    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String urlImg(String id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: Consumer<Data>(
        builder: (context, data, child) {
          var isMore = data.isMore;
          var offset = data.offset;
          var limit = data.limit;
          if (data.loading && offset == 0 && data.pokemonList.isEmpty) {
            return const LoadingSpinner();
          }
          return NotificationListener(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                controller: _scrollController,
                children: [
                  for (var item in data.pokemonList) ...[
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.black87,
                          borderRadius:
                          BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: urlImg(item.id),
                            fit: BoxFit.cover,
                          ),
                          Text(item.name,style: GoogleFonts.poppins(fontStyle: FontStyle.normal, color: Colors.white70),)
                        ],
                      ),
                    ),
                  ],
                  if (data.loading) ...[const LoadingSpinner()]
                ],
              ),
            ),
            onNotification: (t) {
              if (t is ScrollEndNotification && isMore == true) {
                var triggerFetchMoreSize =
                    0.9 * _scrollController.position.maxScrollExtent;
                if (_scrollController.position.pixels >
                    triggerFetchMoreSize) {
                  data.fetchPage();
                }
                return true;
              }
              return false;
            },
          );
        },
      ),
    );
  }
}
