//
//  DataManager.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/5/24.
//

import UIKit

struct Card {
    var cardImage: UIImage?
    var level: Int
    var descrption: String
    var length: Int
}

class DataManager {
    static let shared = DataManager()
    private init() {}
    let cardInfo: [Card] = [
        Card(cardImage: UIImage(named: "grape"), level: 1, descrption: "포도 한 알", length: 20),
        Card(cardImage: UIImage(named: "goni"), level: 2, descrption: "고니가 잰 길이", length: 30),
        Card(cardImage: UIImage(named: "golfBall"), level: 3, descrption: "골프공", length: 42),
        Card(cardImage: UIImage(named: "airPod"), level: 4, descrption: "에어팟", length: 45),
        Card(cardImage: UIImage(named: "card"), level: 5, descrption: "신용카드", length: 54),
        Card(cardImage: UIImage(named: "tennisBall"), level: 6, descrption: "테니스공", length: 68),
        Card(cardImage: UIImage(named: "cottonStick"), level: 7, descrption: "면봉", length: 73),
        Card(cardImage: UIImage(named: "iPhone"), level: 8, descrption: "아이폰 12 Pro", length: 146),
        Card(cardImage: UIImage(named: "can"), level: 9, descrption: "캔 음료수", length: 200),
        Card(cardImage: UIImage(named: "scooerBall"), level: 10, descrption: "축구공", length: 220),
        Card(cardImage: UIImage(named: "A4Paper"), level: 11, descrption: "A4 용지", length: 297),
        Card(cardImage: UIImage(named: "keyboard"), level: 12, descrption: "키보드", length: 450),
        Card(cardImage: UIImage(named: "refrigerator"), level: 13, descrption: "냉장고 높이", length: 1600),
        Card(cardImage: UIImage(named: "eagle"), level: 14, descrption: "독수리 날개 길이", length: 2300),
        Card(cardImage: UIImage(named: "streetLamp"), level: 15, descrption: "가로등 높이", length: 4500),
        Card(cardImage: UIImage(named: "kingSejong"), level: 16, descrption: "세종대왕 동상 높이", length: 6200),
        Card(cardImage: UIImage(named: "apart"), level: 17, descrption: "4층 아파트 높이", length: 12000),
        Card(cardImage: UIImage(named: "shinRamen"), level: 18, descrption: "신라면 면발 길이", length: 50000),
        Card(cardImage: UIImage(named: "soccerField"), level: 19, descrption: "축구장", length: 110000),
        Card(cardImage: UIImage(named: "EffelTower"), level: 20, descrption: "에펠탑 높이", length: 330000),
        Card(cardImage: UIImage(named: "ktx"), level: 21, descrption: "KTX", length: 338100),
        Card(cardImage: UIImage(named: "everest"), level: 22, descrption: "에베레스트", length: 8849000),
        Card(cardImage: UIImage(named: "marathon"), level: 23, descrption: "마라톤 풀코스", length: 42000000),
        Card(cardImage: UIImage(named: "SeoulToBusan"), level: 24, descrption: "서울에서 부산", length: 320000000)
    ]
}
