//class Deck {
//  List<Card> cards = [];
//
//  Deck() {
//    var ranks = ['Ace', 'Tow', 'Three', 'Four', 'Five'];
//    var suits = ['Diamonds', 'Hearts', 'Clubs', 'Spades'];
//
//    for (var suit in suits) {
//      for (var rank in ranks) {
//        Card card = Card(suit, rank);
//        cards.add(card);
//        cards.shuffle();
//      }
//    }
//  }
//  cardsWithSuit(String keyword) {
//    return cards.where((card) => card.suit == keyword);
//  }
//
//  deal(int handSize) {
//    var hand = cards.sublist(0, handSize);
//    cards = cards.sublist(handSize);
//    return hand;
//  }
//
//  remove(String suitKeyword, String rankKeyword) {
//    cards.removeWhere((element) {
//      return element.suit == suitKeyword && element.rank == rankKeyword;
//    });
//  }
//
//  @override
//  String toString() {
//    return '$cards';
//  }
//}
//
//class Card {
//  var suit;
//  var rank;
//  Card(this.suit, this.rank);
//
//  @override
//  String toString() {
//    return "$rank Of $suit ";
//  }
//}
//
//class shape<T> {
//  insret(T s) {}
//}
//
//class circle {
//  insret() {}
//}
//
//class squer {
//  insret() {}
//}
//
//void main() {
//  var ss = shape<circle>();
//  ss.insret(circle());
//  print(": ${ss} ");
//
//  //  var deck = Deck();
////
////  print("Orginal List : ${deck}  ------ List Size Is :  ${deck.cards.length}");
////  deck.remove("Diamonds", " Ace");
////  print("After Remove From List : ${deck}  ------ List Size Is :  ${deck.cards.length}");
////
////  //  print("Filterd List : ${deck.deal(15)}  ------ List Size Is : ${deck.cards.length}");
////
////  //  print("Orginal List After Deal Method : ${deck}  ------ List Size Is :  ${deck.cards.length}");
//}
