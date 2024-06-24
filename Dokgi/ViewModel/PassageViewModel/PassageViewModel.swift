//
//  ParagraphViewModel.swift
//  Dokgi
//
//  Created by 예슬 on 6/17/24.
//

import Foundation
import RxCocoa
import RxSwift

class PassageViewModel {
    var disposeBag = DisposeBag()
    var passageData = BehaviorRelay<[(String, Date)]>(value: [])
    var detailPassage = BehaviorRelay<Passage>(value: Passage(title: "", passage: "", page: 0, pageType: true, date: Date(), keywords: []))
    
    init() {
        passageData.accept(
            CoreDataManager.shared.passageData.value.map { ($0.passage, $0.date) }
        )
    }
    
    func selectPassage(text: String, at index: Int) {
            let selectedText = text
            if let selectedVerse = CoreDataManager.shared.passageData.value.first(where: { $0.passage == selectedText }) {
                detailPassage.accept(selectedVerse)
            }
        }
}
