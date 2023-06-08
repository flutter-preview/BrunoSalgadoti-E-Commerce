class Delivery {
  Delivery(
      { this.baseprice,
        this.km,
        this.lat,
        this.long,
        this.maxkm,});

  num? baseprice;
  num? km;
  double? lat;
  double? long;
  num? maxkm;

  //Valores iniciais levando em conta o centro da cidade em questão
  num basepriceFromAdmin = 5;
  num kmFromAdmin = 0.5;
  double latFromAdmin = -9.4001;
  double longFromAdmin = -38.2176;
  num maxkmFromAdmin = 30;

  Delivery.fromMap(Map<String, dynamic> map) {
    baseprice = map['baseprice'] as num;
    km = map['km'] as num;
    lat = map['lat'] as double;
    long = map['long'] as double;
    maxkm = map['maxkm'] as num;
  }

  Map<String, dynamic> toMap() {
    return {
      'baseprice': basepriceFromAdmin,
      'km': kmFromAdmin,
      'lat': latFromAdmin,
      'long': longFromAdmin,
      'maxkm': maxkmFromAdmin,
    };
  }
}
