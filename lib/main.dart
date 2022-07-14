// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MovieApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

class Movie {
  final String? imdbID;
  final String? poster;
  final String? title;
  final String? year;

  Movie({
    required this.imdbID,
    required this.poster,
    required this.title,
    required this.year,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json['imdbID'],
      poster: json['Poster'],
      title: json['Title'],
      year: json['Year'],
    );
  }
}

String apiKey = 'f86b29ae';
String here = '';
List movies = [];

class MovieApp extends StatefulWidget {
  const MovieApp({Key? key}) : super(key: key);

  @override
  State<MovieApp> createState() => _MovieAppState();
}

Future<List<Movie>> fetchMovies() async {
  final movieData = await http.get(
    Uri.parse('http://www.omdbapi.com/?s=$here&apikey=$apiKey'),
  );

  final data = jsonDecode(movieData.body);
  List list = data['Search'];
  return list.map((e) => Movie.fromJson(e)).toList();
}

class _MovieAppState extends State<MovieApp> {
  // TextEditingController here = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  void loadMovies() async {
    final _movies = await fetchMovies();
    setState(() {
      movies = _movies;
    });
  }

  TextEditingController searchInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GoogleFonts.config;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Find Movies',
                    style: GoogleFonts.lexend(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 20, 70, 15),
                  child: TextField(
                    controller: searchInput,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    cursorColor: Colors.white,
                    //cursorHeight: 20.0,
                    onSubmitted: (fieldInput) {
                      here = fieldInput;
                      print(here);
                      loadMovies();
                      setState(() {});
                    },
                    style: GoogleFonts.lexend(
                      fontSize: 21,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      //enabledBorder: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0.6, color: Colors.white38),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      //focusedBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.5, color: Colors.amber),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'type in a name',
                      labelStyle:
                          GoogleFonts.lexend(fontSize: 21, color: Colors.white),
                      hintStyle: GoogleFonts.lexend(
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          here = searchInput.text;
                          print(here);
                          loadMovies();
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.search,
                          size: 30,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ),
                ),
                here == ''
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [],
                        ),
                      )
                    : Expanded(
                        child: Container(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 350,
                            ),
                            shrinkWrap: true,
                            itemCount: movies.length,
                            itemBuilder: (context, index) {
                              final data = movies[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white38,
                                            blurRadius: 3,
                                            spreadRadius: 6.0,
                                          )
                                        ],
                                      ),
                                      height: 230,
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          data.poster as String,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        data.title as String,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lexend(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ],
            ),
          ),
          backgroundColor: Colors.black54,
        ),
      ),
    );
  }
}
