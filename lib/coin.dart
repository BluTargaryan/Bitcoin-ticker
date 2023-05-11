import 'networking.dart';
//Api key and url
const apiKey = 'ACCC3B4C-10D7-4F09-8369-2614ECF556AF';
const hostURL = 'https://rest.coinapi.io/v1/exchangerate';
class Coin{
  Future <dynamic> getCoinData(String coin, String currency)async{
    var url = '$hostURL/$coin/$currency&apikey=$apiKey';
    NetworkHelper networkHelper = NetworkHelper(url);
    var coinData = await networkHelper.getData();
    return coinData;
  }

}