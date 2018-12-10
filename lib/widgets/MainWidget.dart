import 'package:movies_search/entities/Movie.dart';
import 'package:movies_search/repository/MoviesRepository.dart';
import 'package:flutter/material.dart';

class MainWidget extends StatefulWidget {
  final String title = "Movie DB";

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  final _repository = MoviesRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return FutureBuilder<Movie>(
            future: _repository.get(index),
            builder: (context, snapshot) {
              return _buildMovieCard(snapshot);
            });
      }),
    );
  }

  Widget _buildMovieCard(AsyncSnapshot<Movie> snapshot) {
    return new Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 8.0, right: 8.0),
        child: new Container(
            margin: EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: new Text(
                        snapshot.hasData ? snapshot.data.title : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0
                        )
                    ),
                  ),
                  snapshot.hasData
                      ?
                  Image.network(
                      snapshot.data.posterPath,
                      height: 500.0,
                      fit: BoxFit.fitWidth
                  )
                      :
                  new Container(height: 500.0)
                ]
            )
        )
    );
  }
}
