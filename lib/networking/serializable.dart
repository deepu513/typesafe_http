abstract class Serializable<T> {
  T fromJson(Map<String, dynamic> json);
  List<T> fromJsonArray(List<dynamic> jsonArray);
  Map<String, dynamic> toJson(T t);
  List<dynamic> toJsonArray(List<T> tList);
}