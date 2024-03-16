class Qualification {
  String? file;
  String? degree;
  String? university;
  var year;

  Qualification({this.file, this.degree, this.university, this.year});

  factory Qualification.fromJson(Map<String, dynamic> json) {
    return Qualification(
      file: json['file'],
      degree: json['degree'],
      university: json['university'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file'] = this.file;
    data['degree'] = this.degree;
    data['university'] = this.university;
    data['year'] = this.year;
    return data;
  }
}
