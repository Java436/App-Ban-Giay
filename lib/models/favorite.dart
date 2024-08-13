class Favorite {
  final String userId;
  final String shoeId;

  Favorite({required this.userId, required this.shoeId});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      userId: json['userId'],
      shoeId: json['shoeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'shoeId': shoeId,
    };
  }
}