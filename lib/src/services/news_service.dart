import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _URL_NEWS = "https://newsapi.org/v2";
final _APIKEY = "4ca5f15a0a6d4fe19b6b62f812233309";

class NewsService with ChangeNotifier{
  List<Article> headlines = [];
  String _selectCategory = 'business';
  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology')
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService(){
    this.getTopHeadlines();
    categories.forEach((item){
      this.categoryArticles[item.name] = new List();
    });
  }

  get selectCategory => this._selectCategory;

  set selectCategory(String valor){
    this._selectCategory = valor;
    this.getArticlesByCategory(valor);
    notifyListeners();
  }

  List<Article> get getArticulosCategoriasSeleccionada => this.categoryArticles[this.selectCategory];

  getTopHeadlines()async{
    final url = "$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=mx";

    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);
    
    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category)async{
    if(this.categoryArticles[category].length > 0){
      return this.categoryArticles[category];
    }
    final url = '$_URL_NEWS/top-headlines?apikey=$_APIKEY&country=mx&category=$category';
    final resp = await http.get(url);
    final newResponse = newsResponseFromJson(resp.body);
    this.categoryArticles[category].addAll(newResponse.articles);
    notifyListeners();
  }
}