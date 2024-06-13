//
//  HomeViewModel.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/5/24.
//

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
    let randomVerses = BehaviorRelay<[String]>(value: [])
    
    // 구절 길이 계산
    func getVerseLength(from verses: [String]) -> Int {
        verses.reduce(0) { result, verse in result + verse.count }
    }
    
    // 현재 구절 길이 기반으로 현재 레벨 계산
    func getVerseLevel(for verseLength: Int) -> Int {
        for (index, card) in levelCards.enumerated() {
            if verseLength < card.length {
                return index + 1
            }
        }
        return 1
    }

    
    init() {
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
                
                // 현재, 다음레벨 이미지 적용
                let currentLevelImage = self.levelCards[max(0, verseLevel - 1)].cardImage
                let nextLevelImage = self.levelCards[min(verseLevel, self.levelCards.count - 1)].cardImage
                
                self.currentLevel.accept(verseLevel)
                self.currentLevelPercent.accept(currentLevelPercent)
                self.currentLevelImage.accept(currentLevelImage)
                self.nextLevelImage.accept(nextLevelImage)
            })
            .disposed(by: disposeBag)
        
        // 테스트 구문추가
        verses.accept(["1", "2", "3", "4", "5", "나는 행복하지 않기 때문에 불행한 것이 아니다.", "당신이 세상에서 보고 싶은 변화가 되어라.", "전쟁은 평화다. 자유는 굴레다. 무지는 힘이다.", "인간은 패배하기 위해 태어난 것이 아니다. 인간은 파괴될 수는 있어도 패배하지는 않는다.", "죽지 못할 것은 살지 못한다.", "오만은 우리 자신을, 편견은 다른 사람들을 생각하는 데서 비롯된다.", "희망은 깃털을 달고 영혼에 앉아 노래하는 것." ])
        
        loadTodayVerses()
    }
    
    // 매일 5개의 랜덤구절을 저장하고 불러오는 함수
    private func loadTodayVerses() {
        print(#function, "start")
        
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        print("todaty \(today)")
        let savedDate = UserDefaults.standard.string(forKey: "savedDate")
        
        // 날짜에 따른 구절 업데이트
        if today != savedDate {
            // 오늘이 아니면 랜덤 5개의 구절 저장
            let shuffled = verses.value.shuffled().prefix(5).map { $0 }
            print("shuffled \(shuffled)")
            randomVerses.accept(Array(shuffled))
            UserDefaults.standard.set(today, forKey: "savedDate")
            UserDefaults.standard.set(shuffled, forKey: "shuffledVerses")
        } else {
            if let savedVerses = UserDefaults.standard.array(forKey: "shuffledVerses") as? [String] {
                randomVerses.accept(savedVerses)
            } else {
                let shuffled = verses.value.shuffled().prefix(5).map { $0 }
                print("shuffled \(shuffled)")
                randomVerses.accept(Array(shuffled))
                UserDefaults.standard.set(today, forKey: "savedDate")
                UserDefaults.standard.set(shuffled, forKey: "shuffledVerses")
            }
        }
        print(#function, "end")
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
}

