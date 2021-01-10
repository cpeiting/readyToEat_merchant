
class RestaurantInfo {
  final String address;
  final String categories;
  final String facebook_url;
  final String restaurantName;
  final String phone;
  final String time;

  RestaurantInfo(
      {this.address,
        this.categories,
        this.facebook_url,
        this.restaurantName,
        this.phone,
        this.time});

  factory RestaurantInfo.fromJson(Map<String, dynamic> json) {
    return RestaurantInfo(
      address: json['address'] as String,
      categories: json['categories'] as String,
      facebook_url: json['facebook_url'] as String,
      restaurantName: json['restaurantName'] as String,
      time: json['time'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'address': address,
    'categories': categories,
    'facebook_url': facebook_url,
    'restaurantName': restaurantName,
    'phone': phone,
    'time': time,
  };
}



class RestaurantMenu {
  final String content;
  final String price;
  final String title;


  RestaurantMenu(
      {this.content,
        this.price,
        this.title,
      });

  factory RestaurantMenu.fromJson(Map<String, dynamic> json) {
    return RestaurantMenu(
      content: json['content'] as String,
      price: json['price'] as String,
      title: json['title'] as String,

    );
  }

  Map<String, dynamic> toJson() => {
    'content': content,
    'price': price,
    'title': title,

  };
}
