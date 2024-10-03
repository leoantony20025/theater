class Series {
  String name;
  String description;
  String photo;
  String language;
  String url;
  String duration;
  String year;

  Series({
    required this.name,
    required this.description,
    required this.photo,
    required this.language,
    required this.url,
    required this.duration,
    required this.year,
  });

  // Convert a Series into a Map. The keys must correspond to the names of the
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
    };
  }

  // Convert a Map into a Series. The keys must correspond to the names of the
  // fields in your JSON.
  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      name: json['name'],
      description: json['description'],
      photo: json['photo'],
      language: json['language'],
      url: json['url'],
      duration: json['duration'],
      year: json['year'],
    );
  }
}
