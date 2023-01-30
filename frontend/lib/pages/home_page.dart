import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/filmesseries.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class CatigoryW extends StatelessWidget {
  String image;
  String text;
  Color color;

  CatigoryW(
      {super.key,
      required this.image,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0x9F3D416E),
          ),
          child: Column(
            children: [
              Container(
                  width: 65,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(227, 255, 255, 255),
                  ),
                  child: Transform.scale(
                      scale: 0.6,
                      child: Image.asset(
                        image,
                      ))),
              const SizedBox(
                height: 0,
              ),
              Text(
                text,
                style: TextStyle(color: color, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        onTap: () {
          if (text == 'Filmes/Séries') {
            context.push('/filmesseries');
          }
          if (text == 'Livros') {
            context.push('/livros');
          }
          if (text == 'Música') {
            context.push('/musica');
          }
          if (text == 'Destinos de Viagens') {
            context.push('/viagens');
          }
          if (text == 'Jogos') {
            context.push('/jogos');
          }
          if (text == 'Receitas') {
            context.push('/receitas');
          }
        });
  }
}

class Paginaprincipal extends StatelessWidget {
  const Paginaprincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 0, 204, 255),
      bottomNavigationBar: Container(
        height: 54,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        color: Color.fromARGB(255, 2, 155, 175),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'images/calendaro.png',
                height: 25,
                width: 25,
              ),
              Image.asset(
                'images/dfinicoes.png',
                height: 25,
                width: 25,
              ),
              Image.asset(
                'images/pessoas.png',
                height: 25,
                width: 25,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Transform.rotate(
                origin: const Offset(30, -60),
                angle: 2.4,
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 75,
                    top: 40,
                  ),
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      colors: [
                        Color.fromARGB(255, 8, 151, 194),
                        Color.fromARGB(255, 6, 138, 190)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'jeKomendation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Escolha o tópico cujas recomendações gostaria de receber',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CatigoryW(
                                image: 'images/filmes e series.png',
                                text: 'Filmes/Séries',
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              CatigoryW(
                                image: 'images/livrps.png',
                                text: 'Livros',
                                color: const Color.fromARGB(255, 255, 255, 255),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CatigoryW(
                                image: 'images/musica.png',
                                text: 'Música',
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              CatigoryW(
                                image: 'images/viagem.png',
                                text: 'Destinos de Viagens',
                                color: const Color.fromARGB(255, 255, 255, 255),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CatigoryW(
                                image: 'images/jogos.png',
                                text: 'Jogos',
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              CatigoryW(
                                image: 'images/receitas.png',
                                text: 'Receitas',
                                color: const Color.fromARGB(255, 255, 255, 255),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WorkoutCubit {}

class BlocProvider {
  static(BuildContext context) {}
}
