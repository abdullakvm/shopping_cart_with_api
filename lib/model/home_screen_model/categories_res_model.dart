// To parse this JSON data, do
//
//     final categoriesResModel = categoriesResModelFromJson(jsonString);

import 'dart:convert';

List<CategoriesResModel> categoriesResModelFromJson(String str) => List<CategoriesResModel>.from(json.decode(str).map((x) => CategoriesResModel.fromJson(x)));

String categoriesResModelToJson(List<CategoriesResModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesResModel {
    String? slug;
    String? name;
    String? url;

    CategoriesResModel({
        this.slug,
        this.name,
        this.url,
    });

    factory CategoriesResModel.fromJson(Map<String, dynamic> json) => CategoriesResModel(
        slug: json["slug"],
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "slug": slug,
        "name": name,
        "url": url,
    };
}
