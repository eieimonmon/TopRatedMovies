import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterthemoviedb/moviedb.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: TheMovieDb(),
    );
  }
}
class TheMovieDb extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TheMovieDbState();
    throw UnimplementedError();
  }

}
class TheMovieDbState extends State<TheMovieDb>{
  var url = 'https://api.themoviedb.org/3/movie/top_rated?api_key=25bbf11781e6e6277f75651ecbe8c85b';
  MovieDb movieDb;

  @override
  void initState(){
    super.initState();
    fectchData();
  }

  fectchData() async{
    var data = await http.get(url);
    var jsonData = jsonDecode(data.body);

    movieDb = MovieDb.fromJson(jsonData);
    print(movieDb.toJson());

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Top Rated Movies'),
          backgroundColor: Colors.red,
        ),
        body: movieDb == null
            ?Center(
          child: CircularProgressIndicator(),
        ):GridView.count(crossAxisCount: 2,
          children:
          movieDb.movies.map((movie) => Padding(
            padding: EdgeInsets.all(1.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                   builder: (context)=> new MoviesDetail(result: movie,)

                ));
              },
              child: Hero(
                tag: movie.posterPath,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        child: Image.network("https://image.tmdb.org/t/p/w500/" +
                            movie.posterPath,
                          width: 150,
                          height: 140,),
                      ),
                      Text(
                        movie.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
          ).toList(),
        )
    );
    throw UnimplementedError();
  }
}

class MoviesDetail extends StatelessWidget{
  final Results result;

  MoviesDetail({this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Stack(
                children: [
                  Container(
                    height: 300.0,
                    width: 350.0,
                    child: Image.network(
                        "https://image.tmdb.org/t/p/w200${result.posterPath}",
                        fit: BoxFit.fill),
                  ),
                  AppBar(
                    backgroundColor: Colors.transparent,
                    leading: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios)),
                    elevation: 0,
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Text(
                        result.title,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                            wordSpacing: 0.6),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rating: "+
                              this.result.voteAverage.toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            result.releaseDate == null
                                ? 'Unknown'
                                :"Date:" +result.releaseDate,
                            style: TextStyle(color: Colors.grey),
                          ),

                        ],
                      ),
                      SizedBox(height: 20.0),
                      Align(
                        child: Text(
                          result.overview,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              wordSpacing: 0.3),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  ))
            ]),
          )),
    );
    throw UnimplementedError();
  }
}



