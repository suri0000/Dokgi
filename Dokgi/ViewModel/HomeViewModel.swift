//
//  HomeViewModel.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/5/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class HomeViewModel {
    let disposeBag = DisposeBag()
    var levelCards: [Card] { DataManager.shared.cards }
    
    let currentLevel = BehaviorRelay<Int>(value: 1)
    let currentLevelPercent = BehaviorRelay<Double>(value: 0)
    let verses = BehaviorRelay<[String]>(value: [])
    
    let currentLevelImage = BehaviorRelay<UIImage?>(value: UIImage(named: ""))
    let nextLevelImage = BehaviorRelay<UIImage?>(value: UIImage(named: ""))
    
    // 구절 길이 계산
    func getVerseLength(from verses: [String]) -> Int {
        verses.reduce(0) { result, verse in result + verse.count }
    }
    
    // 현재 구절 길이 기반으로 현재 레벨 계산
    func getVerseLevel(for verseLength: Int) -> Int {
//        var level = 1
//        var position = verseLength
//        for card in levelCards {
//            position -= card.length
//            if position < 0 {
//                break
//            }
//            else {
//                level += 1
//            }
//        }
//        return level
        for (index, card) in levelCards.enumerated() {
            if verseLength < card.length {
                return index + 1
            }
        }
        return 1
    }

    
    init() {
        // Rx 방식
//        DataManager.shared.currentLevel
//            .subscribe(onNext: { [weak self] value in
//                print("value: \(value)")
//                self?.currentLevel.accept(value)
//            })
        
        // Notification 방식
//        NotificationCenter.default.addObserver(self, selector: #selector(onCurrentLevelChanged), name: Notification.Name("CURRENT_LEVEL_CHANGED"), object: nil)
        
//        let level = DataManager.shared.currentLevel // 코어데이터에서 가져오기
        
        verses
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                print("verses changed \(value)")
                
                // 현재 구절길이와 레벨
                let verseLength = self.getVerseLength(from: value)
                let verseLevel = self.getVerseLevel(for: verseLength)
                
                // 현재 레벨 퍼센트
                let prevLevelCardLength = verseLevel == 1 ? 0 : self.levelCards[verseLevel - 2].length
                let currentLevelCardLength = self.levelCards[verseLevel - 1].length
                let currentLevelPercent = Double(verseLength - prevLevelCardLength) / Double(currentLevelCardLength - prevLevelCardLength)
                print("구문 글자수: \(verseLength)")
                print("구문 레벨: \(verseLevel)")
                print("현재 레벨 퍼센티지: \(currentLevelPercent)")
                
                // 현재, 다음레벨 이미지 적용
                let currentLevelImage = self.levelCards[max(0, verseLevel - 1)].cardImage
                let nextLevelImage = self.levelCards[min(verseLevel, self.levelCards.count - 1)].cardImage
                print("현재레벨이미지 \(currentLevelImage)")
                print("다음레벨이미지 \(nextLevelImage)")
                
                self.currentLevel.accept(verseLevel)
                self.currentLevelPercent.accept(currentLevelPercent)
                self.currentLevelImage.accept(currentLevelImage)
                self.nextLevelImage.accept(nextLevelImage)
            })
            .disposed(by: disposeBag)
        
        // 테스트 구문추가
        verses.accept(["안녕하세요", "안녕하세요. 누구입니다.", "hello", "안녕하세요", "안녕하세요", "안녕하세요", "안녕하세요. 누구입니다.", "hello", "안녕하세요", "안녕하세요"])
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
//            self?.addVerse("askljdjflkasjdfjsakldf kalsjdflkasj dfjkalsd fjklasjdfk lj")
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
//            self?.addVerse("askljdjflk")
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) { [weak self] in
//            self?.clearVerse()
//        }
    }
    // 구절추가 테스트 함수
    func addVerse(_ verse: String) {
        var verseList = verses.value
        verseList.append(verse)
        verses.accept(verseList)
    }
    
    // 구절 삭제 테스트 함수
    func clearVerse() {
        verses.accept([])
    }
    
//    @objc func onCurrentLevelChanged(_ noti: Notification) {
//        let level = DataManager.shared.currentLevel // 코어데이터에서 가져오기
//        currentLevel.accept(level)
//    }
}

