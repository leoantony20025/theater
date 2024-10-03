class Movie {
  String name;
  String description;
  String photo;
  String language;
  String url;
  String duration;
  String year;
  bool isMovie;

  Movie({
    required this.name,
    required this.description,
    required this.photo,
    required this.language,
    required this.url,
    required this.duration,
    required this.year,
    required this.isMovie,
  });

  // Convert a Movie into a Map. The keys must correspond to the names of the
  // fields in your JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'photo': photo,
      'language': language,
      'url': url,
      'duration': duration,
      'year': year,
      'isMovie': isMovie,
    };
  }

  // Convert a Map into a Movie. The keys must correspond to the names of the
  // fields in your JSON.
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['name'],
      description: json['description'],
      photo: json['photo'],
      language: json['language'],
      url: json['url'],
      duration: json['duration'],
      year: json['year'],
      isMovie: json['isMovie'],
    );
  }
}
