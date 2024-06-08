//
//  HomeViewModel.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/5/24.
//

import Foundation

class HomeViewModel {
    let data: [Card] = DataManager.shared.cardInfo
    
    var currentSelectedIndex = 0
    
    // 저장된 현재 구절 길이 계산
    func getCurrentLength(from strings: [String]) -> Int {
        var totalLength = 0
        for string in strings {
            totalLength += string.count
        }
        return totalLength
    }
    
    // 현재 구절 길이 기반으로 현재 레벨 계산
    func getCurrentLevel(for length: Int) -> Int {
        for (index, card) in data.enumerated() {
            if length < card.length {
                return index
            }
        }
        return data.count - 1
    }
    
    func getCardIndex(forTotalLength totalLength: Int) -> Int {
        let currentLevel = getCurrentLevel(for: totalLength)
        return currentLevel
    }
    

}

